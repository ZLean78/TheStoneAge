extends Node2D

onready var options=$OptionsMenu

func _ready():
	add_child(Globals.settings)
	AudioPlayer._select_music()
	AudioPlayer.music.play()
	$AnimationPlayer.play("Billboard")

func _unhandled_input(event):
	if event.is_action_pressed("EscapeKey"):
		options.visible=!options.visible

func _on_AnimationPlayer_animation_finished(anim_name):
	remove_child(Globals.settings)
	Globals.go_to_scene("res://Scenes/Menu/Menu.tscn")


func _on_Settings_pressed():
	Globals.settings.visible=!Globals.settings.visible
	options.visible=false


func _on_Back_pressed():
	options.visible=false


func _on_Quit_pressed():
	remove_child(Globals.settings)
	Globals.go_to_scene("res://Scenes/Menu/Menu.tscn")
