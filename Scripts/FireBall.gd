extends Node3D

const SPEED = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += transform.basis * Vector3(0, 0, -SPEED) * delta;


func _on_area_3d_body_entered(body):
	if body is Bell:
		return;
	if body and body.is_in_group("ennemies"):
		body.takeDamage(10);
	elif body and body is Player:
		body.takeDmg(10);
	queue_free();


func _on_timer_timeout():
	queue_free();
