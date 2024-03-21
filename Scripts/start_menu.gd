extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	$Background/World/Player.visible = false;
	$Background/World/Player.speed = 0;
	$Menu/MarginContainerSettings.visible = false;
	$Menu/MarginContainerBack.visible = false;
	$Menu/MarginContainerHow.visible = false;
	$Background/World/Player.global_position = $Background/SubViewportContainer/SubViewport/Camera3D.global_position;

func _process(delta):
	pass

func _on_start_button_button_up():
	Globals.isPlayerDisabled = false;
	get_tree().change_scene_to_file("res://Scenes/map.tscn")

func _on_settings_button_button_up():
	$Menu/MarginContainer.visible = false;
	$Menu/MarginContainerSettings.visible = true;
	$Menu/MarginContainerBack.visible = true;

func _on_how_to_play_button_up():
	$Menu/MarginContainer.visible = false;
	$Menu/MarginContainerHow.visible = true;
	$Menu/MarginContainerBack.visible = true;
	
func _on_back_button_button_up():
	$Menu/MarginContainer.visible = true;
	$Menu/MarginContainerSettings.visible = false;
	$Menu/MarginContainerHow.visible = false;
	$Menu/MarginContainerBack.visible = false;


func _on_sensitivity_h_slider_value_changed(value: float):
	Globals.mouseSensi = value;
