extends Node3D

signal ritual_completed(site_position: Vector3)
# This signal is so that Main knows that the site is being removed

@onready var interactable: Area3D = $Interactable

@export var ritual_points: int = 1 

func _ready() -> void:
	if interactable:
		interactable.interact = _on_interact

func _on_interact() -> void:
	# Fetch the main scene node from the "main" group
	# This function allows this script to access any variables and functions quickly from main!! Very useful!
	var main_node = get_tree().get_first_node_in_group("main")
	
	if main_node and main_node.try_perform_ritual(ritual_points):
		# Pass the site's global position through the signal before freeing it
		ritual_completed.emit(global_position)
		queue_free()