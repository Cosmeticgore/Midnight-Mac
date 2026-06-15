extends StaticBody3D

func interact():
	print("You Touched The Thing")
	
	# Use 'self' to check if THIS specific cube is in the group
	if self.is_in_group("HEADBOBOFF"):
		
		# We need to find the player. 
		# If this cube is just sitting in the main game world, 'owner' might point to the Map/Level, not the Player!
		# A safer way is to ask the scene tree to find the Player node:
		var player = get_tree().get_first_node_in_group("PLAYER")
		
		if player and player.has_method("lock_headbob"):
			player.lock_headbob()
			print("Headbob Joke Done")
