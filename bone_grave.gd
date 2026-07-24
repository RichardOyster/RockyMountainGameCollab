extends Node3D

@onready var interactable: Area3D = $Interactable

@export var bone_points: int = 1 

func _ready() -> void:
    interactable.interact = _on_interact

func _on_interact() -> void:
    # Safely calls 'add_bonescore' on our Main scene using the "main" group
    get_tree().call_group("main", "add_bonescore", bone_points)
    
    # If you want the item to disappear when picked up:
    queue_free()
