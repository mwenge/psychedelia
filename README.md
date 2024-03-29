# Psychedelia/Colourspace (1984 - 1987) by Jeff Minter

<img src="https://user-images.githubusercontent.com/58846/114322625-29a37d00-9b19-11eb-988a-7869a3c54060.png" height=300><img src="https://user-images.githubusercontent.com/58846/114322575-e3e6b480-9b18-11eb-8371-2cbcb760330b.gif" height=300>

This repository collects the reverse-engineered and [commented source code] for the early "light-synthesizer" projects by Jeff Minter. 

This repository is part of the [llamasource project](https://mwenge.github.io/llamaSource/). For other light synthesizer projects see llamasource's [Virtual Light Machine](https://github.com/mwenge/vlm) repository, which contains the reconstructed source code for the second-generation of Minter's light synthesizer work on the Atari Jaguar.

[Psychedelia] was Minter's [first realized concept] for a light synthesizer and
was implemented originally on the C64. The idea is that you manipulate the
display on the screen to accompany music. He ported Psychedelia to the Vic20 and
the Commodore 16. He then developed the idea further with Colourspace on the Atari 800.
The subsequent version of Colourspace for the Atari ST took the concept even further. This
was followed by [Trip-a-Tron] on the Atari ST and [Neon] , which was built into the X360 XBox console.

# Psychedelia: The Book
[<img height=360 src="https://github.com/mwenge/psypixels/raw/master/src/cover/pdf/cover_front.svg">](https://github.com/mwenge/psypixels/releases/download/v0.01/psychedelia.syndrome.pixels.and.code.pdf)

If you want to read more about Psychedelia than is possibly healthy, you can try the current state of 
a work-in-progress, omnium-gatherum called [psychedelia syndrome](https://github.com/mwenge/psypixels/releases/download/v0.01/psychedelia.syndrome.pixels.and.code.pdf).

You can [gift what you want](https://www.paypal.com/paypalme/hoganrobert).

You can even [sponsor future work](https://github.com/sponsors/mwenge/).

### A Peek Inside
<img height=460 src="https://github.com/mwenge/psypixels/raw/master/out/page1.png"><img height=460 src="https://github.com/mwenge/psypixels/raw/master/out/page2.png">

# Play in your Browser
To get the most out of Psychedelia, you should read [the manual](MANUAL-C64.md).

[C64:](https://mwenge.github.io/psychedelia/c64/) (Ctrl key is 'Fire', Arrow Keys to move.)

[Vic20:](https://mwenge.github.io/psychedelia/vic20/) (Ctrl key is 'Fire', Arrow Keys to move.)

[Atari800:](https://mwenge.github.io/psychedelia/atari800/?disk_filename=colourspace.atr) (Alt key is 'Fire', Arrow Keys to move.)

You can also take a look at the [demo wall for the Vic 20](https://mwenge.github.io/psychedelia/vic20/wall.html).

# Psychedelia Demo listing in Popular Computer Magazine
<img height=360 src="https://github.com/mwenge/psychedelia-listing/raw/master/listing/PopularComputing_Weekly_Issue_1984-12-13_0031.jpg"><img height=360 src="https://github.com/mwenge/psychedelia-listing/assets/58846/b6027f6d-f5ac-4af6-be4a-53ddce8c1728">

A demo version of Psychedelia appeared as a type-in listing in 'Popular Computing Magazine' in December 1984. 

## Try it online
You can [play it without installing anything here.](https://lvllvl.com/c64/?gid=59db254ccc74c65007c58a890ccf31af)

## Setup
On Ubuntu you can install [VICE] as follows:
```
sudo apt install vice
```

## Build Instructions
To compile and run:

```sh
$ make runlisting
```

To just compile the game and get a binary (`psychedelia.prg`) do:

```sh
$ make psychedelia-listing.prg
```


# Psychedelia for the C64
<img src="https://user-images.githubusercontent.com/58846/103469199-9e685d80-4d59-11eb-96c8-386b3a530809.png" height=300><img src="https://user-images.githubusercontent.com/58846/103463469-7dd1e080-4d24-11eb-93d2-7673ba031074.gif" height=300>

## Requirements
* [VICE][vice] - The most popular C64 emulator
* [64tass][64tass] - An assembler for 6502 source code.

## Setup
On Ubuntu you can install [VICE] as follows:
```
sudo apt install vice
```

## Build Instructions
To compile and run:

```sh
$ make
```

To just compile the game and get a binary (`psychedelia.prg`) do:

```sh
$ make psychedelia.prg
```

# Psychedelia for the Vic20
<img src="https://user-images.githubusercontent.com/58846/114322304-4c349680-9b17-11eb-9fb1-610d6d0715a3.png" height=300><img src="https://user-images.githubusercontent.com/58846/114322413-00ceb800-9b18-11eb-88a5-387b2dbbea83.gif" height=300>
## Requirements
* [VICE][vice] - The most popular C64/Vic20 emulator
* [64tass][64tass] - An assembler for 6502 source code.

## Build Instructions
To compile and run:

```sh
$ make runvic
```

To just compile the game and get a binary (`psychedelia-vic20.prg`) do:

```sh
$ make psychedelia-vic20.prg
```

# Psychedelia for the C16
<img src="https://user-images.githubusercontent.com/58846/114454071-19030d80-9bd2-11eb-97bd-c8833e3df257.png" height=250><img src="https://user-images.githubusercontent.com/58846/114454575-ab0b1600-9bd2-11eb-98fc-9e7dbc427a10.gif" height=250>
## Requirements
* [VICE][vice] - The most popular C64/Vic20 emulator
* [64tass][64tass] - An assembler for 6502 source code.

## Build Instructions
To compile and run:

```sh
$ make runc16
```

To just compile the game and get a binary (`psychedelia-c16.prg`) do:

```sh
$ make psychedelia-c16.prg

```
# Colourspace (1985) for the Atari 800
<img src="https://user-images.githubusercontent.com/58846/114322266-142d5380-9b17-11eb-8a55-316121c5803b.png" height=300><img src="https://user-images.githubusercontent.com/58846/114322429-1e9c1d00-9b18-11eb-8b5a-d97bc1aa52c4.gif" height=300>

## Requirements
* [Atari800 Emulator][atari800] - An Atari 400/8000 emulator
* [64tass][64tass] - An assembler for 6502 source code.

## Build Instructions
To compile and run:

```sh
$ make runatari
```

To just compile the game and get a binary (`colourspace.xex`) do:

```sh
$ make colourspace.xex
```

[64tass]: http://tass64.sourceforge.net/
[vice]: http://vice-emu.sourceforge.net/
[play in your browser can be found here]: https://mwenge.github.io/psychedelia
[commented source code]:https://github.com/mwenge/psychedelia/blob/master/src/
[Trip-a-Tron]: https://en.wikipedia.org/wiki/Trip-a-Tron
[Neon]: https://en.wikipedia.org/wiki/Neon_(light_synthesizer)
[first realized concept]: http://www.minotaurproject.co.uk/psychedelia.php
[Psychedelia]: https://en.wikipedia.org/wiki/Psychedelia_(light_synthesizer)
[atari800]: https://atari800.github.io/
[hatari]: https://hatari.tuxfamily.org/download.html
