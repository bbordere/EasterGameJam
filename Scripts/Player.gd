extends CharacterBody3D

class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const LERP_SPEED = 10.0

var mouseSensi = 0.2
var direction = Vector3.ZERO
var extraVel := Vector3.ZERO
var canSecondJump = false;
var canDash = true;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	$Head/Camera3D.make_current();

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouseSensi))
		$Head.rotate_x(deg_to_rad(-event.relative.y * mouseSensi))
		$Head.rotation.x = clamp($Head.rotation.x, deg_to_rad(-89), deg_to_rad(89));

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


func _on_timer_timeout():
	canDash = true;
