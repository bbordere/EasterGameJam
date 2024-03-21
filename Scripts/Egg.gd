@tool

extends CharacterBody3D

class_name Egg

enum NamedEnum {Dash, DoubleJump, SuperDmg};
var skills = ["dash", "double_jump", "super_dmg"];
var target = Vector3.ZERO;
var isStunned = false;
var isDisabled = false;
var cachePos = Vector3.ZERO;
var startingPos = Vector3.ZERO;

@export var type: NamedEnum

@export var material: Material;

# Called when the node enters the scene tree for the first time.
func _ready():
	startingPos = global_position;
	randomize();
	if Engine.is_editor_hint():
		return ;

	$AnimationPlayer.stop()

	$"Sphère".set_surface_override_material(0, material);
	await get_tree().create_timer(randf_range(0.2, 0.4)).timeout
	$AnimationPlayer.play("default");
	chooseRandomDir();
	pass

func chooseRandomDir():
	target.x = randi_range( - 25, 25);
	target.y = 0;
	target.z = randi_range( - 25, 25);
	target += global_position;
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
	if isStunned or isDisabled:
		return ;
	if Engine.is_editor_hint():
		$"Sphère".set_surface_override_material(0, material);
		return ;
	if $NavigationAgent3D.is_navigation_finished():
		chooseRandomDir();
		return ;
	var next = $NavigationAgent3D.get_next_path_position();
	SafeLookAt.safe_look_at($FaceDirection, next);
	rotation.y = lerp_angle(rotation.y, $FaceDirection.global_rotation.y, 5 * delta)
	var vel = (next - global_transform.origin).normalized() * 6;
	velocity = vel;
	move_and_slide();

func reset():
	$AnimationPlayer.stop();
	$StuckTimer.stop();
	global_position = startingPos;
	$Area3D.set_deferred("monitoring", false);
	$CollisionShape3D.set_deferred("disabled", true);
	isDisabled = true;
	visible = false;
	$Respawn.start();
	
func enable():
	$AnimationPlayer.play("default");
	$StuckTimer.start();
	$Area3D.set_deferred("monitoring", true);
	$CollisionShape3D.set_deferred("disabled", false);
	visible = true;
	isDisabled = false;

func _on_area_3d_body_entered(body):
	if body is Player and !Globals.isPlayerDisabled:
		Globals.catchEgg.emit(isStunned);
		Globals.giveEgg.emit(1);
		$AudioStreamPlayer3D.play();
		reset();

func approxEqual(v1, v2):
	v1 = snapped(v1, Vector3(0.1, 0.1, 0.1));
	v2 = snapped(v2, Vector3(0.1, 0.1, 0.1));
	return (v1.is_equal_approx(v2));

func _on_stuck_timer_timeout():
	var dist = global_position.distance_to(Globals.playerReference.global_position);
	if dist > 40 and !isDisabled:
		$Area3D.set_deferred("monitoring", false);
		$CollisionShape3D.set_deferred("disabled", true);
		isDisabled = true;
		$AnimationPlayer.stop();
	elif dist <= 40 and isDisabled:
		$Area3D.set_deferred("monitoring", true);
		isDisabled = false;
		$CollisionShape3D.set_deferred("disabled", false);
		$AnimationPlayer.play("default");

	if cachePos == Vector3.ZERO:
		cachePos = global_position;
		return ;
	if approxEqual(cachePos, global_position):
		chooseRandomDir();
	cachePos = global_position;

func _on_respawn_timeout():
	enable();


func _on_step_timer_timeout():
	$Steps.pitch_scale = randf_range(3, 4);
	$Steps.play();
