extends CharacterBody3D

class_name Hen

var target = Vector3.ZERO;
var hp = 30;
var isDead = false;

const SPEED = 10;
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("ennemies");
	chooseRandomDir();
	
func takeDamage(num):
	hp -= num;
	hp = max(hp, 0);

func chooseRandomDir():
	target.x = randi_range(-20, 20);
	target.y = 0;
	target.z = randi_range(-20, 20);
	target += owner.global_position;
	$NavigationAgent3D.set_target_position(target);

	
func _process(delta):
	$Label3D.text = str(hp);
	isDead = hp == 0;
	if $NavigationAgent3D.is_navigation_finished() and !isDead:
		chooseRandomDir();
		return;
	if isDead:
		$AnimationPlayer.stop();
		$Area3D.monitoring = true;
		rotation.z = lerp_angle(rotation.z, deg_to_rad(90), 5 * delta)
		velocity.x = 0
		velocity.z = 0
	else:
		var next = $NavigationAgent3D.get_next_path_position();
		SafeLookAt.safe_look_at($FaceDirection, next);
		rotation.y = lerp_angle(rotation.y, $FaceDirection.global_rotation.y, 5 * delta)
		var vel = (next - global_transform.origin).normalized() * SPEED;
		velocity = vel;
	if not is_on_floor():
		velocity.y = -gravity;
	move_and_slide();

func _on_area_3d_body_entered(body):
	if body is Player:
		Globals.addScore.emit(2000);
		queue_free();
