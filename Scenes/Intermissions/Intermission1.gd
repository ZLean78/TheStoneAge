extends Node2D

func _ready():
	add_child(Globals.settings)
	AudioPlayer._stop_rain()
	AudioPlayer._select_music()
	AudioPlayer.music.play()
	$AnimationPlayer.play("Billboard")


func _on_Button_pressed():
	remove_child(Globals.settings)
	Globals.go_to_scene("res://Scenes/Game2/Game2.tscn")
