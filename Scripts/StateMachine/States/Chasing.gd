extends State

@export var CHASE_SPEED = 2;

func enter(_msg := {}) -> void:
	pass

func physics_update(delta: float) -> void:
	if !owner.playerDetected:
		state_machine.transition_to("Idle");
		return
	owner.get_node("FaceDirection").look_at(Globals.playerReference.global_transform.origin, Vector3.UP);
	owner.rotate_y(deg_to_rad(owner.get_node("FaceDirection").rotation.y * 10));
	owner.get_node("NavigationAgent3D").set_target_position(Globals.playerReference.position);
	var vel = (owner.get_node("NavigationAgent3D").get_next_path_position() - owner.transform.origin).normalized() * CHASE_SPEED;
	owner.velocity = vel;
	if owner.canAttack:
		state_machine.transition_to("Melee");
		return
