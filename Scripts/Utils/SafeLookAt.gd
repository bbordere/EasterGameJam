extends Node

class_name Utils

func safe_look_at(node: Node3D, target: Vector3) -> void:
	var direction: Vector3 = (target - node.global_transform.origin).normalized()
	for up in [Vector3.UP, Vector3.RIGHT, Vector3.BACK]:
		if abs(up.dot(direction)) != 1 and !node.global_position.is_equal_approx(target):
			node.look_at(target, up)
			break
