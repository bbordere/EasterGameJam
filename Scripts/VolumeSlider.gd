extends HSlider

@export var busName = "Music";
var busId: int;

func _ready():
	busId = AudioServer.get_bus_index(busName);
	value_changed.connect(valueChanged);


func valueChanged(value):
	AudioServer.set_bus_volume_db(busId, linear_to_db(value));
