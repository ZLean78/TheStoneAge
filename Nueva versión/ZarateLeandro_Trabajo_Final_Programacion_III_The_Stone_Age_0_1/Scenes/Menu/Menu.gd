extends Node2D

func _ready():
	add_child(Globals.settings)

func _unhandled_input(_event):
	if Input.is_action_pressed("EscapeKey"):
		get_tree().quit()
	if Input.is_action_pressed("Settings"):
		Globals.settings.visible=!Globals.settings.visible
	
	

func _on_Start_pressed():
	remove_child(Globals.settings)
	Globals.go_to_scene("res://Scenes/Game4/Game4.tscn")


func _on_Quit_pressed():
	get_tree().quit()
