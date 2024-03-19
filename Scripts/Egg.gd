extends CharacterBody3D

class_name Egg

enum NamedEnum {Dash, DoubleJump, SuperDmg};
var skills = ["dash", "double_jump", "super_dmg"];
var target = Vector3.ZERO;
var isStunned = false;

@export var type: NamedEnum


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.stop()
	await get_tree().create_timer(randf_range(0.2, 0.4)).timeout
	$AnimationPlayer.play("default");
	chooseRandomDir();
	pass

func chooseRandomDir():
	target.x = randi_range(-10, 10);
	target.y = 0;
	target.z = randi_range(-10, 10);
	target += owner.global_position;
	$NavigationAgent3D.set_target_position(target);

func stun():
	$"Sphère/Torus".visible = true;
	isStunned = true;
	$AnimationPlayer.stop();
	$AnimationPlayer.play("stunned");
	await get_tree().create_timer(5).timeout
	$"Sphère/Torus".visible = false;
	$AnimationPlayer.play("default");
	isStunned = false;
	
func _process(delta):
	if isStunned:
		return;
	if $NavigationAgent3D.is_navigation_finished():
		chooseRandomDir();
		return;
	var next = $NavigationAgent3D.get_next_path_position();
	SafeLookAt.safe_look_at($FaceDirection, next);
	rotation.y = lerp_angle(rotation.y, $FaceDirection.global_rotation.y, 5 * delta)
	var vel = (next - global_transform.origin).normalized() * 6;
	velocity = vel;
	move_and_slide();

func _on_area_3d_body_entered(body):
	if body is Player:
		Globals.catchEgg.emit(isStunned);
		Globals.skills[skills[type]] = true;
		Globals.giveEgg.emit(1);
		queue_free();
