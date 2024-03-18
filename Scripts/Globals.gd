extends Node

var ammo = 0;
var health = 100;
var dmgMultiplier = 1.0;

var skills = {"dash": false, "double_jump": true, "super_dmg": true, "": false};

var playerReference = null;

signal giveAmmo(number);
signal updateAmmoLabel;
signal updateHealthLabel;
signal setMultiplier(value);

func _ready():
	giveAmmo.connect(giveAmmoFunc);
	setMultiplier.connect(setMultiplierFunc);

func setMultiplierFunc(value):
	dmgMultiplier = value;

func giveAmmoFunc(number: int):
	ammo += number;
	Globals.updateAmmoLabel.emit()

func _process(_delta):
	pass
	#print("ammo: ", ammo, ", health: ", health, ", fps: ", Engine.get_frames_per_second());
