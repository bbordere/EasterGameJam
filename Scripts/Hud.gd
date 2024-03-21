extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.updateAmmoLabel.connect(updateAmmo);
	Globals.updateHealthLabel.connect(updateHealth);
	Globals.updateEggLabel.connect(updateEgg);
	Globals.setScoreMultiplier.connect(updateMultiplier);
	Globals.addScore.connect(updateScore);

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
	pass # Replace with function body.
