extends Node3D

const SPEED = 60;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0, 0, -SPEED) * delta;
	if $RayCast3D.is_colliding():
		var collider = $RayCast3D.get_collider();
		if collider.is_in_group("ennemies"):
			collider.takeDamage(2 * Globals.dmgMultiplier);
		queue_free()


func _on_timer_timeout():
	queue_free()


func _on_area_3d_body_entered(body):
	print("BODY", body);
