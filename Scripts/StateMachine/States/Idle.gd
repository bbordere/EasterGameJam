extends State

@onready var navAgent = owner.get_node("NavigationAgent3D");

var desired_rotation_y;
var target = Vector3.ZERO;

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
	
	
func update(delta: float) -> void:
	var next = navAgent.get_next_path_position();
	navAgent.set_target_position(target);
	
	SafeLookAt.safe_look_at(owner.get_node("FaceDirection"), next);
	owner.rotation.y = lerp_angle(owner.rotation.y, owner.get_node("FaceDirection").global_rotation.y, 5 * delta)

	#if owner is Bell:
		#print(owner.global_position, " ", target);
		#next = Vector3(next.x, 3, next.z);
		#var vel = (next - owner.global_transform.origin).normalized() * owner.SPEED;
		#owner.velocity = Vector3(vel.x, 0, vel.z);
		#owner.velocity = vel;
		#owner.position.y = 1;
	#else:
	var vel = (next - owner.global_transform.origin).normalized() * owner.SPEED;
	owner.velocity = vel;

	
	if owner.playerDetected:
		owner.get_node("Timer").stop();
		state_machine.transition_to("Chasing");
	
