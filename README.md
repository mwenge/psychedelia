# Psychedelia/Colourspace (1984 - 199X) by Jeff Minter

<img src="https://user-images.githubusercontent.com/58846/103469199-9e685d80-4d59-11eb-96c8-386b3a530809.png" height=300><img src="https://user-images.githubusercontent.com/58846/103463469-7dd1e080-4d24-11eb-93d2-7673ba031074.gif" height=300>

This repository collects the reverse-engineered and [commented source code] for the "light-synthesizer" projects by Jeff Minter. 

[Psychedelia] was Minter's [first realized concept] for a light synthesizer and
was implemented originally on the C64. The idea is that you manipulate the
display on the screen to accompany music. He ported Psychedelia to the Vic20 and
the Commodore 16. He then developed the idea further with Colourspace on the Atari 800.
The subsequent version of Colourspace for the Atari ST took the concept even further. This
was followed by [Trip-a-Tron] on the Atari ST and [Neon] , which was built into the X360 XBox console.

## Play in your Browser
To get the most out of Psychedelia, you should read [the manual](MANUAL.md).

[C64:](https://mwenge.github.io/psychedelia/c64/) (Ctrl key is 'Fire', Arrow Keys to move.)

[Vic20:](https://mwenge.github.io/psychedelia/vic20/) (Ctrl key is 'Fire', Arrow Keys to move.)

[Atari800:](https://mwenge.github.io/psychedelia/atari800/?disk_filename=colourspace.atr) (Alt key is 'Fire', Arrow Keys to move.)


## Building Psychedelia for the C64
<img src="https://www.mobygames.com/images/covers/l/34991-psychedelia-commodore-64-front-cover.jpg" height=300><img src="https://user-images.githubusercontent.com/58846/103443482-9fb16180-4c57-11eb-9403-4968bd16287f.gif" height=300>

### Requirements
* [VICE][vice] - The most popular C64 emulator
* [64tass][64tass] - An assembler for 6502 source code.

### Setup
On Ubuntu you can install [VICE] as follows:
```
sudo apt install vice
```

### Compiling
To compile and run:

```sh
$ make
```

To just compile the game and get a binary (`psychedelia.prg`) do:

```sh
$ make psychedelia.prg
```

## Building Psychedelia for the Vic20
<img src="https://user-images.githubusercontent.com/58846/114322304-4c349680-9b17-11eb-9fb1-610d6d0715a3.png" height=300><img src="https://user-images.githubusercontent.com/58846/114322413-00ceb800-9b18-11eb-88a5-387b2dbbea83.gif" height=300>
### Requirements
* [VICE][vice] - The most popular C64/Vic20 emulator
* [64tass][64tass] - An assembler for 6502 source code.

### Compiling
To compile and run:

```sh
$ make runvic
```

To just compile the game and get a binary (`psychedelia-vic20.prg`) do:

```sh
$ make psychedelia-vic20.prg
```

## Building Psychedelia for the C16
<img src="https://user-images.githubusercontent.com/58846/114322304-4c349680-9b17-11eb-9fb1-610d6d0715a3.png" height=300><img src="https://user-images.githubusercontent.com/58846/114268079-27e19880-99f7-11eb-9e1a-87995309b96b.gif" height=300>
### Requirements
* [VICE][vice] - The most popular C64/Vic20 emulator
* [64tass][64tass] - An assembler for 6502 source code.

### Compiling
To compile and run:

```sh
$ make runc16
```

To just compile the game and get a binary (`psychedelia-c16.prg`) do:

```sh
$ make psychedelia-c16.prg

```
## Building Colourspace for the Atari 800
<img src="https://user-images.githubusercontent.com/58846/114322266-142d5380-9b17-11eb-8a55-316121c5803b.png" height=300><img src="https://user-images.githubusercontent.com/58846/114322429-1e9c1d00-9b18-11eb-8b5a-d97bc1aa52c4.gif" height=300>

### Requirements
* [Atari800 Emulator][atari800] - An Atari 400/8000 emulator
* [64tass][64tass] - An assembler for 6502 source code.

### Compiling
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
[commented source code]:https://github.com/mwenge/psychedelia/blob/master/src/psychedelia.asm
[Trip-a-Tron]: https://en.wikipedia.org/wiki/Trip-a-Tron
[Neon]: https://en.wikipedia.org/wiki/Neon_(light_synthesizer)
[first realized concept]: http://www.minotaurproject.co.uk/psychedelia.php
[Psychedelia]: https://en.wikipedia.org/wiki/Psychedelia_(light_synthesizer)

