# Colourspace by Jeff Minter from Llamasoft

<!-- vim-markdown-toc GFM -->

* [COLOURSPACE a light synthesizer for Atari computers](#colourspace-a-light-synthesizer-for-atari-computers)
  * [What is Colourspace?](#what-is-colourspace)
  * [Loading COLOURSPACE](#loading-colourspace)
  * [Auto Demo Mode](#auto-demo-mode)
  * [Taking Control](#taking-control)
  * [First Encounter](#first-encounter)
  * [Keyboard Controls](#keyboard-controls)
  * [The Colour Control Bank](#the-colour-control-bank)
  * [Altering All Colours Simultaneously](#altering-all-colours-simultaneously)
  * [Adjusting a Variable](#adjusting-a-variable)
  * [Dynamic Colourflows - an Intro](#dynamic-colourflows---an-intro)
  * [Individual Settings for Individual Colourflow Segments](#individual-settings-for-individual-colourflow-segments)
  * [Other commands affecting the display](#other-commands-affecting-the-display)
  * [Record Mode](#record-mode)
  * [Dual Modes](#dual-modes)
  * [Pattern Definition](#pattern-definition)
  * [Foreground Painting](#foreground-painting)
  * [Saving your Atari Colourspace creations](#saving-your-atari-colourspace-creations)
  * [Other Controls](#other-controls)
  * [Using COLOURSPACE](#using-colourspace)
  * [Summary of Commands](#summary-of-commands)

<!-- vim-markdown-toc -->

**IMPORTANT NOTICE**

Some monitors and televisions may produce a scrambled picture during the
STROBOSCOPIC effects (such as Preset 5).  This resembles a television which
needs it's vertical or horizontal hold adjusted.  This will not harm your set.
The STROBE effect sends an unusual (but not harmful) signal to your television
or monitor.  A few sets cannot decode this signal and the picture gets
scrambled.  The problem is caused by your set and it is not a bug in the
program.  THE SOLUTION:  Use a different television or monitor. If this not
possible, experiment with different STROBE rates.  It is likely your set will
be able to handle the STROBE at a different speed.  If the problem persists, do
not use the STROBE effect with that monitor or television.  Or else look upon
the scrambled picture as yet another special effect.

This documentation may not be copied, photocopied, reproduced, translated, or
telecommunicated in any form, in whole or in part, without the prior written
consent of Antic Publishing, Inc.

The accompanying program material may not be duplicated, in whole or in part,
for any purpose.  No copies of the floppy disk(s) may be sold or given to any
  person or other entity.

Notwithstanding the above, the documentation and accompanying disk(s) may be
duplicated for the sole use of the original purchaser.

Antic is a trademark of Antic Publishing, Inc.

# COLOURSPACE a light synthesizer for Atari computers

## What is Colourspace?

Colourspace is the second stage development of an idea which grew out of an
appreciation of good rock music, and an interest in the way in which music and
light go together.  Most people who attend rock concerts enjoy lighting effects
during the performance, often involving lasers and projections onto large
screens behind the group.  Such effects usually enhance the enjoyment of the
music for those watching.

What I wanted to do was make the lightshow playable in much the same way as a
musician plays his instrument.  An operator interpreting the music visually in
realtime could seriously blow the minds of people watching as well as having a
really good time himself.

The original idea was for a device to be played on stage and controlling large
lighting rigs and lasers, and obviously I had neither the cash or expertise to
build such a device, so it remained as only an idea until I decided to
experiment with using a computer to generate the effects on a TV screen, for
use in the home.

The resultant program, PSYCHEDELIA, is now available for many popular micros,
and has freaked quite a few people out.  Using keyboard and joystick, operators
can produce lightshows to accompany their favourite music.  The displays have
been described as being like "interactive fireworks".  Whilst satisfying on
their own, the displays are best to the accompanyment of loud music, which acts
like a catalyst and vastly increases the enjoyment of playing.  The system is
set up like a synthesizer, with user-controllable variables defining the modes
of pattern-generation.  Users "perform" using the joystick and can store away
effects for later recall by a single keypress.

This program, COLOURSPACE, is based upon the same basic idea.  By using the
unique Atari screen hardware and colour pallette, the effect of the program is
much improved.  The difference between Psychedelia and Colourspace is as
pronounced as the difference between a Mini and a Ferrari.  Using the Atari you
can get curved screens, hardware reflections, interlace effects, stroboscopics,
dynamic colourflows, and variable resolution screens.  There are 80 presets
available for programming, 16 user-definable lightforms, and a foreground
drawing mode.  There is even a mode which allows you to perform simultaneously
with another player or with the computer.

## Loading COLOURSPACE

COLOURSPACE is a machine-language program which does not require the presence
of the BASIC language to function; in fact it will not work correctly if BASIC
is present, following load procedure should be followed.

Atari 400/800:  Remove any cartridges from the system.  Turn on the disk drive,
then put the disk in.  Turn on the computer.  The program will load and run
automatically.

Atari XL/XE models:  Remove any cartridges from the system.  Turn on the disk
drive, then put the disk in.  Turn on the computer while holding down the
OPTION key.  The program will load and run automatically.

Once loaded the program will immediately begin the Auto Demo.

## Auto Demo Mode

When first booted the program will be running in this mode.  It is probably a
good idea to watch the Auto Demo for a bit if you have never seen Colourspace
before.  The demo runs through all of the 80 demonstration presets and gives
some idea of the effects you can achieve using Colourspace.

## Taking Control

To terminate auto demo, just press the "A" key.  The message "TERMINATED" will
appear at the top of the screen and pattern flow will stop, leaving a glowing
pixel - the cursor - on the screen.  (There may be some foreground graphics
there, too - if there are you can wipe them off by pressing "W").  If you
haven't done so already, plug a Joystick controller into Joystick Port 1.

## First Encounter

It's a good idea to put on some decent music at this stage, to help you get in
the swing of things.  Use the Joystick to move the cursor.  Moving the stick
and pressing the FIRE button will cause pattern generation.  Try holding down
FIRE and doing lines, curves and swirls.  Pulse the FIRE button, waggle the
stick, just get the feel of the system and see what it does.  Press any of the
keys marked ESC, 1, 2...DELETE to change the effect.  When you have had enough,
read on to find how some of the simpler keyboard commands work.

## Keyboard Controls

There are many keyboard controls affecting the performance of the light
synthesizer.  The controls fall naturally into various groupings, each
controlling different functions and having different effects.  The simplest
keys are also those which have the most obvious effect on the display, so we'll
look at those first.


The "S" key changes the symmetry of patterns being produced.  There are five
basic settings:  y-axis reflection, x= axis reflection, x/y reflection, quad
symmetry and no symmetry at all.  Some of the screen modes will affect the way
the symmetries are displayed, since some modes incorporate their own hardware
reflection modes.

The "M" key changes the type of screen upon which you draw.  The basic screen
types are as follows:

Variable Resolution - you can change the size of the pixels by pressing "Z" (to
increase) or shift-z (to decrease).

Hardware Reflect - a high-resolution mode in the top half of the screen is
reflected by hardware in the lower half of the screen.

Curved Colourspace 1 - by varying the y-resolution of the screen from top to
bottom, the effect of projection onto a quarter-cylinder is created.

Curved Colourspace 2 - as above, but projected onto a half-cylinder.  Curve +
hard reflect - half-cylinder projection with hardware reflect halfway down the
cylinder.

Curve/reflect 2 - two half-cylinders, each with hardware reflect as above.

Zarjaz interlace mode - a hi-res screen is interlaced with its own hardware
reflection to give an interesting "shaded" effect.

The space bar changes the current lightform-primitive (the shape which you move
to generate the patterns).  There are eight pre-defined ones, and 16 more which
can be edited by the user.  The space bar steps sequentially through all the
available options.

The "E" key toggles between "explosion" and "normal" drawing mode.

In "explosion" mode the cursor leaves a trail of "explosions" rather than the
usual image of the lightform-primitive.  This mode is usually most effective if
you are using a pulsed stream (see PULSE RATE later).

## The Colour Control Bank

This is one of the most complex areas to be covered.  The exceptional colour
capabilities of the Atari can be exploited to the full, and static or dynamic
colourflows produced.  Experiment a lot with this mode because its potentials
are pretty impressive.


Before you start experimenting, follow these instructions which should leave
you in a mode where your alterations are easily visible:

1)  Press the key CAPS (the caps lock key) repeatedly until the message "PRESET
BANK #000" appears at the top of the screen.

2)  Press the number key "3".  Try the patterns - you should be on a graduated
red colourflow.  If you're not, repeat the procedure until you are.  3)  Once
you are in that mode, proceed.  If you get into trouble during any of the
examples, pressing "3" will restore you to that original red colourflow.

## Altering All Colours Simultaneously

This is useful if you have a colourflow in, for example, shades of blue, and
you wish to change to greens or reds.  It is possible to change each colour in
the flow individually (as detailed later), but when each colour has only to be
transposed by an equal amount, it is simpler to change all the colours
simultaneously.

In order to understand how best to use the colour controls, you need to know
how the colours are numbered.  There are sixteen basic hues, and sixteen
intensity levels within each hue.  For example, colour 0 is black and colour 15
is white.  The numbers in between represent the intermediate shades of grey
between black and white.  It's easier to think in terms of music:  steps of 16
are like octaves in music.  If you add 16 to a particular colour, you get the
next colour up in the same intensity.  The colours themselves are laid out in
more or less rainbow order.

To alter all the colours at once, you use a variable known as the Simultaneous
Adder.  Initially, this is set to 16, but you can adjust it to whatever you
like (see Adjusting a Variable, below).  Try adjusting the colourflow by
performing the following actions:

Press * until the top of the screen displays "CKEYS=COLOURS".  This tells the
system that you will be operating on the colour values.  Then press the "H" key
(Perform Simultaneous Add).  The message "COLOURFLOW RESYNCED" will appear, and
if you make some patterns you will see that the colours have changed slightly.
  The more you press "H" the more the colourflow is transposed.

## Adjusting a Variable

So far you've been adding 16 to the colourflow, resulting in a transposition of
hue but remaining at the same intensity.  Now try changing the value of the
Simultaneous Adder to something less than 16 and see what happens when you
perform the add.  In adjusting this variable you use the CTRL and SHIFT keys,
along with the variable's own key, as follows:

To increase the variable:  hold down CONTROL, and then hold down the variable
key (in this case J, the simultaneous adder control key).  The variable's name
and current value (constantly increasing) will appear at the top of the screen.
Release both keys when the value reaches the required amount.  To decrease the
variable:  hold down SHIFT and the variable key, The variable's name and
(decreasing) value appears on the screen.  Release both keys when the value is
right.

When adjusting a variable, holding down the variable's key results in
continuous adjustment of the variable.  You can adjust the value more slowly by
using single discrete presses of the variable key.

Using the method given above, adjust the simultaneous adder to a value of 1.
Press H to see the effect.  As you press H the intensities of the various
levels of the colourflow are altered.  If you pressed H 16 times you would step
through one entire colour "octave".  Experiment with the control to see what
happens.  Check the results by playing around with the patterns.

## Dynamic Colourflows - an Intro

On the Atari program COLOURSPACE it is possible to make use of a new type of
effect not available on the Commodore PSYCHEDELIA.  Dynamic colourflows mean
that it is possible to create patterns where not only does the pattern move
through colourspace, but also the colours themselves pulse in a preset rhythm.

To get an idea of this effect, try the following example:  Press the number key
"3" to restore the graduated red colourflow.  Set the Simultaneous Adder
variable to 1.  Press the * key until the top of the screen displays
"CKEYS=OOZE RATES".  Then press "H" to perform the simultaneous add, and play
with the pattern to ascertain the result.

The metallic "gleaming" effect is caused by the various colours in the flow
oscillating smoothly through one entire colour "octave".  Because each level of
the flow is slightly displaced in colour value from the others, the oscillation
causes a "ripple" to run up and down the pattern.

Press "H" again and the ripple will slow down.  The "ooze rate" which you are
adjusting controls the rate at which oscillation occurs.  1 is fastest, larger
values introduce a longer delay, and 0 stops oscillation.  (Here we will
introduce the second function of the "H" key:  that of zeroing the colour bank
parameters.  By pressing shift-H you can set all values in the colour control
section selected by pressing * (e.g. ooze rates, ooze cycles or ooze steps) to
zero.  Useful for turning off a dynamic colourflow quickly.  Beware using this
function on the "colours" bank directly, though - it will set all your colours
to black!).

Parameters defining the Ooze

The "ooze" is the term I use for the rhythmic cycles of pulsation used for
dynamic colourflows.  Set up the simple dynamic flow example used just now, and
prepare to experiment...

Press the * key to select Ooze Steps.  Set the Simultaneous Adder variable to
1, and the press "H" a few times.  The effect you see is due to the pulsation
taking place in steps of greater than 1.  You can see the pulse steps for any
value from 1 to 255 (effectively, -1).  It is interesting to set the ooze step
to 16, because then the colours oscillate through the hues without varying in
intensity.  Setting the ooze step to zero effectively stops oscillation by
adding zero to the colour flow which has no effect.

Press "3" to regain the red colourflow.  Introduce a simple oscillation as
before by setting the ooze rates to 1.  Set the Simul Adder to 16, and press *
until "CKEYS=OOZE CYCLES" is selected.  Press "H" 3 or 4 times.  What you see
when you run the pattern is that the rate of colourflow remains unchanged, but
the flow takes place over a wider range.  The OOZE CYCLE parameter specifies
how many additions take place before the oscillation turns around.  Short
cycles oscillate very quickly; longer ones take more time and step through a
larger range.  (Zero gives, paradoxically, the largest range:  the system
treats zero as meaning 256).  Examples of oscillation ranges under different
settings.  The base colour is assumed to be black.

(Ooze Step=1 Ooze Cycle=16 [default settings]) 0       15

_ _ _ _ _ (Step=2 Cycle=16) 0                              30

_  _  _ (Step=16 Cycle=6) 0                        80

## Individual Settings for Individual Colourflow Segments

So far we have used the Simultaneous Adder to perform ooze operations on all
colours within the flow simultaneously.  However, each colour within the flow
may possess its own individual settings for ooze rate, step and cycle, as well
as for colour.  This is achieved by assigning each colour its own variable key
and then adjusting the value with the CTRL and SHIFT keys, just as you did for
the Simul Add variable.

The variable keys for the colours are the keys X...[.Use * to select which
colour function you wish to adjust (colour, ooze rate, ooze cycle or step) and
then adjust the value in the usual manner.  (When adjusting an ooze parameter
associated with an already-oscillating colourflow, you should perform a resync
(shift-asterisk) when you have finished, or else the flow wll be "out of step".
Always resync after individual colour operations).

The background colour can be set and made to oscillate just like the
colourflows.  Its variable key is the inverse-character key on the keyboard
(the 2-coloured box on XL/XE s, the Atari logo key on old 400/800s).

Quite amazing effects can be worked out by using dynamic colourflows.  The
ability to give each stage of the flow its own oscillation parameters gives the
system a large potential for some really zarjaz effects.  Experiment with the
system and see what comes out...

Before leaving the subject of colour we'd better deal with the subject of
stroboscopics.  These high-intensity flashing effects can be very effective in
dark rooms...

Strobo is turned on and off by pressing the "?" key.  The flash rate is
adjusted by single presses on the ] key.  The setting is displayed as STROBO
ZAP RATE at the top of the screen.  The fastest is 1, the slowest is 7.  We
find rates of about 3 or 4 to be very effective.  For maximum effect use a
bright screen as background.  Ooze does not take place during stroboscopics.

WARNING:  Stroboscopic effects are very intense, especially in situations where
there is no other light.  Some people may be upset by stroboscopics of
particular frequencies.  Care should be taken in the use of strobo FX to ensure
that they don't freak anyone out in a negative manner.

## Other commands affecting the display

After having introduced the simple display-modifying parameters early on
(Symmetry, Shape etc) we can now go into more depth.


I'll run through each control in turn:

E=Explosion mode.  When enabled, the cursor draws not with the usual lightform,
but with a small "explosion" of 8 pixels.  This is most effective with a bit of
Pulse on, but it can look good with no Pulse and a slow Cursor Speed.  The key
toggles between normal and explosion mode.

T=Tracking on/off.  Tracking, when enabled, means that when the buffer is full
the program actively looks for the next best place in the buffer, resulting in
a more consistent - but fragmented - colourflow when the buffer fills.  If
disabled, the program waits for the buffer to empty completely before adding
new data, so you get a characteristic "pulse" at Buffer Full time.  (Don't
worry if this seems heavy.  Just play around with the control and see.).

P=Pulse Speed.  Normally when you hold down the FIRE button you get a
continuous stream of pattern.  By adjusting this variable, you can introduce a
"pulsed stream" effect.  Adjust the variable by using CTRL and SHIFT along with
this key in the usual manner.

O=Pulse Width.  When you have set up a pulse stream using P, you can further
alter the stream by using this variable to set the WIDTH of the pulses.  Adjust
using CTRL, SHIFT and this key.

D=Smoothing Delay.  During pattern plotting, large patterns take longer to plot
than small patterns.  At high speeds this can result in a certain "lumpiness"
of the colourflow.  Introducing a larger Smoothing Delay evens out the
irregularities in such cases.  This variable is also used a lot for special
effects:  a slow cursor speed and a large SD can give some zarjaz slow motion
effects.  Experiment with both high and low values (range is 0-255) to see what
happens.  Adjust as usual via CTRL and SHIFT.

B=Buffer Length.  Used to alter the length of the plot buffer (the amount of
pattern points the system can cope with at any one time).  Usually set to 64
but other lengths are used for various types of special FX.  Adjusting the
variable is achieved by single or repeated presses of the B key.

V=Vector Mode on/off.  A drawback of using 8-way joysticks as control inputs to
Colourspace is that all traces are at 90 or 45 degree angles.  Selecting Vector
Mode introduces a new method of control using the stick.  If you imagine that
the cursor is a Telepathic MetaGoat, then pushing the stick forward makes the
goat go faster forwards; pulling back makes it slow down; and pushing it left
or right makes it turn to the left or right.  Using this method you can get 32
different trace angles instead of only 8.

C=Cursor Speed.  You usually draw at the rate of 50 pixel/sec motion.  By
adjusting this variable you can slow this rate down.  Also used in conjunction
with Speed Boost for special FX.  This variable is adjusted by single or
repeated presses of the C key. 

X=Speed Boost.  Forces the cursor to go faster than the standard interrupt rate
of 50 pixels/sec.  Useful for really fast tracks, often best with a bit of
pulse too.  Low Cursor Speeds with high Speed Boost values can give some well
strange effects.  Adjust with single or repeated presses of the X key.

Q=Sloth Mode on/off.  The mode breaks up diagonal traces into a lot of
horizontal and vertical components.  The resulting trace has a "stepped" effect
which can look really zarjaz on some patterns.

All these controls have been briefly looked at here.  The best way to find out
what they do is to get a light form you know well (like that red Preset 3 of
bank 0 that we used as an example earlier) and modify it using these
parameters, separately or in combination.  You'll soon get the hang of things.

The Preset Banks

Once you've set up a good colourflow, it's convenient to be able to stash it
away for later recall by a single key press.  There are 80 presets available
for you to store parameters on.

The presets are arranged as five banks of sixteen presets each.  To read data
out of a particular preset, you use the "CAPS" key to switch between preset
banks, then press the preset key of your choice.  All of the top row of keys
are preset keys, plus two of the cursor keys on the second row down.

The presets come already assigned with 80 examples, but you can overwrite these
with your own data.  To assign your own data to a preset, select bank as
previously described, then type SHIFT together with the preset key you've
chosen.  The message STASHING PRESET#nn will appear.  Your data is now assigned
to that key.  Recording, Dual Modes, Pattern Definition, Foreground Painting


## Record Mode

The system can remember your joystick motions and keyboard presses for later
playback.  To make a recording, follow this procedure:

1)  Select the preset you want to start with; 2)  Press SHIFT-R to begin
recording; 3)  Use joystick and keys at will (system can record about a quarter
hour of play); 4)  Terminate RECORD mode by pressing R (system drops out
automatically if it runs out of memory).

To play back a recording, press just R on its own.  The system recalls the last
preset you'd selected before you started recording, then plays back what you
did.  When it reaches the end of the recording, it repeats itself.  Playback
can be stopped at any time by pressing R.

## Dual Modes

It is good fun to get two people together to give a dual Colourspace demo.  If
a second joystick is plugged in then dual-operator play can take place.

Press J to select between NORMAL and DUAL mode.  In DUAL mode, each player has
a cursor which runs at HALF the speed of the equivalent NORMAL mode cursor.

The second player's lightform can be selected by pressing the semicolon ";"
key.  All the other controls apply to both users' colourflows.

You can also play dual with the computer, by first using RECORD mode to record
some motion, Then press CTRL-R to begin Mixed Mode playback.  The computer
plays back your recording (without keypresses) at half-speed with Cursor 2, and
you control Cursor 1 simultaneously with the joystick.  Press CTRL-R or J to
terminate the mixed mode.

## Pattern Definition

There are 16 lightforms which the user can modify at will.  Select the
lightform you want to change by pressing SPACE until it appears.  Kill any
Speed Boost, then press U to enter define mode.  A message will appear telling
you which level you're on and how many points are free.

Lightforms are made up of seven "stages".  Stage one is the central point which
is plotted at the cursor.  Stages 2 to 7 can have their points anywhere.

You are shown the Stage One point at the centre of the screen.  Use the stick
and button to enter as many Stage 2 points as you require then press RETURN to
progress to Stage 3.  Repeat until you've done Stage 7, then press RETURN to
quit.  The lightform you just defined will now be active.

The more points there are in the total lightform, the slower it'll run when
finished.  The total number of points per lightform is limited, too.  For
really fast patterns use patterns with only one or two points per level.

## Foreground Painting

It is possible to draw on the "front" of the screen by using the Foreground
Paint Mode.  Select which symmetry you wish to draw in by using SHIFT-G, then
turn off any Speed Boost and press SHIFT-F to enter the Foreground Draw mode.

Once in this mode you can draw up to 1000 pixels' worth of design.  Press FIRE
to enter a point.  Press SPACE to change the plot colour - there are the usual
colours plus the background colour, and colour#8 which is the same colour as
the cursor.

Use DELETE to delete points sequentially starting with last point plotted, if
necessary.  Once you've drawn your design press RETURN to exit draw mode.  If
you then make patterns you'll see them pass UNDER the foreground drawing.

With a foreground design in memory, you can plot it in two different ways.  If
you press F, then the pattern will be drawn in exactly the same positon as when
you drew it.  If you press G, the pattern will be drawn with the first point
starting at the current cursor position.  You can draw the pattern anywhere on
the screen, as often as you like.

To clear off the screen, press W for Wipe Foreground Screen.  All plotting to
the foreground screen can be done under any of the five symmetry possibilities
- just press shift-G to change between them.  The possibilities presented by
the Define Pattern and Foreground Design modes are quite extensive.  Record
mode is good for when you want a more "human" demo than that provided by the
Auto-Demo mode, and the Dual mode is really good if you get two people in some
kind of empathic synchrony.


## Saving your Atari Colourspace creations

With the large amount of preset memory and user-definable shapes, it's useful
to be able to store your presets, patterns and foreground drawings for loading
later.  COLOURSPACE allows SAVEing to cassette tape only (not to disk).  There
are two types of COLOURSPACE file:  PARAMETER data (which includes all 80
preset settings, the 16 user-definable lightforms, and any foreground graphics
held in store), and DYNAMICS data (which comprises the stored keyboard and
joystick data created in the RECORD mode).


The CTRL key is used to activate all the tape I-O operations.  Ensure that The
COLOURSPACE Record mode is not active and that you're not in Draw or Define
modes.  To start a SAVE, press CTRL-Q (for Parameter Save) or CTRL-A (for
Dynamics Save).  You'll hear the double-beep signifying the start of a SAVE.
Insert a blank cassette and press the PLAY and RECORD buttons on the recorder,
then press RETURN.  To start a LOAD, press CTRL-W (for Parameters) or CTRL-S
(for Dynamics).  It is very important that you don't try and load a DYNAMICS
file in via a PARAMETERS load; the system would become a little miffed.  I'd
advise that you keep separate tapes for parameter and dynamics data, or that
you keep both files one after the other on a single tape with Parameters first,
Dynamics second, so you can do the two loads in the same order each time.  When
you hear the beep, press the play button on the recorder, then hit RETURN.

Tape I-O can be fairly weird at the best of times; if the system seems to be
freaking out you'll find that a swift jab of the System Reset button usually
sorts the matter out.  (You can't naff the system by doing this, don't worry).
Always use good tapes or you might find that sometimes you only get a partial
LOAD.

## Other Controls

There are one or two additional controls which ought to be detailed:

Y=Status Line Enable/Disable.  If you're giving a Colourspace demo and don't
want the status line to appear at the top of the screen, you press Y to disable
it.  Pressing Y once more will re-enable it.

Z=Variable Resolution control.  On the variable resolution screen, you use Z to
set up the resolution you require.  Z alone decreases the resolution (bigger
pixels), SHIFT-Z increases the resolution (smaller pixels).

## Using COLOURSPACE

Firstly gain a good knowledge of the variables and their effect on the
patterns.  You'll be more able to get the best out of the system if you know
exactly which controls do what.

If you're ever going to do a "live" demo, work out beforehand the presets
you're going to use and put them onto tape.  (About 16 presets per music track
is pretty usual).  You might find it useful to assign someone else as a preset
operator so you don't have to take your hands off the joystick.

Practice improvisation, too:  it's good training to see how well you can synch
in with a track you don't know.  Each preset setting has its own feel and
inertia.  A good operator acts as an interface, taking as input the "feel" of
the music, and expressing that "feel" in the form of visual output.


## Summary of Commands


A=Auto Demo on/off 
S=Symmetry change 
M=Screen Mode 
Z/SHIFT - Z=Vary Vertical Resolution
SPACE=Change Lightform Primitive 
E=Explosion mode on/off 
H=Perform Simultaneous Add 
SHIFT-J=Simultaneous Adder Variable Key 
*=Select colour controleffect 
SHIFT-*=Colourflow resync
Shift H=Zero selected colour parameter bank
]=Set strobo flash rate 
?=Turn stroboscopics on/off 
H,C,V,B,N,M,[=Individual colour Variable Keys 
(Inverse Text Key)=Base Colour variable key 
Q=Sloth Mode on/off 
T=Tracking on/off 
O=Pulse Width variable key 
P=Pulse Speed variable key
D=Smoothing Delay variable key 
X=Speed Boost adjust 
C=Cursor Speed adjust
V=Vector Mode on/off 
B=Buffer Length adjust 
ESC,1,2,3,4,5,6,7,8,9,0, , ,DEL,-=,are preset keys
CAPS=Preset Bank Select 
W=Wipe off foreground graphics 
SHIFT-R=Begin Record Mode 
R=Stop Record Mode/Begin Playback/Stop Playback
CTRL-R=Mixed Record/Live mode on/off 
U=Define User-Definable Lightform 
J=Dual Joystick mode off/on 
;=Select second user's lightform 
SHIFT-F=Begin drawing on foreground screen 
F=Draw foreground graphics in original place 
G=Draw foreground graphics at current cursor position 
SHIFT-G=Change symmetry of foreground graphics plot 
CTRL -Q=Start parameter save 
CTRL -W=Start parameter load 
CTRL -A=Start dynamics save 
CTRL -S=Start dynamics load 
Y=enable/disable status line

Don't worry about the large number of controls.  The best way to learn the
system is just to put on some good music and experiment.  It's just about
impossible to create something which looks actively bad, but the real skill
lies in getting decent sync between the music and the light display.  This
skill requires a good feel for music, a thorough knowledge of the lightsynth,
and lots of practice.

I hope you enjoy playing COLOURSPACE, 'cos we certainly do...
______________________________


COLOURSPACE was developed over a period of 1 month using an Atari 800XL running
MAC65 assembler and using a single 810 drive.  Special thanks to Floyd,
Genesis, Steve Hillage, R.J.Dio, some guy called Blackmore who plays guitar a
bit, and all the others who inspired the creation of COLOURSPACE...thanks to
Atari for tech help & for making such a zarjaz machine...Wait'll I get it
running on the 520ST...may all your colourflows be dynamic!!!

