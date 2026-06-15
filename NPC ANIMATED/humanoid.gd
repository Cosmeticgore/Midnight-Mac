extends Node3D

signal vanished

var is_discovered = false
var is_onscreen = false

func _on_visible_on_screen_notifier_3d_screen_entered():
	is_onscreen = true
	is_discovered = true


func _on_visible_on_screen_notifier_3d_screen_exited():
	is_onscreen = false
	if is_discovered == true:
		#Deletes the Humanoid
		vanished.emit()
		queue_free()
