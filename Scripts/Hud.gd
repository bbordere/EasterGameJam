extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.updateAmmoLabel.connect(updateAmmo);
	Globals.updateHealthLabel.connect(updateHealth);

func updateAmmo():
	$TopContainer/Ammo.text = "Ammo: " + str(Globals.ammo);

func updateHealth():
	$TopContainer/Health.text = "Health " + str(Globals.health);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
