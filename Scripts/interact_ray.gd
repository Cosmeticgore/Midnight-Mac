extends RayCast3D

func _physics_process(_delta):
	if is_colliding():
		var hit_object = get_collider()
		
		#FUCKIN AI HAD TO HELP NPPPPPPPPOOOOOOOOOOOOOOOO
		#Basic interaction 
		if hit_object and hit_object.is_in_group("INTERACTABLE"):
			if Input.is_action_just_pressed("interact"):
				if hit_object.has_method("interact"):
					hit_object.interact(owner)       
