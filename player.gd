class_name PlayerController
extends CharacterBody3D


func _physics_process(delta: float) -> void:
	#For WASD movements
	var input_dir: Vector2 = Input.get_vector("move_right", "move_left", "move_backwards", "move_forward")
	
	#Basic Locomotion
	var new_velocity = Vector2.ZERO
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
	if direction: 
		new_velocity = Vector2(direction.x, direction.z) * 19.0
	velocity = Vector3(new_velocity.x, velocity.y, new_velocity.y)

	move_and_slide()