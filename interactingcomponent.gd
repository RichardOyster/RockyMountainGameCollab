extends Node3D

#This script is for allowing interactable objects to be interactable.

@onready var interact_label: Label = $InteractLabel
var current_interactions := []
var can_interact := true
#This code calls the interact label and prepares variables for interactions

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_interact:
		if current_interactions:
			can_interact = false
			interact_label.hide()

			await current_interactions[0].interact.call()

			can_interact = true
			#The code above activates E as our interact key.

func _process(_delta: float) -> void:
	if current_interactions and can_interact:
		current_interactions.sort_custom(_sort_by_nearest)
		if current_interactions[0].is_interactable:
			interact_label.text = current_interactions[0].interact_name
			interact_label.show()
		else:
			interact_label.hide()
			#The code above deals with the interact labels, lines 24 - 28.
			#May need to change later when we add a progress bar to digging.

func _sort_by_nearest(area1, area2):
	var area1_dist = global_position.distance_to(area1.global_position)
	var area2_dist = global_position.distance_to(area2.global_position)
	return area1_dist < area2_dist
	#This code is for allowing objects that are closer to be interacted with first.

func _on_interact_range_area_exited(area: Area3D) -> void:
	current_interactions.push_back(area)

func _on_interact_range_area_entered(area: Area3D) -> void:
	current_interactions.erase(area)
