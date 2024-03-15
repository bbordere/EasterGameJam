extends Node3D

const bulletScene = preload("res://Scenes/Bullet.tscn");

@export var spread = 0.8;
@export var pelletsNumber = 20;
var instance = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("fire") and Globals.ammo != 0:
		if (!$AnimationPlayer.is_playing()):
			$AnimationPlayer.play("shoot")
			for pellet in range(pelletsNumber):
				instance = bulletScene.instantiate();
				instance.position = $RayCast3D.global_position;
				instance.transform.basis = $RayCast3D.global_transform.basis;
				instance.rotation.x += randf_range(0, 0.2);
				instance.rotation.y += randf_range(-0.2, 0.2);
				get_tree().root.add_child(instance);
		Globals.ammo -= 1;
		Globals.updateAmmoLabel.emit();
	pass
