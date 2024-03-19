extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	$Background/World/Player.visible = false;
	$Background/World/Player.speed = 0;
	$Menu/MarginContainer2.visible = false;
	$Menu/MarginContainer3/VBoxContainer/BackButton.visible = false;

func _process(delta):
	pass

func _on_start_button_button_up():
	get_tree().change_scene_to_file("res://Scenes/test.tscn")
	
	$Background/World/Player.visible = true;
	$Background/World/Player.speed = Globals.DEFAULT_SPEED;

func _on_settings_button_button_up():
	$Menu/MarginContainer.visible = false;
	$Menu/MarginContainer2.visible = true;
	$Menu/MarginContainer3/VBoxContainer/BackButton.visible = true;

func _on_back_button_button_up():
	$Menu/MarginContainer.visible = true;
	$Menu/MarginContainer2.visible = false;
	$Menu/MarginContainer3/VBoxContainer/BackButton.visible = false;


func _on_sensitivity_h_slider_value_changed(value: float):
	Globals.mouseSensi = value;
