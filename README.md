
# Godot 3D Target Tracker and Direction Indicator
3D Target Tracker and Direction Indicator for Godot 3.2

![off_screen_indi](https://user-images.githubusercontent.com/52464204/73356491-c70aec00-429a-11ea-97cd-5ab27ac89fdd.gif)

## Features | Examples:
- Transfers parent 3d position to 2d screenspace and displays icon with direction arrow
- Useful for indicating the position of all kind of 3d game objects on the players screen
- Different modes to change behaviour and show target while onscreen, offscreen or always
- Offscreen mode for e.g. enemies behind the player, grenades that are thrown close under the feet
- Onscreen mode for e.g. to show worldmap locations and quest givers in front of the player
- Always mode for e.g. to track party members position or indicate important 3d audio effects for deaf players
- Ruby colors!

## Setup | Usage
The example project comes with a minimalistic `Demo_Scene` that shows the intended Node setup
In the folder directory `src/3d_helpers` you find a `3d_Target_Tracker.tscn` scene file.
Add this `3d_Target_Tracker` scene as a Child to any 3d `Node` you want to track ( must have a 3d transform / inherit from `Spatial` )

For the direction arrow to work correctly move the `3d_Target_Tracker` node to a position heighter than the target node e.g. so the arrow can point to the head instead on the toe at the ground on a large monster close to the screen border. When target is on screen the direction arrow will automatically switch to aim down at the targets ground position to avoid pointing in the wrong direction when the 2d positions overlap.

Use the nodes export variables in the inspector to adjust settings like used display mode and image for this target
Use the bool `is_tracked` variable to toggle the display on and off from code
e.g. start the tracking only when an enemy gets aggressive towards the player

## License
MIT
## Known Issues
Script works without setting a bounding box for the parent model by using the center origin ( 0, 0 ) to decide if it is considered on screen or not which works fine for most 3d models.

If that doesn't work for your large scale model you might want to modify the script and work with a `VisibilityNotifer` and bounding box to solve this issue for your model. This solution is not provided with this examples.