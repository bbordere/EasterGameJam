extends Node

var ammo = 20;
var health = 100;
var dmgMultiplier = 1.0;
var egg = 0;
var scoreMultiplier = 1.0;
var score = 0;
var mouseSensi = 0.2;

const DEFAULT_FOV = 90.0;
const DEFAULT_SPEED = 5.0;

var skills = {"dash": true, "double_jump": true, "super_dmg": true};

var playerReference = null;
var isPlayerDisabled = true;

signal giveAmmo(number);
signal giveEgg(number);
signal updateAmmoLabel;
signal updateHealthLabel;
signal updateEggLabel;
signal setMultiplier(value);
signal setScoreMultiplier(value);
signal catchEgg(stunStatus);
signal addScore(value);

func _ready():
	giveAmmo.connect(giveAmmoFunc);
	giveEgg.connect(giveEggFunc);
	setMultiplier.connect(setMultiplierFunc);
	setScoreMultiplier.connect(setScoreMultiplierFunc);
	addScore.connect(addScoreFunc);

func setMultiplierFunc(value):
	dmgMultiplier = value;
	
func setScoreMultiplierFunc(value):
	scoreMultiplier = value;

func giveAmmoFunc(number: int):
	ammo += number;
	Globals.updateAmmoLabel.emit()

func giveEggFunc(number: int):
	egg += number;
	Globals.updateEggLabel.emit()
	addScore.emit(1200);
	setScoreMultiplier.emit(scoreMultiplier + 0.25);
	
func addScoreFunc(value):
	score += value * scoreMultiplier;
	score = max(score, 0);
