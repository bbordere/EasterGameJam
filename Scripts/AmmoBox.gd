extends CharacterBody3D

class_name AmmoBox

var isFreed = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if isFreed and !$AudioStreamPlayer.playing:
		queue_free();
	if not is_on_floor():
		velocity.y -= 0.1;
	move_and_slide();


func _on_area_3d_body_entered(body):
	if !(body is Player) or isFreed:
		return
	$AudioStreamPlayer.play();
	Globals.giveAmmo.emit(10);
	isFreed = true;
	visible = false;
	$CollisionShape3D.set_deferred("disabled", true);
