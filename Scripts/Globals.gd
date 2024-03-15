extends Node

var ammo = 0;
var health = 100;

signal giveAmmo(number);

func _ready():
	giveAmmo.connect(giveAmmoFunc);

func giveAmmoFunc(number: int):
	ammo += number;
	print("Current Ammo: ", ammo);

func _process(_delta):
	pass
	#print("ammo: ", ammo, ", health: ", health, ", fps: ", Engine.get_frames_per_second());
