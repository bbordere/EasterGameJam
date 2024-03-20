extends Dummy

class_name Bell

var canShoot = true;

func init():
	scorePoints = 750;
	$NavigationAgent3D.path_height_offset = randf_range(-2.3, -1.8);

func _physics_process(delta):
	if !isDisabled:
		move_and_slide()

func disable():
	velocity = Vector3.ZERO;
	$CollisionShape3D.set_deferred("disabled", true);
	$ShootingRange.set_deferred("monitoring", false);
	$Area3D.set_deferred("monitoring", false);
	$FireBallShooter.set_deferred("enabled", false);
	$AnimationPlayer.stop();

func enable():
	$CollisionShape3D.set_deferred("disabled", false);
	$ShootingRange.set_deferred("monitoring", true);
	$Area3D.set_deferred("monitoring", true);
	$FireBallShooter.set_deferred("enabled", true);
	$AnimationPlayer.play("fly");

func reset():
	self.scale = Vector3(1, 1, 1);
	$AnimationPlayer.play("fly");


func _on_shooting_range_body_entered(body):
	if body is Player:
		canAttack = true;


func _on_shooting_range_body_exited(body):
	if body is Player:
		canAttack = false;


func _on_fire_cooldown_timeout():
	canShoot = true;
