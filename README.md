# Psychedelia by Jeff Minter

<img src="https://user-images.githubusercontent.com/58846/103469199-9e685d80-4d59-11eb-96c8-386b3a530809.png" height=300><img src="https://user-images.githubusercontent.com/58846/103463469-7dd1e080-4d24-11eb-93d2-7673ba031074.gif" height=300>

This is the disassembled and [commented source code] for the 1984 Commodore 64 "light-synthesizer" Psychedelia by Jeff Minter. 

[Psychedelia] was Minter's [first realized concept] for a light synthesizer. The idea is that you manipulate the display on the screen to accompany music. He later continued the idea in [Trip-a-Tron] and [Neon] , which was built into the X360 XBox console.

A version of the game you can [play in your browser can be found here]. (Use the arrow keys and `ctrl` to manipulate the display, or use a gamepad if you have one plugged in. See the manual below for more.)

## Requirements

* [64tass][64tass], tested with v1.54, r1900
* [VICE][vice]

[64tass]: http://tass64.sourceforge.net/
[vice]: http://vice-emu.sourceforge.net/
[play in your browser can be found here]: https://mwenge.github.io/psychedelia
[commented source code]:https://github.com/mwenge/psychedelia/blob/master/src/psychedelia.asm
[Trip-a-Tron]: https://en.wikipedia.org/wiki/Trip-a-Tron
[Neon]: https://en.wikipedia.org/wiki/Neon_(light_synthesizer)
[first realized concept]: http://www.minotaurproject.co.uk/psychedelia.php
[Psychedelia]: https://en.wikipedia.org/wiki/Psychedelia_(light_synthesizer)

To compile and run it do:

```sh
$ make
```
The compiled game is written to the `bin` folder. 

To just compile the game and get a binary (`psychedelia.prg`) do:

```sh
$ make psychedelia
```
## Psychedelia Manual (by Jeff Minter)


### AN ENTERTAINMENT by Jeff Minter......

An Explanation of the Concept...PSYCHEDELIA is really the
culmination of several months’ idle thinking. | love games, but
occasionally I'd think ‘there must be some OTHER way of enjoying
yourself using the computer...’ | also love music, and I'd daydream
about creating... something... you could do to music, something
you could put on the screen at a party and anyone could come up
and have a go, something you'd do just because you enjoyed it,
something others could enjoy even if they weren't actually doing it
themselves. Gradually the idea solidified into the concept of a
light-show generator, something interactive, creative but simple
enough so that anyone could do it, yet complex enough to produce
breathtaking results once learned well. A program to do for light, in
fact, what a synthesiser does for sound.

PSYCHEDELIA is the realisation of that dream. Some idle
tinkering on a Sunday afternoon produced such startling results
that all other work was dropped in order to pursue the development
of my Light Synthesiser at last. Many evenings were spent in
darkened rooms just freaking out to music and DOING it. Demos
were given, minds were blown and a good time had by all.
PSYCHEDELIA is a completely new way of enjoying your micro, If
you love music, if you love graphics, if you are creative then you'll
enjoy PSYCHEDELIA. You'll boot it in when you turn on your hi-fi.
You'll find an appeal totally different to that of even the best games.
You won't get bored, because the pleasure is as fundamental as
that of listening to music, and you'll create different, dynamic light
shows each time you use the program.

PSYCHEDELIA is the high point of my designing career so far. The
concept is simple, the programming not too complex but the parts
combine synergistically to create a whole which has given me the
most pleasure to use, and the biggest pride in design, of anything
I've ever programmed.

Enjoy PSYCHEDELIA. This one comes straight from the heart.

### Loading PSYCHEDELIA

Place the cassette in the tape deck.
Holding down the SHIFT key tap RUN/STOP. As prompted, press
PLAY on the deck. From this point loading is automatic. You'll see
various messages as the load progresses, and once loadings over
you'll see the basic PSYCHEDELIA screen, black with a single pixel
on it. You're now ready to go. Use a Joystick in Port 2 (the REAR
socket).

### Using PSYCHEDELIA
I'll give various levels of information, you
can enjoy even the simplest level but as you continue you'll
probably want to learn how to operate the Light Synthesiser’s
more complex options.

First encounter: (a) Turn off the lights. (b) Put on whatever music
you like to freak out to. (c) Pick up the joystick and do it with feeling.

Variations: Try pressing any of the top row of keys from Left-Arrow
up to Inst/Del. This calls in one of the 16 presets, stored
Lightsynth parameters which give different effects. Try them all
out io see some uf the multitude of effects which you cai achieve
using the system. Some are fast, some slow, some pulse, others
swirl. Play with them all, try them to different music.

### Basic Commands
Choose a pattern you like and get ready to
experiment. Press S to change the Symmetry. (The pattern gets
reflected in various planes, or not at all according to the setting).
Press SPACE to alter the pattern element. There are eight
permanent ones, and eight you can define for yourself (more on
this later!). The latter eight are all set up when you load, so you can
always choose from 16 shapes. Press UP-ARROW to change the
shape of the little pixels on the screen. Press L to turn on and off the
Line Mode - a bit like drawing with the Aurora Borealis.

### More Advanced Commands
I'll divide these into Variables and
Others. Variables, when activated, bring up a little graduated bar
at the bottom of the screen representing the current value of that
variable. Use the< and >keys to alter the value to what is required,
and press RETURN when you're happy: You can play with the
current settings while the bar is still on the screen, and with all
except two commands you can alter the parameters whilst pattern
generation is actually occurring. (Clever little things - those
interrupts!).

 
### Variable Commands

#### Cursor Speed
C to activate: Just that. Gives you a slow r fast
little cursor, according to setting. r

#### Pulse Speed
P to activate: Usually if you hold down the button
you get a continuous stream. Setting the Pulse Speed allows you to
generate a pulsed stream, as if you were rapidly pressing and
releasing the FIRE button.

#### Pulse Width
O to activate: Sets the length of the pulses in a
pulsed stream output. Don’t worry about what that means - just get
in there and mess with it.

#### Line Width
W to activate: Sets the width of the lines produced in
Line Mode.

#### Smoothing Delay
D to activate: Because of the time taken to
draw larger patterns speed increase/decrease is not linear. You
can adjust the ‘compensating delay’ which often smooths out jerky
patterns. Can be used just for special FX, though. Suck it and see.

#### Buffer Length
B to activate: Larger patterns flow more smoothly
with a shorter Buffer Length - not so many positions are retained
so less plotting to do. Small patterns with a long Buffer Length are
good for ‘steamer’ effects. N.B. Cannot be adjusted whilst
patterns are actually onscreen.

#### Sequencer Speed
V to activate: Controls the rate at which
sequencer feeds in its data. See the SEQUENCER bit.

#### BASE LEVEL
- to activate: Controls how many ‘levels’ of pattern
are plotted.

#### COLOUR change
H to activate: Allows you to set the colour for
each of the seven pattern steps. Set up the colour you want, press
RETURN, and the command offers the next colour along, up to no.
7, then ends. Cannot be adjusted while patterns being
generated.

### Now some other commands, not variables:

#### TRACKING on/off
T: Controls whether logic-seeking is used in
the buffer or not. The upshot of this for you is a slightly different
feel - continuous but fragmented when ON, or together-ish bursts
when OFF. Try it.

#### AUTO DEMO on/off
A: PSYCHEDELIA plays itself if you want.

#### PAUSE
Cursor Left/Right: Hold a particularly hoopy pattern.

#### STORE on PRESET KEY
SHIFT plus any of the top row of
preset keys: Stores all the parameters for later, instantaneous,
recall by pressing that preset key. Use to store your favourites for
recall instantly without fiddling with all the parameters. 16 presets
available.

#### RECORD/PLAYBACK
Shift-R to start recording, R to
playback or stop: PSYCHEDELIA can record about half-an-hours’
worth of joystick input in its memory. Start recording and play as
normal-you get a coloured border whilst recording. When you've
done enough press R to stop. Pressing R again starts playback. Try
playing back under different parameters, different presets etc.
Adjust parameters while you're playing back a display to see what
happens. PSY drops out of Record automatically, if it runs out of
memory. During playback it repeats the stored performance until R
is pressed to halt it.

#### BURST GENERATORS
SHIFT plus fkey to program, fkey alone
to activate. These allow you to preprogram and recall at will
instantaneous flashes on the screen. Set up symmetry and
smoothing delay as required, then press SHIFT plus the fkey to
which you want to assign your FX. Move the cursor to where you
want a burst then press Left-Arrow to enter that point. Do this up to
16 times. Press RETURN when done. Pressing the fkey thus
assigned stuffs all the points you defined into the buffer
instantaneously. Don’t worry about it - try the ones I've defined!

#### SEQUENCER
SHIFT-Q to ram, Q to toggle on/off:
Programming is as for the Burst Generators, but you have the
freedom of 255 steps allowed played back at varying speeds via the
Sequencer Speed control. You can leave the program mode in two
ways: press SPACE, and next time you go back in with SHIFT-Q the
stuff you already defined is not cleared and you add to the end of it,
or press RETURN, and next time you go in the sequencer is cleared.
Use the SPACE option to change pattern in mid-sequence, for
example, or to ‘see how it looks so far’.


#### STORING ONTO TAPE
You can SAVE your favorite presets,
sequencer runs, bursts etc or stored joystick moves onto tape for
later re-loading and use. To start the SAVE: press shift-S. You get
the option if saving Parameters or Motion. Selecting
PARAMETERS saves all presets, burst gens and sequencer, plus
all user-defined shapes. Selecting MOTION saves the stored
sequence of joystick moves used in the Record option. (Long
performances take a little while!). The parameters are saved as
GOATS and the motion as SHEEP (| suggest you use opposite sides
of a short cassette to store these on). To LOAD in data you saved
already: press shift-L. Prepare the tape and tell the program when
you're ready to LOAD. The loader automatically sorts out the
SHEEP from the GOATS.

After either of these options terminates you return to what you
were doing before.

### EDITING THE PATTERN ELEMENTS
There are eight elements you can define for yourself. To get into pattern edit mode press
CTRL and any of the first 8 preset keys. The screen clears and the
cursor centres. Each pattern is composed of seven levels. Level
One is preset, always just a single white dot. You can determine
the positions of the pixels in Levels 2-7. Move the Joystick to get
the cursor where you want a pixel, then press LEFT-ARROW to
enter it (like in Sequencer and Burst). You can define up to seven
pixels per level. Press RETURN when you ve done enough pixels on
a particular level and the option proceeds to the next level, until
level 7 is completed. Remember, the more pixels you have the
slower the finished pattern will run. You can place pixels
anywhere on the screen, they don’t have to be around the centre
Level One pixel at all. Don’t worry if this sounds complex, just get in
there and have a bash, you can’t do any damage! To select your
pattern once you've defined it, press SPACE until it comes up on
one of the eight User Patterns corresponding to the first eight
Preset keys.
Whew! Quite a lot to digest - but the best way is to just learn by
experimentation. Play with the values and see what happens - just
like you'd tinker with a synthesiser. Above all, use it as it was
intended - along with your favourite music. (At last I've discovered
a cure for air-guitarring!). Freak out with it. Have fun. Take it to
parties and have LOTS of fun. Come along to the next computer
show and give a public performance! Blow minds with it, freak out
your granny. Be creative with it. Let me know if you like it! Keep it
next to your hi-fi!

PSYCHEDELIA. I hope you enjoy playing with it as much as I do

The following all in some way inspired this creation: Roger Waters, Dave Gilmour, Nick
Mason et al., our Phil with the bald patch, KMEL 106FM, Ronnie James Dio, the Purple,
Isso Tomits, Rush, Steve Hillage, Yes, Led Zep, and many more... The Hairy One is pleased
with himself this time... perhaps because The Hairy One has played with nothing else on
his 64 for 3 weeks... If this blows your mind then you're on the same brainiength as me.
See you out by Alpha Centauri.....

ORIGINAL SOFTWARE DESIGN

LLAMASOFT SOFTWARE, 49 MOUNT PLEASANT, TADLEY, HANTS.



