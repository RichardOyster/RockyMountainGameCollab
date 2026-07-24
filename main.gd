extends Node

@export var BoneGrave: PackedScene
# Preloads the grave scene for use

var bonescore: int = 0
var ritualscore: int = 0
var roundscore: int = 0

@export var graves_to_spawn: int = 1

var spawn_positions_array:Array[Vector3]
# This array will be necessary in getting the bone graves to spawn randomly in fixed locations.


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("penis") # Replace with function body.
	for spawn_markers in find_children("SpawnPoint*", "Marker3D", true, false):
		spawn_positions_array.append(spawn_markers.global_position)

	# Saftey check for spawnpoints
	if spawn_positions_array.is_empty():
		push_warning("No spawns were found loser. Check the Marker3D node names.")
	
	spawn_graves()

func spawn_graves() -> void:
	if BoneGrave == null:
		push_error("BoneGrave scene was not assigned in the inspector.")
		return

	var available_positions=spawn_positions_array.duplicate()
	available_positions.shuffle()
	# Removes used positions.

	var spawn_count = min(graves_to_spawn, available_positions.size())
	# Determines how many graves will be spawned based on how many we want.

	for i in range(spawn_count):
		# Instatiates the grave.
		var grave_instance = BoneGrave.instantiate()

		add_child(grave_instance)
		#Adds the grave as a child node of the main scene.

		grave_instance.global_position = available_positions[i]


	




func add_bonescore(amount: int) -> void:
	bonescore += amount
	print("Current bonescore is: " , bonescore)

func add_ritualscore(amount: int) -> void:
	ritualscore += amount

func try_perform_ritual(points: int) -> bool:
	if bonescore >= 1:
		bonescore -= 1
		ritualscore += points
		print("Ritual successful! Ritual Score: ", ritualscore, " | Bones left: ", bonescore)
		return true
	else:
		print("Not enough bones for ritual!")
		return false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
