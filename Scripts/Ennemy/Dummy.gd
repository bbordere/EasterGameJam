extends CharacterBody3D

class_name Dummy

var defaultHp = 100;

var hp = defaultHp;
var scorePoints = 0;
var instance = null;

var SPEED = 3.0
var startingPos = Vector3.ZERO;

var playerDetected = false;
var canAttack = false;
var isDisabled = false;
var outOfRange = false;
var sounds = [];

var ammoScene = preload("res://Scenes/AmmoBox.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	init();
	hp = defaultHp;
	sounds = $Sounds.get_children();
	startingPos = global_position;
	add_to_group("ennemies");
	$Hp.text = "HP: " + str(hp);
	$StateMachine.connect("switch", updateState);
	
func init():
	pass

func updateState(newState):
	$State.text = newState;

func takeDamage(dmg):
	hp -= dmg;
	hp = max(hp, 0);
	$Hp.text = "HP: " + str(hp);
	$Hurt.play("hit");

func moveRight():
	velocity = Vector3.RIGHT * SPEED;
	rotation_degrees = Vector3(0, -90, 0);
	
func moveLeft():
	velocity = Vector3.LEFT * SPEED;
	rotation_degrees = Vector3(0, 90, 0);
	
func moveForward():
	velocity = Vector3.FORWARD * SPEED;
	rotation_degrees = Vector3(0, 0, 0);
	
func moveBackward():
	velocity = Vector3.BACK * SPEED;
	rotation_degrees = Vector3(0, 180, 0);

func _on_area_3d_body_entered(body):
	if body is Player:
		playerDetected = true;

func _on_area_3d_body_exited(body):
	if body is Player:
		playerDetected = false;

func respawn():
	reset();
	hp = defaultHp;
	global_position = startingPos;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if outOfRange:
		return;
	if (hp == 0 and !isDisabled):
		isDisabled = true;
		Globals.addScore.emit(scorePoints);
		var r = randi_range(0, len(sounds) - 1);
		sounds[r].play();
		await get_tree().create_timer(0.1).timeout;
		visible = false;
		disable();
		r = randi_range(0, 2);
		if (r >= 1):
			instance = ammoScene.instantiate();
			get_tree().root.add_child(instance);
			instance.global_position = global_position;
		global_position = startingPos;
		await get_tree().create_timer(10).timeout;
		hp = defaultHp;
		$Hp.text = "HP: " + str(hp)
		reset();
		enable();
		isDisabled = false;
		visible = true;

func reset():
	$AnimationPlayer.play("RESET");

func enable():
	pass

func disable():
	pass

func _on_disable_timeout():
	var dist = global_position.distance_to(Globals.playerReference.global_position);
	if dist > 65 and !outOfRange:
		outOfRange = true;
		disable();
	elif dist <= 65 and outOfRange:
		outOfRange = false;
		enable();
