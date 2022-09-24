# Ghost Drawing app

Anything which you are drawing should appear on screen after certain seconds. For the case of:

• Red 1 second.

• Blue 3 seconds.

• Green 5 seconds.

Eraser works on with the 2 seconds delay too.
The delay applies to anytime whenever you are done drawing with any of the color. For
example If you picked red and started drawing, there wouldn’t be any drawing on the screen
unless you would end sliding on the screen and lift the finger. After 1 second, it will start
drawing on the screen at same exact pattern as you slide your finger.

# Assumption5


### Brush Size

There were no mentions of what size of the brush for each color should be, so I hardcoded them all to different sizes, just to make sure they visually distinct.

### Single Taps
As of now, if user just taps on the screen once app will draw a dot in that place. This is similar with other drawing apps behavor.

### Eraser
Eraser currently is erasing only drawing that are either already on visually visible on the screen.
Currently user can schedule multiple erase operations at once, they will be executed after configurable delay which is implemented via `DispatchQueue.main.asyncAfter` not `BlockOperation`.
Undo operation is instant, as undo last was not in requirement, but it allows for some fast erasing and testing.

### UI artifact when drawing multiple lines
When user is drawing really fast, by randomly swiping across the screen, then some lines may start drawing before the previous one is finished. **THIS IS NOT A BUG, IT'S A FEATURE**!! It is appearing because of delay of drawing and the drawing time itself.

### Device Orientations
Currently only portait device orientation is supported. The reason for this is the delayed drawing, for it to work corrently we need to make sure that when delayed drawing happens the canvas is the same size as it was when user was actually drawing.
For the same reason on iPad I made sure that user cannot even use app in split-screen.
