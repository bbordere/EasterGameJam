extends Dummy

class_name Bell

var canShoot = true;

func init():
	scorePoints = 750;
	$NavigationAgent3D.path_height_offset = randf_range(-2.3, -1.8);

func _physics_process(delta):
	move_and_slide()


func _on_shooting_range_body_entered(body):
	if body is Player:
		canAttack = true;


func _on_shooting_range_body_exited(body):
	if body is Player:
		canAttack = false;


func _on_fire_cooldown_timeout():
	canShoot = true;
