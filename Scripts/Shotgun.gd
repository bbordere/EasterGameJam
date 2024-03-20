#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#randomize()
	#pass # Replace with function body.
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if Input.is_action_just_pressed("fire") and Globals.ammo != 0:
		#if (!$AnimationPlayer.is_playing()):
			##$AnimationPlayer.play("shoot")
			#for pellet in range(pelletsNumber):
				#instance = bulletScene.instantiate();
				#instance.position = $RayCast3D.global_position;
				#instance.transform.basis = $RayCast3D.global_transform.basis;
				#instance.rotation.x += randf_range(0, 0.2);
				#instance.rotation.y += randf_range(-0.2, 0.2);
				#get_tree().root.add_child(instance);
		#Globals.ammo -= 1;
		#Globals.updateAmmoLabel.emit();
	#pass




extends Node3D

const bulletScene = preload("res://Scenes/Bullet.tscn");

@export var spread = 0.8;
@export var pelletsNumber = 20;
@export var target_object : Node3D
@export var recoil_rotation_x : Curve
@export var recoil_rotation_z : Curve
@export var recoil_position_z : Curve
@export var recoil_amplitude := Vector3(1,1,1)
@export var lerp_speed : float = 1
@export var recoil_speed : float = 1


var instance = null;
var def_pos : Vector3
var def_rot : Vector3
var target_rot : Vector3
var target_pos : Vector3
var current_time : float
var canShoot = true;
var isTerminator = false;

func _ready():
	randomize();
	target_rot.y = rotation.y
	current_time = 1
	def_pos = position;

func _physics_process(delta):
	if Input.is_action_just_pressed("fire") and (Globals.ammo != 0 or isTerminator) and canShoot:
		canShoot = false;
		$Timer.start();
		$AudioStreamPlayer3D.play();
		for pellet in range(pelletsNumber):
			instance = bulletScene.instantiate();
			instance.position = $RayCast3D.global_position;
			instance.transform.basis = $RayCast3D.global_transform.basis;
			instance.rotation.x += randf_range(0, 0.2);
			instance.rotation.y += randf_range(-0.2, 0.2);
			get_tree().root.add_child(instance);
		if !isTerminator:
			Globals.ammo -= 1;
			Globals.updateAmmoLabel.emit();
		apply_recoil();
		
		
	if current_time < 1:
		current_time += delta * recoil_speed
		position.z = lerp(position.z, target_pos.z, lerp_speed * delta)
		rotation.z = lerp(rotation.z, target_rot.z, lerp_speed * delta)
		rotation.x = lerp(rotation.x, target_rot.x, lerp_speed * delta)
		
		target_rot.z = recoil_rotation_z.sample(current_time) * recoil_amplitude.y
		target_rot.x = recoil_rotation_x.sample(current_time) * -recoil_amplitude.x
		target_pos.z = recoil_position_z.sample(current_time) * recoil_amplitude.z
	position.z = lerp(position.z, def_pos.z, recoil_speed * 10 * delta)

func apply_recoil():
	recoil_amplitude.y *= -1 if randf() > 0.5 else 1
	target_rot.z = recoil_rotation_z.sample(0)
	target_rot.x = recoil_rotation_x.sample(0) 
	target_pos.z = recoil_position_z.sample(0)
	current_time = 0


func _on_timer_timeout():
	canShoot = true;
