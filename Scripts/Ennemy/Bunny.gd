extends Dummy

class_name Bunny

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var collider = null;

func init():
	scorePoints = 500;
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

func disable():
	velocity = Vector3.ZERO;
	$CollisionShape3D.set_deferred("disabled", true);
	$Area3D.set_deferred("monitoring", false);
	$RayCast3D.set_deferred("enabled", false);
	$AnimationPlayer.stop();

func enable():
	$CollisionShape3D.set_deferred("disabled", false);
	$Area3D.set_deferred("monitoring", true);
	$RayCast3D.set_deferred("enabled", true);
	$AnimationPlayer.play("walk");

func _physics_process(delta):
	if outOfRange:
		return;
	if playerDetected and $RayCast3D.is_colliding():
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
	if !isDisabled:
		move_and_slide()
		
func reset():
	$AnimationPlayer.play("RESET");
	$AnimationPlayer.play("walk");

