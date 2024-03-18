extends CharacterBody3D

class_name Dummy

var hp = 100;

var SPEED = 3.0

var playerDetected = false;
var canAttack = false;

# Called when the node enters the scene tree for the first time.
func _ready():
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
	if (hp == 0):
		$AnimationPlayer.play("death");
		await get_tree().create_timer(0.1).timeout;
		queue_free()
