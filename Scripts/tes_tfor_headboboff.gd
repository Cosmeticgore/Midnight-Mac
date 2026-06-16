extends StaticBody3D

func interact(incoming_player = null):
	print("You Touched The Thing")
	
	if is_in_group("HEADBOBOFF"):
		# Use the player passed in by the RayCast. 
		# If for some reason it's empty, we fall back to searching the tree!
		var target_player = incoming_player
		if not target_player:
			target_player = get_tree().get_first_node_in_group("PLAYER")
		
		if target_player and target_player.has_method("lock_headbob"):
			target_player.lock_headbob()
			print("Headbob Joke Done")
