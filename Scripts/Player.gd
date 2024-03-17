extends CharacterBody3D

class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const LERP_SPEED = 10.0

var mouseSensi = 0.2
var direction = Vector3.ZERO
var extraVel := Vector3.ZERO
var inputMouse := Vector2.ZERO
var defaultWeaponPos := Vector3.ZERO
var canSecondJump = false;
var canDash = true;

@export var camTiltAmount: float = 0.05;
@export var weaponTiltAmount: float = 0.1;
@export var weaponSwayAmount: float = 0.008;
@export var weaponBobAmount: float = 0.02;
@export var weaponBobFreq: float = 0.02;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Globals.playerReference = self;
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	defaultWeaponPos = $Head/Weapon.position;

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouseSensi))
		$Head.rotate_x(deg_to_rad(-event.relative.y * mouseSensi))
		$Head.rotation.x = clamp($Head.rotation.x, deg_to_rad(-89), deg_to_rad(89));
		inputMouse = event.relative;

func camTilt(input, delta):
	$Head/Camera3D.rotation.z = lerp($Head/Camera3D.rotation.z, -input.x * camTiltAmount, 10 * delta);

func weaponTilt(input, delta):
	$Head/Weapon.rotation.z = lerp($Head/Weapon.rotation.z, -input.x * weaponTiltAmount, 10 * delta);

func weaponSway(delta):
	inputMouse = lerp(inputMouse, Vector2.ZERO, 10 * delta);
	$Head/Weapon.rotation.x = lerp($Head/Weapon.rotation.x, inputMouse.y * weaponSwayAmount, 10 * delta);
	$Head/Weapon.rotation.y = lerp($Head/Weapon.rotation.y, inputMouse.x * weaponSwayAmount, 10 * delta);

func weaponBob(vel, delta):
	if vel > 0.5 and is_on_floor():
		$Head/Weapon.position.y = lerp($Head/Weapon.position.y, defaultWeaponPos.y + sin(Time.get_ticks_msec() * weaponBobFreq) * weaponBobAmount, 10 * delta)
		$Head/Weapon.position.x = lerp($Head/Weapon.position.x, defaultWeaponPos.x + sin(Time.get_ticks_msec() * weaponBobFreq * 0.5) * weaponBobAmount, 10 * delta)
		
	else:
		$Head/Weapon.position.y = lerp($Head/Weapon.position.y, defaultWeaponPos.y, 10 * delta)
		$Head/Weapon.position.x = lerp($Head/Weapon.position.x, defaultWeaponPos.x, 10 * delta)

func dash(direction):
	canDash = false
	var unsignedDir = Vector2(abs(direction.x), abs(direction.z));;
	if unsignedDir.x < 0.1 and unsignedDir.y < 0.1:
		return;
	if (unsignedDir.x > unsignedDir.y):
		extraVel.x += sign(direction.x) * 40;
	else:
		extraVel.z += sign(direction.z) * 40;
	var tween = get_tree().create_tween()
	tween.tween_property($Head/Camera3D, "fov", 95, 0.1);
	$DashCooldown.start();
	
func _physics_process(delta):
	if not is_on_floor():
		if Input.is_action_just_pressed("ui_accept") and Globals.skills["double_jump"] and canSecondJump:
			velocity.y = JUMP_VELOCITY
			canSecondJump = false;
		else:
			velocity.y -= gravity * delta
	else:
		canSecondJump = Globals.skills["double_jump"];

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), 
						delta * LERP_SPEED);
	
	if Input.is_action_just_pressed("dash") and Globals.skills["dash"] and canDash:
		dash(direction)
	extraVel = lerp(extraVel, Vector3.ZERO, 0.1)
	$Head/Camera3D.set_fov(lerp($Head/Camera3D.fov, 90.0, 0.1));
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		velocity += extraVel;
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
	camTilt(input_dir, delta);
	weaponTilt(input_dir, delta);
	weaponSway(delta);
	weaponBob(velocity.length(), delta);

func takeDmg(amount):
	$Head/Camera3D.shake();
	Globals.updateHealthLabel.emit();
	Globals.health -= 4;

func knock(pos, strength):
	var dir = pos.direction_to(global_position);
	dir *= strength;
	extraVel.x += dir.x;
	extraVel.z += dir.z;

func _on_timer_timeout():
	canDash = true;
