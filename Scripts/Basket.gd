extends Node3D

const SPEED = 25



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += transform.basis * Vector3(0, 0, -SPEED) * delta;


func _on_area_3d_body_entered(body):
	if body is Egg:
		body.stun();
	if !(body is Player):
		queue_free();


func _on_timer_timeout():
	queue_free()
