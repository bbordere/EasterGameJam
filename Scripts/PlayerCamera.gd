extends Camera3D

@export var period = 0.1
@export var magnitude = 0.01

func shake():
	var initial_transform = self.transform 
	var elapsed_time = 0.0

	while elapsed_time < period:
		var offset = Vector3(randf_range(-magnitude, magnitude),
							randf_range(-magnitude, magnitude),
							0.0)

		self.transform.origin = initial_transform.origin + offset
		elapsed_time += 0.025
		#await get_tree().process_frame
		await get_tree().create_timer(0.025).timeout;

	self.transform = initial_transform
