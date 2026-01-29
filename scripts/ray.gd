extends RayCast2D


func _physics_process(delta: float):
	if is_colliding():
		print("colliding")
