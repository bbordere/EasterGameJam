extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.updateAmmoLabel.connect(updateAmmo);

func updateAmmo():
	$TopContainer/Ammo.text = "Ammo: " + str(Globals.ammo);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
