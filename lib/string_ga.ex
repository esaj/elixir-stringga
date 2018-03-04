defmodule StringGa do
  @moduledoc """
  Documentation for StringGa.
  """
  import Randomizer

  @doc """
  Hello world.

  """

  defmodule Settings do
    defstruct mutation: 5, crossover: 50, population_size: 30, new_random_gene: 10, target: nil
  end

  defmodule Genome do
    defstruct genes: [], fitness: nil
  end

  def start(target) when byte_size(target) == 0 do :giveTargetString end

  def start(target) do
    if(String.match?(target, ~r/^[a-zA-Z0-9\.()+-_ ?!\"]+$/))  do
      settings = %Settings{target: target}
      genomes = generateFirstGeneration(settings)
      runGeneration(genomes, settings, 1)
    else
      IO.puts("Allowed chars are space, dot, a..z, A..Z and numbers from 0 to 9, and characters ()+-_?!\"")
    end
  end

  @doc """
    Creates the next generation based on elites (the best surviving genomes across
    all generations), previous generation and current mutation/crossover etc. -
    settings
  """
  #def runGeneration(_elites, prevGeneration = %GenePool{}, _settings = %Settings{}) do

  def runGeneration(generation, settings = %Settings{}, genCount) do
    #Store only top half of the original generation for breeding
    remaining = Enum.take(scoreGeneration(generation, settings.target), div(settings.population_size, 2))
    bestCandidate = hd remaining

    if(bestCandidate.fitness != 0) do
      #No perfect fit yet, continue on

      #Fill the generation with copies of the "top" genomes
      prevGen = List.flatten(for _i <- 1..10 do
        Enum.map(remaining,
          fn(x) ->
            if(:rand.uniform(100) <= settings.mutation) do
              %Genome{genes: mutateString(x.genes, settings)}
            else
              %Genome{genes: x.genes}
            end
          end)
        end)

      #Mutate & breed a new generation and run a new generation until perfect fit is found
      if(rem(genCount, 10) == 0) do
        IO.puts(Integer.to_string(genCount) <> ". generation, best fitness: " <> Integer.to_string(bestCandidate.fitness) <> ", genome: " <> bestCandidate.genes);
      end
      prevGen = mutate(prevGen, settings)
      prevGen = breed(prevGen, settings)
      #Simple selective breeding: replace first genome with the last best candidate so it doesn't get lost
      prevGen = [ bestCandidate | tl prevGen ]
      runGeneration(prevGen, settings, genCount + 1)
    else
      IO.puts("Solution found at generation " <> Integer.to_string(genCount))
      bestCandidate
    end
  end

  def mutate(prevGeneration, settings = %Settings{}) do
    parallel_map(prevGeneration,
        fn(x) ->
          if(:rand.uniform(100) <= settings.mutation) do
            %Genome{genes: mutateString(x.genes, settings)}
          else
            %Genome{genes: x.genes}
          end
        end)
  end

  defp mutateString(str, settings = %Settings{}) do
    List.to_string(Enum.map(to_charlist(str), fn(chr) ->
      if(:rand.uniform(100) <= settings.mutation) do
        mutateChar(chr)
      else
        chr
      end
    end))
  end

  defp mutateChar(char) do
    chr = char + :rand.uniform(3) - 2
    if(chr < 32) do #space
      chr = 32
    else if(chr > 126) do
        chr = 126
      end
    end
    chr
  end

  def breed(prevGeneration, settings = %Settings{}) do
    len = String.length(settings.target)
    parallel_map(prevGeneration,
      fn(x) ->
        if(:rand.uniform(100) <= settings.crossover) do
          (Enum.random(prevGeneration) |> fn(y) ->
            %Genome{genes: joinStrings(x.genes, y.genes) }
          end.())
        else if (:rand.uniform(100) <= settings.new_random_gene) do
            #Injecting totally random new genes here and there can prevent the gene pool from stagnating through inbreeding
            generateRandomGenome(len)
          else
            %Genome{genes: mutateString(x.genes, settings)}
          end
        end
      end)
  end

  def joinStrings(str1, str2) do
    len = String.length(str1) - 1
    cutoff = :rand.uniform(len)+1
    String.slice(str1, 0..cutoff) <> String.slice(str2, (cutoff+1)..(len-1))
  end


  def generateFirstGeneration(settings = %Settings{}) do
    for _n <- 1..settings.population_size do
      generateRandomGenome(String.length(settings.target))
    end
  end

  def generateRandomGenome(len) do
    %Genome{genes: randomizer(len)}
  end

  @doc """
    Scores the genepool of a generation by calculating fitness for each genome and sorting the pool
  """
  def scoreGeneration(genomes, target) do
    #Sorting in ascending order (smaller fitness = better, as the fitness is actually an error term in this implementation)
    Enum.sort(Enum.map(genomes, fn(x) -> %{x | fitness: stringDistance(x.genes, target)} end ), &(&1.fitness <= &2.fitness))
  end

  defp stringDistance(str1, str2) when byte_size(str1) == 0 or byte_size(str2) == 0
    or byte_size(str1) != byte_size(str2) do :emptyStringsOrLengthsDontMatch end

  defp stringDistance(str1, str2) do
    str1 |> String.to_charlist |> Enum.zip(str2 |> String.to_charlist ) |> Enum.reduce(0, fn({cp1, cp2}, acc) -> acc + abs(cp1 - cp2) end)
  end

  #Taken from here:  https://gist.github.com/boudra/406d69a37e636b4fc3f0910e911913d3
  #Since the tasks of computing each genome per generation is parallelizable, why not?
  def parallel_map(enum, cb) do
    Enum.map(enum, &(Task.async(fn() -> apply(cb, [&1]) end)))
    |> Enum.map(&Task.await(&1))
  end

end
