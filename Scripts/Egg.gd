extends Node3D

enum NamedEnum {Dash, DoubleJump, SuperDmg};
var skills = ["dash", "double_jump", "super_dmg"];
@export var type: NamedEnum


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body is Player:
		Globals.skills[skills[type]] = true;
		queue_free();
