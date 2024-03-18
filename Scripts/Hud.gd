extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.updateAmmoLabel.connect(updateAmmo);
	Globals.updateHealthLabel.connect(updateHealth);
	Globals.updateEggTextureRect.connect(updateEgg);

func updateAmmo():
	$Hud/Panel/Ammo.text = str(Globals.ammo);

func updateHealth():
	$Hud/Panel/Health.text = "Health " + str(Globals.health);

func updateEgg():
	if (Globals.egg < 1):
		$Hud/Panel/TextureRect3.hide();
	else:
		$Hud/Panel/TextureRect3.show();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
