extends Spatial

##################################################
### Helper Node to track parent 3D Node on/offscreen
### Shows sprite image with directional arrow for the parents position that stays inside the screen border

export(String, "show_offscreen", "show_onscreen", "show_always") var mode = "show_offscreen"

export(Texture) var image setget _set_image

export(Vector2) var screen_border_offset = Vector2( 20.0, 20.0 )
### amount of forced spacing between portrait image position and screen border in pixels
### overwriten if set lower than the size of the used image

export(bool) var is_tracked = true setget _set_tracked
### toggle this variable external to active the display for the parent actor
### e.g. on enemies when they become aggressive towards the player
### e.g. on party members when they join the player party

var target_node: Spatial
### 3d node to track, _process() gets parent node automatically

var windowsize
onready var pointer = $Sprite/Pointer
onready var animate = $Sprite/AnimationPlayer
onready var sprite = $Sprite


func _ready():
		
	sprite.visible = false
	set_process(false)
	
	
	### artist bailout, if used image is larger than offset from the script use image size instead
	var rect = sprite.get_rect().size
	if screen_border_offset.x < rect.x:
		screen_border_offset.x = rect.x
	if screen_border_offset.y < rect.y:
		screen_border_offset.y = rect.y
		
	if is_tracked == true:
		set_process(true)
		

	
func _process(delta):
	
	if not target_node:
		target_node = get_parent()
		if not target_node:
			print("### error, can't find parent node for tracker")
			return
		
	var viewport_rect = sprite.get_viewport_rect()
	
	var current_camera: Camera = get_tree().get_root().get_camera()
	if not current_camera:
			print("### error, can't find current scene camera")
			return
			
	### project the targets 3d position to our 2d screen
	var target_2d_position: Vector2 = current_camera.unproject_position(get_global_transform().origin)

	
	### keep our indicatior within the screens at all time
	sprite.position.x = clamp(target_2d_position.x, screen_border_offset.x, viewport_rect.size.x - screen_border_offset.x)
	sprite.position.y = clamp(target_2d_position.y, screen_border_offset.y, viewport_rect.size.y - screen_border_offset.y)
	
	if viewport_rect.has_point(target_2d_position):
		target_2d_position = current_camera.unproject_position(target_node.get_global_transform().origin)

	### rotate our arrow image to the target direction over time
	pointer.look_at( target_2d_position )

	
	if mode == "show_always":
		if not sprite.visible and not animate.is_playing():
			animate.play("show")
		return
	
	elif mode == "show_offscreen":
		### check if target position is inside our viewport screen
		if viewport_rect.has_point(target_2d_position):
			if sprite.visible and not animate.is_playing():
				animate.play("hide")
		else:
			if not sprite.visible and not animate.is_playing():
				animate.play("show")
		return
		
	elif mode == "show_onscreen":
		### check if target position is inside our viewport screen
		if viewport_rect.has_point(target_2d_position):
			if not sprite.visible and not animate.is_playing():
				animate.play("show")
		else:
			if sprite.visible and not animate.is_playing():
				animate.play("hide")
		return
		
	else:
		print("error - set mode for target indicator unknown")
		return



func _set_tracked(tracked : bool):
	is_tracked = tracked
	if tracked == true:
		set_process(true)
	else:
		if visible:
			animate.play("hide")
			yield(animate, "animation_finished")
		set_process(false)


func _set_image( texture: Texture ):
	 $Sprite.texture = texture
