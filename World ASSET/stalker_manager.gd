extends Node3D

# Code that makes the Humanoid spawn to any marker with the "stalker_spots" group added
var enemy_scene = preload("res://NPC ANIMATED/Humanoid.tscn")

func spawn_enemy():
	var spots = get_tree().get_nodes_in_group("stalker_spots")
	if spots.is_empty():
		print("Error: No stalker spots found in the scene!")
		return
		
	var random_spot = spots.pick_random()
	
	var new_enemy = enemy_scene.instantiate()
	new_enemy.global_position = random_spot.global_position
	
	
	new_enemy.vanished.connect(func(): call_deferred("spawn_enemy"))
	
	add_child(new_enemy)
	
func _ready():
	spawn_enemy()
