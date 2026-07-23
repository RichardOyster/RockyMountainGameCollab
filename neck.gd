class_name CameraController
extends Node3D

var player_controller: PlayerController
var input_rotation: Vector3
var mouse_input: Vector2
var mouse_sensitivity: float = 0.005

var use_interpolitation: bool = false
var circle_strafe: bool = true

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player_controller = get_parent()
	
	# Initialize rotation matching the starting orientation
	input_rotation.y = player_controller.global_transform.basis.get_euler().y
	input_rotation.x = global_transform.basis.get_euler().x

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Keep raw relative motion here (standardizes direction)
		mouse_input.x += event.relative.x * mouse_sensitivity
		mouse_input.y += event.relative.y * mouse_sensitivity

func _process(delta: float) -> void:
	# Changed '-' to '+' to flip the vertical look direction
	input_rotation.x = clampf(input_rotation.x + mouse_input.y, deg_to_rad(-90), deg_to_rad(85))
	
	# Horizontal look rotation
	input_rotation.y -= mouse_input.x

	# Rotate camera controller up and down locally
	transform.basis = Basis.from_euler(Vector3(input_rotation.x, 0.0, 0.0))

	# Rotate player left and right globally
	player_controller.global_transform.basis = Basis.from_euler(Vector3(0.0, input_rotation.y, 0.0))

	# Reset mouse input for the next frame
	mouse_input = Vector2.ZERO










