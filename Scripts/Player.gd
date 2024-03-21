extends CharacterBody3D

class_name Player

var speed = Globals.DEFAULT_SPEED;
const JUMP_VELOCITY = 4.5
const LERP_SPEED = 10.0

var direction = Vector3.ZERO
var extraVel := Vector3.ZERO
var inputMouse := Vector2.ZERO
var defaultWeaponPos := Vector3.ZERO
var startingPos := Vector3.ZERO
var canSecondJump = false;
var canDash = true;
var canStun = true;
var isRunning = false;

@export var camTiltAmount: float = 0.05;
@export var weaponTiltAmount: float = 0.1;
@export var weaponSwayAmount: float = 0.008;
@export var weaponBobAmount: float = 0.02;
@export var weaponBobFreq: float = 0.02;

var BasketScene = preload("res://Scenes/Basket.tscn")
var basketInstance = null;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	randomize();
	Globals.playerReference = self;
	Globals.catchEgg.connect(catchEgg);
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	defaultWeaponPos = $Head/Weapon.position;
	startingPos = global_position;

func speedBuff():
	if isRunning:
		return;
	speed = 10;
	isRunning = true;
	var tween = get_tree().create_tween()
	tween.tween_property($Head/Camera3D, "fov", 120, 0.1);
	weaponBobFreq = 0.04;
	weaponBobAmount = 0.04;
	await get_tree().create_timer(randi_range(10, 20)).timeout
	isRunning = false;
	weaponBobAmount = 0.02;
	weaponBobFreq = 0.02;
	speed = Globals.DEFAULT_SPEED;
	
func weaponSpeedBuff():
	$Head/Weapon/Timer.wait_time = 0.2;
	$Head/Weapon.isTerminator = true;
	$Rage.visible = true;
	$AnimationPlayer.play("rage");
	
	await get_tree().create_timer(randi_range(5, 10)).timeout
	$AnimationPlayer.play("unrage");
	await get_tree().create_timer(0.2).timeout
	$Head/Weapon/Timer.wait_time = 0.6;
	$Head/Weapon.isTerminator = false;
	$Rage.visible = false;
	

func dmgBuff():
	Globals.setMultiplier.emit(3);
	await get_tree().create_timer(randi_range(10, 20)).timeout
	Globals.setMultiplier.emit(1);
	
func scoreBuff():
	var multi = Globals.scoreMultiplier;
	Globals.setMultiplier.emit(multi * 2);
	await get_tree().create_timer(randi_range(10, 20)).timeout
	Globals.setMultiplier.emit(multi);

func catchEgg(catchStatus):
	if catchStatus:
		canStun = true;
	var buffsFct = [speedBuff, weaponSpeedBuff, dmgBuff, scoreBuff];
	var buff = randi_range(0, 3);
	print(buff);
	buffsFct[buff].call();

func _input(event):
	if event is InputEventMouseMotion and !Globals.isPlayerDisabled:
		rotate_y(deg_to_rad(-event.relative.x * Globals.mouseSensi));
		$Head.rotate_x(deg_to_rad(-event.relative.y * Globals.mouseSensi));
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
	var unsignedDir = Vector2(abs(direction.x), abs(direction.z));
	if unsignedDir.x < 0.1 and unsignedDir.y < 0.1:
		return;
	var forward : Vector3 = -global_transform.basis.z.normalized()
	extraVel = forward * 50;
	if $Head/Camera3D.fov < 100:
		var tween = get_tree().create_tween()
		tween.tween_property($Head/Camera3D, "fov", 100, 0.1);
	$DashCooldown.start();
	
func _physics_process(delta):
	if Globals.isPlayerDisabled:
		return;
	if Globals.health == 0:
		Globals.health = 100;
		$Blackout.visible = true;
		$AnimationPlayer.play("blackout");
		global_position = startingPos;
		await get_tree().create_timer(0.3).timeout
		$Blackout.visible = false;
		Globals.setScoreMultiplier.emit(1);
		Globals.addScore.emit(-1500);
		Globals.ammo = 20;
		Globals.updateHealthLabel.emit();
		Globals.updateAmmoLabel.emit();

		
	if Input.is_action_just_pressed("stun") and canStun:
		canStun = false;
		basketInstance = BasketScene.instantiate();
		basketInstance.position = position;
		basketInstance.position.y += 0.4;
		basketInstance.transform.basis = $Head.global_transform.basis;
		get_tree().root.add_child(basketInstance);

	
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
	if Input.is_action_just_pressed("dash") and Globals.skills["dash"] and canDash:
		dash(direction)
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), 
						delta * LERP_SPEED);

	extraVel = lerp(extraVel, Vector3.ZERO, 0.1)
	if !isRunning:
		$Head/Camera3D.set_fov(lerp($Head/Camera3D.fov, Globals.DEFAULT_FOV, 0.1));
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		velocity += extraVel;
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()
	camTilt(input_dir, delta);
	weaponTilt(input_dir, delta);
	weaponSway(delta);
	weaponBob(velocity.length(), delta);

func takeDmg(amount):
	$Head/Camera3D.shake();
	Globals.health -= amount;
	Globals.health = max(Globals.health, 0);
	Globals.updateHealthLabel.emit();

func knock(pos, strength):
	var dir = pos.direction_to(global_position);
	dir *= strength;
	extraVel.x += dir.x;
	extraVel.z += dir.z;

func _on_timer_timeout():
	canDash = true;

func _on_stun_cooldown_timeout():
	canStun = true;
