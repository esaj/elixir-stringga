# Simple String Genetic Algorithm in Elixir

A relatively simple genetic / evolutionary algorithm that converges towards the given
target input strings. Granted, plain strings are very easy and straightforward to solve
with genetic algorithms (and for people who don't understand GA's it will look just like
a software that takes in a string and uses excessively high amounts of computing time to
output the same string ;) ), which makes it a bit boring. However, the point here is
actually to learn Elixir as a language, rather than build anything new or very efficient.

The GA-implementation represented in this project is hardly anything no-one has ever seen
before. You have your basic settings with mutation, crossover and population size. The only
a bit "out of the ordinary" setting is the "new_random_gene" which is a percentage value
between 0 and 100, and represents the chance of a totally new random gene being inserted
into the gene pool to prevent stagnation and inbreeding instead of a crossbred gene (so it's
still dependent on the crossover -setting to have effect). All the other values in the settings
are percentages (0-100, int) except population_size and target:

`defmodule Settings do
  defstruct mutation: 3, crossover: 50, population_size: 20, new_random_gene: 10, target: nil
end`

Like said, the algorithm is hardly anything to write home about, but I did learn a lot of the
Elixir syntax and, ahem, peculiarities. I shot myself in the foot at least once per every line
of code and did at least twice that amount of Google searches. I think I've still hardly scratched
the surface of functional programming, but after reading the "Introducing Elixir" -book and a
couple of books about "functional thinking", I think I've finally got at least the very basics
down. Likely the code still shows that my thinking is mostly in the imperative universe still...
Have to work on that.

I likely also misuse the terminology (genome, genes etc) a lot.


## Running

This is not a "complete" Elixir application. It's a "work in progress" and likely to remain
as such forever or thereabouts. At least I wouldn't be surprised if it would be just like this
10 years from the commit. ;)  There's no Erlang OTP / Application / Supervisor / GenServer or whatever
stuff for running it from command line, I've went with iex all the way to keep it simple. I still
underline that the entire point that this application exists is/was just to learn the basics of
the language and run ridiculously long calculations for long input strings like paragraphs from
Wikipedia that take something like more than a million generations to finish.

The algorithm starts with `StringGa.start`, taking the target string as an argument. The allowed
characters are letters a-z, A-Z, numbers 0-9, space and a small set of other characters like comma,
dot etc:

```
Interactive Elixir (1.6.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> StringGa.start("Testing invalid char #")
Allowed chars are space, dot, a..z, A..Z and numbers from 0 to 9, and characters ()+-_?!"
```
When given a valid string, the algorithm iterates until it finds a perfect match. Strings are a bit
unusual, as often genetic algorithms are used to solve much more complex problems that don't have
"perfect" solutions, or at least coming to such a solution would take a huge amount of time.

The algorithm outputs the current best every 10th generation to show where it's going. Some of the
output is cut out here for brevity:

```
iex(2)> StringGa.start("The quick brown fox jumps over the lazy dog")
10. generation, best fitness: 1076, genome: blMzDprbO34wuttDnWNTa4rwe8kqlQI9f6xXFrfrEwk
20. generation, best fitness: 1056, genome: blMzDprbP34vtssCnWNSb4qwg7jqlSG9g6wZFsfrEwi
30. generation, best fitness: 1035, genome: bkNzEprcO34vrtsCm[PSa5qth5mqkRI8f7wYFrirFuk
40. generation, best fitness: 1012, genome: ajNzFspcO23vtsrCm\OOa5oti6mriSI8g6vYFriqGsi
...
80. generation, best fitness: 939, genome: _kOvJplcO46souo@k^RRb8nri2oukYG;h:u]IsknIul
90. generation, best fitness: 921, genome: _kPvKqlcO45rouo@k`RPb8mri2oujYE;h:s]JslmJtl
100. generation, best fitness: 903, genome: _iPuLpldQ45roun@jbROc8mrj1ouj[E;h:r^KslmKtl
110. generation, best fitness: 888, genome: \hPuMqlcQ25rovo?kaSOe:mrj0oujZD;h;s_KtlmLum
...
310. generation, best fitness: 589, genome: Vh]jVtic\%?rowm2fo[FjHmps$ovek:BgAml[zt`Voh
320. generation, best fitness: 579, genome: Vh]kUuhc]"?rown0fo\FjGmps%ovek9BgBlk\zv`Vog
330. generation, best fitness: 568, genome: Th^iUtic\#?rown2go\EjGlps%ovem6ChDml]zw^Vph
...
450. generation, best fitness: 444, genome: ThebZuide Erown,eoc=jPmps$oveq0HhLakazyW\og
460. generation, best fitness: 435, genome: Theb\uice Frown+fod=jQnps$oveq0HhMakazyV\og
470. generation, best fitness: 425, genome: Theb]uicf Grown+fod=jRnps$ovfr0JhN`lazyU\og
...
610. generation, best fitness: 291, genome: TheUouibk Lrown$foi/j[nps over!TgS\lazyHdog
620. generation, best fitness: 284, genome: ThgSpuick Lrown%fpj0j[mps over ThTYkayyFdog
630. generation, best fitness: 277, genome: ThgSquick Mrown$foj/j[mps over UhTYkazyFdog
...
780. generation, best fitness: 170, genome: TheHpujck \rown fow$jemps over ahbMlazyBdog
790. generation, best fitness: 163, genome: ThdEquick [rown fow!jempt over ahcMlazy@cog
800. generation, best fitness: 156, genome: ThdDquibk [rown fox jfmpt over bhdLlazy?dof
...
920. generation, best fitness: 101, genome: The<quick broxn fox jqmps over lheDlazy8dog
930. generation, best fitness: 98, genome: The:quibk brown fox jqmps over lheDlazy7dog
940. generation, best fitness: 94, genome: The;quick brown fox jrmps over nheClazy7dog
...
1110. generation, best fitness: 32, genome: She#quick brown fox jumps over she5l`zy%dog
1120. generation, best fitness: 29, genome: The$quick brown fox jtmps over she3lazz#dog
1130. generation, best fitness: 26, genome: The$quick brown fox jtmps over the2lazy#dog
...
1220. generation, best fitness: 6, genome: The quick brown fox jumps over the&lazy dog
1230. generation, best fitness: 4, genome: The quick brown fox jumps over the$lazy dog
1240. generation, best fitness: 3, genome: The quick brown fox jumps over the#lazy dog
1250. generation, best fitness: 1, genome: The quick brown fox jumps over the!lazy dog
Solution found at generation 1259
%StringGa.Genome{
  fitness: 0,
  genes: "The quick brown fox jumps over the lazy dog"
}
iex(3)>
```

The fitness-function is actually an error term here, so the algorithm tries to minimize it, with 0 representing perfect match. Rest of the details you can probably work out from the code, if you're that interested ;)

I would have originally liked to recreate the "classic" Mona Lisa -GA with Elixir (I think the
very first and original "build Mona Lisa from 50 ARGB triangles"-thingamabob
is https://rogerjohansson.blog/2008/12/07/genetic-programming-evolution-of-mona-lisa/ ), which
is at least marginally more useful application of the algorithm, and looks really cool.

However, with the limited time I had, I didn't want to create an algorithm for writing the
pixels of a triangle into an array/list representing the image buffer myself, and after a
while of tweaking with the OpenGL for Elixir sample out there
( https://wtfleming.github.io/2016/01/06/getting-started-opengl-elixir/ ), the best I could
come up was to add alpha-blending and copying pixel data from the backbuffer, and that was
after several hours of time spent, leading to this:

https://imgur.com/ZAtLmhi


The point was to learn Elixir, not battle it out with wxWidgets & Erlang. ;) The example was
missing a lot of the constants alone, and sometimes would crash when copying pixels from
backbuffer so I decided I'd better not waste any more time on that and instead concentrate
on Elixir as a language...


## License:

If you see something here that you want to use, just grab it and run like hell. I really don't
care.

Everything I've written for the software (string_ga.ex) is under WTFPL (Do What The Fuck You
Want Public License). Contents of MiscRandom.ex were copied from
https://gist.github.com/ahmadshah/8d978bbc550128cca12dd917a09ddfb7 , I don't actually know
under what license that was... whoops? Hopefully I didn't break any laws there ;)

If you feel that you need some sort of (more or less) official license for the string_ga.ex,
here you go:

DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
            Version 2, December 2004

Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>

Everyone is permitted to copy and distribute verbatim or modified
copies of this license document, and changing it is allowed as long
as the name is changed.

    DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

0. You just DO WHAT THE FUCK YOU WANT TO.

http://www.wtfpl.net/
