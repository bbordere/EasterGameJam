extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.updateAmmoLabel.connect(updateAmmo);
	Globals.updateHealthLabel.connect(updateHealth);
	Globals.updateEggLabel.connect(updateEgg);
	Globals.setScoreMultiplier.connect(updateScore)
	Globals.addScore.connect(updateMultiplier)

func updateAmmo():
	$Hud/Panel/Ammo.text = str(Globals.ammo);

func updateHealth():
	$Hud/Panel/Health.text = "Health " + str(Globals.health);

func updateEgg():
	$Hud/Panel/Egg.text = str(Globals.egg);

func updateScore():
	$Hud/Score.text = "Score : " + str(Globals.score)

func updateMultiplier():
	$Hud/Multiplier.text = "X " + str(Globals.scoreMultiplier)

