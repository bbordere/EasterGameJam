extends Node3D

class_name Ennemy

var hp = 100;

# Called when the node enters the scene tree for the first time.
func _ready():
	$Hp.text = "HP: " + str(hp);

func takeDamage(dmg):
	hp -= dmg;
	hp = max(hp, 0);
	$Hp.text = "HP: " + str(hp);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
