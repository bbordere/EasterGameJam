extends Dummy

class_name Bunny

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var collider = null;

func init():
	SPEED = 3;
	randomize()
	await get_tree().create_timer(randf_range(0.2, 0.8)).timeout;
	$AnimationPlayer.play("walk");

func attack():
	if (!collider):
		return;
	await get_tree().create_timer(0.1).timeout;
	if (!collider):
		return;
	collider.takeDmg(4);
	collider.knock(global_position, 15);

func _physics_process(delta):
	if $RayCast3D.is_colliding():
		collider = $RayCast3D.get_collider();
		if (collider is Player):
			canAttack = true;
		else:
			canAttack = false;
	else:
		canAttack = false;
		collider = null;

	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()

