extends Node2D


func _unhandled_input(event):
	if Input.is_action_pressed("EscapeKey"):
		get_tree().quit()

func _on_Start_pressed():
	get_tree().change_scene("res://Scenes/Game3/Game3.tscn")


func _on_Quit_pressed():
	get_tree().quit()
