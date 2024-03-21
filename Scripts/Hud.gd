extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.updateAmmoLabel.connect(updateAmmo);
	Globals.updateHealthLabel.connect(updateHealth);
	Globals.updateEggLabel.connect(updateEgg);
	Globals.setScoreMultiplier.connect(updateMultiplier);
	Globals.addScore.connect(updateScore);
	$TextureRect.visible = false;

func _process(delta):
	$Hud/Timer.text = "%d:%02d" % [floor($Timer.time_left / 60), int($Timer.time_left) % 60]

func updateAmmo():
	$Hud/Panel/Ammo.text = str(Globals.ammo);

func updateHealth():
	$Hud/Panel/Health.text = str(Globals.health);

func updateEgg():
	$Hud/Panel/Egg.text = str(Globals.egg);

func updateScore(value):
	$Hud/Score.text = "Score : " + str(int(Globals.score));

func updateMultiplier(value):
	$Hud/Multiplier.text = "x " + str(Globals.scoreMultiplier);
	
func _on_timer_timeout():
	Globals.playerReference.get_node("Rage").visible = false;
	Globals.isPlayerDisabled = true;
	$TextureRect.visible = true;
	$Hud/Viseur.visible = false;
	$TextureRect/Score.text = "Score: " + str(int(Globals.score))
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	Globals.score = 0;
	Globals.scoreMultiplier = 1;

func _on_button_button_up():
	Globals.isPlayerDisabled = false;
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	$TextureRect.visible = false;
	get_tree().change_scene_to_file("res://Scenes/map.tscn");

	
