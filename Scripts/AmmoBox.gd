extends CharacterBody3D

class_name AmmoBox

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= 0.1;
	move_and_slide();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _on_area_3d_body_entered(body):
	if !(body is Player):
		return
	Globals.giveAmmo.emit(10);
	queue_free();
