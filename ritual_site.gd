extends Node
@onready var interactable: Area3D = $Interactable

@export var ritual_points: int = 1 

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact() -> void:
	# Fetch the main scene node from the "main" group
	# This function allows this script to access any variables and functions quickly from main!! Very useful!
	var main_node = get_tree().get_first_node_in_group("main")
	
	if main_node and main_node.try_perform_ritual(ritual_points):
		# Only destroy the item if the player has enough bones
		queue_free()