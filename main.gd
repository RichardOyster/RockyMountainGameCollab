extends Node

@export var BoneGrave: PackedScene
# Preloads the grave scene for use

@export var ritual_site_2: PackedScene
@export var ritual_site_3: PackedScene

var bonescore: int = 0
var ritualscore: int = 0
var roundscore: int = 0
var totalbonescore: int = 0

var bone_costs: Array[int] = [1, 3, 5]

@export var graves_to_spawn: int = 1

var spawn_positions_array:Array[Vector3]
# This array will be necessary in getting the bone graves to spawn randomly in fixed locations.


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	add_to_group("main")

	for spawn_markers in find_children("SpawnPoint*", "Marker3D", true, false):
		spawn_positions_array.append(spawn_markers.global_position)

	# Saftey check for spawnpoints
	if spawn_positions_array.is_empty():
		push_warning("No spawns were found loser. Check the Marker3D node names.")
	
	spawn_graves()

	var initial_site = find_child("RitualSite*", true, false)
	if initial_site and initial_site.has_signal("ritual_completed"):
		initial_site.ritual_completed.connect(_on_ritual_site_completed)

	# --- FOOLPROOF SIGNAL CONNECTION ---
	# Checks all nodes in the scene to find your starting ritual site
	for node in find_children("*", "", true, false):
		if node.has_signal("ritual_completed"):
			# Connect it if it isn't connected already
			if not node.ritual_completed.is_connected(_on_ritual_site_completed):
				node.ritual_completed.connect(_on_ritual_site_completed)

func spawn_graves() -> void:
	if BoneGrave == null:
		push_error("BoneGrave scene was not assigned in the inspector.")
		return

	# UPDATE THE GRAVE COUNT BEFORE SPAWNING!!
	graves_to_spawn = get_required_bones()

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
	totalbonescore += amount
	print("Current bonescore is: " , bonescore)
	print("Total bonescore is: ", totalbonescore)

func add_ritualscore(amount: int) -> void:
	ritualscore += amount

func get_required_bones() -> int:
	if roundscore < bone_costs.size():
		return bone_costs[roundscore]
	else:
		# Fallback formula for rounds higher than the array size
		return 15 + (roundscore - 4) * 10

func try_perform_ritual(points: int) -> bool:
	var required_bones: int = get_required_bones()

	if bonescore >= required_bones:
		bonescore -= required_bones
		ritualscore += points
		roundscore += 1
		print("Ritual successful! Ritual Score: ", ritualscore, " | Bones left: ", bonescore)
		print("Ritual successful! Advanced to round: ", roundscore)
		spawn_graves()
		return true
	else:
		print("Need ", required_bones, " bones for round ", roundscore, ", but only have ", bonescore)
		print("Current round is: ", roundscore)
		return false
# This function advances the rounds and grabs required bones need to advance the round. So far we will only have 3 rounds.

func _on_ritual_site_completed(site_position: Vector3) -> void:
	# roundscore has already incremented inside try_perform_ritual()
	match roundscore:
		1:
			_replace_ritual_site(ritual_site_2, site_position)
		2:
			_replace_ritual_site(ritual_site_3, site_position)
		3:
			trigger_game_over()

func _replace_ritual_site(next_site_scene: PackedScene, pos: Vector3) -> void:
	if next_site_scene == null:
		push_error("Next ritual site scene is not assigned in the Inspector!")
		return

	var new_site = next_site_scene.instantiate()
	add_child(new_site)
	new_site.global_position = pos
	
	# Listen for the signal on the newly spawned site so the chain continues!
	if new_site.has_signal("ritual_completed"):
		new_site.ritual_completed.connect(_on_ritual_site_completed)


func trigger_game_over() -> void:
	print("--- GAME OVER! Ritual fully completed! Final Score: ", ritualscore, " ---")
	# Show end game screen, pause game, or switch scene:
	# get_tree().change_scene_to_file("res://game_over_screen.tscn")
# This function will be used to end the game when the 5th bone at the end of round 3 (round 2) is collected.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
