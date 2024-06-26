extends State

@export var CHASE_SPEED = 6;

var attackName = ""

func enter(_msg:={}) -> void:
	if owner is Bell:
		CHASE_SPEED = 3;
	if (_msg != {}):
		attackName = _msg["Attack"];

func physics_update(delta: float) -> void:
	if owner.outOfRange:
		return;
	if !owner.playerDetected or Globals.isPlayerDisabled:
		state_machine.transition_to("Idle");
		return
	SafeLookAt.safe_look_at(owner.get_node("FaceDirection"), owner.get_node("NavigationAgent3D").get_next_path_position());
	owner.rotate_y(deg_to_rad(owner.get_node("FaceDirection").rotation.y * 10));
	owner.get_node("NavigationAgent3D").set_target_position(Globals.playerReference.position);
	var vel = (owner.get_node("NavigationAgent3D").get_next_path_position() - owner.transform.origin).normalized() * CHASE_SPEED;
	owner.velocity = vel;
	if owner.canAttack:
		state_machine.transition_to(attackName);
		return
