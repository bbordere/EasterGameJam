extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.updateAmmoLabel.connect(updateAmmo);
	Globals.updateHealthLabel.connect(updateHealth);
	Globals.updateEggLabel.connect(updateEgg);

func updateAmmo():
	$Hud/Panel/Ammo.text = str(Globals.ammo);

func updateHealth():
	$Hud/Panel/Health.text = "Health " + str(Globals.health);

func updateEgg():
	$Hud/Panel/Egg.text = str(Globals.egg);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
