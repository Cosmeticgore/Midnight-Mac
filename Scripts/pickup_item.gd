extends Node3D


@export var item_name: String = "Borgir"

func interact(player):
	player.hold_item(item_name)
	queue_free()
