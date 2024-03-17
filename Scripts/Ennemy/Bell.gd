extends Dummy

class_name Bell

func init():
	$NavigationAgent3D.path_height_offset = randf_range(-2.3, -1.8);

func _physics_process(delta):
	move_and_slide()
