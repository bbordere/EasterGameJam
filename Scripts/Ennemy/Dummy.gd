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

var ammoScene = preload("res://Scenes/AmmoBox.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	startingPos = global_position;
	add_to_group("ennemies");
	$Hp.text = "HP: " + str(hp);
	$StateMachine.connect("switch", updateState);
	init();
	
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if outOfRange:
		return;
	if (hp == 0 and !isDisabled):
		#$AnimationPlayer.play("death");
		hp = defaultHp;
		Globals.addScore.emit(scorePoints);
		await get_tree().create_timer(0.1).timeout;
		visible = false;
		isDisabled = true;
		var r = randi_range(0, 3);
		if (r == 2):
			instance = ammoScene.instantiate();
			instance.global_position = global_position;
			get_tree().root.add_child(instance);
		global_position = startingPos;
		await get_tree().create_timer(5).timeout;
		reset();
		visible = true;
		isDisabled = false;

func reset():
	$AnimationPlayer.play("RESET");

func enable():
	pass

func disable():
	pass

func _on_disable_timeout():
	if global_position.distance_to(Globals.playerReference.global_position) > 65:
		outOfRange = true;
		disable();
	else:
		outOfRange = false;
		enable();
