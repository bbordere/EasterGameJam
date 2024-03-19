extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	if Input.is_key_pressed(KEY_F1):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	if Input.is_key_pressed(KEY_F2):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
