# GhostDrawingBoard


# Assumptions

### Brush Size
THere were no mentions of what size of the bruhs for each color should be, so I hardcoded them all differnt sizes, just to make sure they visually distinct.

### Device Orientations
Currently only portait device orientation is supported. The reason for this is the delayed drawing, for it to work corrently we need to make sure that when delayed drawing happens the canvas is the same size as it was when user was actually drawing.
For the same reason I checked requires full screen for iPad, to make sure that user cannot even use app in split-screen.


