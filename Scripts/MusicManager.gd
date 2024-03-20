extends Node


# Called when the node enters the scene tree for the first time.
var songs = [];
var curSong = null;
var i = 0;

func _ready():
	songs = get_children();
	randomize();
	i = randi_range(0, len(songs) - 1);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !curSong or !curSong.playing:
		curSong = songs[i];
		curSong.play();
		i += 1;
		
