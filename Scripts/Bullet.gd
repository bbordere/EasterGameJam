extends Node3D

const SPEED = 90;

var vfxScene = preload("res://Scenes/ExplosionParticles.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += transform.basis * Vector3(0, 0, -SPEED) * delta;
	if $RayCast3D.is_colliding():
		var collider = $RayCast3D.get_collider();
		if collider and collider.is_in_group("ennemies"):
			collider.takeDamage(2 * Globals.dmgMultiplier);
		else:
			var instance = vfxScene.instantiate();
			instance.position = position;
			instance.emitting();
			get_tree().root.add_child(instance);
		queue_free()


func _on_timer_timeout():
	queue_free()


func _on_area_3d_body_entered(body):
	print("BODY", body);
