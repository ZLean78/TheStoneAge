extends Node2D

func _ready():
	AudioPlayer._select_music()
	AudioPlayer.music.play()
	$AnimationPlayer.play("Billboard")


func _on_Button_pressed():
	Globals.go_to_scene("res://Scenes/Game2/Game2.tscn")
