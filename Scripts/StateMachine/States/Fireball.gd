extends State

const fireballScene = preload("res://Scenes/FireBall.tscn");

var instance;

func enter(_msg := {}) -> void:
	if !owner.canShoot:
		state_machine.transition_to("Chasing");
		return;
	owner.canShoot = false;
	owner.get_node("FireCooldown").start();
	instance = fireballScene.instantiate();
	instance.position = owner.global_position;
	instance.transform.basis = owner.global_transform.basis;
	get_tree().root.add_child(instance);
	SafeLookAt.safe_look_at(instance, Globals.playerReference.global_position);
	state_machine.transition_to("Chasing");
	
	

func physics_update(_delta: float) -> void:
	pass



