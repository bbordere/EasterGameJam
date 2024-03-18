extends State

func enter(_msg := {}) -> void:
	pass


func update(_delta: float) -> void:
	if !owner.canAttack:
		owner.get_node("AnimationPlayer").play("walk")
		state_machine.transition_to("Chasing");
		return
	if owner.get_node("AnimationPlayer").current_animation == "walk":
		owner.get_node("AnimationPlayer").stop();
	if (!owner.get_node("AnimationPlayer").is_playing()):
		owner.get_node("AnimationPlayer").play("melee")
		owner.attack();
