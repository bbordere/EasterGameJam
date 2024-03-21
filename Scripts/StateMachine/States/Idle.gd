extends State

@onready var navAgent = owner.get_node("NavigationAgent3D");

var desired_rotation_y;
var target = Vector3.ZERO;
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	randomize();
	owner.get_node("Timer").connect("timeout", chooseRandomDir);

func enter(_msg := {}) -> void:
	owner.get_node("Timer").start();
	chooseRandomDir();
	pass

func chooseRandomDir():
	owner.get_node("Timer").wait_time = randi_range(1, 4);
	target.x = randi_range(-20, 20);
	target.y = 0;
	target.z = randi_range(-20, 20);
	target += owner.global_position;
	navAgent.set_target_position(target);
	
	
func update(delta: float) -> void:
	if owner.outOfRange:
		return;
	if owner.get_node("NavigationAgent3D").is_navigation_finished():
		chooseRandomDir();
		return ;
	var next = navAgent.get_next_path_position();

	SafeLookAt.safe_look_at(owner.get_node("FaceDirection"), next);
	owner.rotation.y = lerp_angle(owner.rotation.y, owner.get_node("FaceDirection").global_rotation.y, 5 * delta)

	var vel = (next - owner.global_transform.origin).normalized() * owner.SPEED;
	owner.velocity = vel;
	if owner.playerDetected and !Globals.isPlayerDisabled:
		owner.get_node("Timer").stop();
		state_machine.transition_to("Chasing", {"Attack": "Fireball" if owner is Bell else "Melee"});
	
