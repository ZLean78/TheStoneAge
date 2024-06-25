extends Node2D

onready var music=$Music
onready var soundFx=$Rain

func _select_music():
	if Globals.current_scene.name=="Menu":
		music.stream=load("res://Sound/Opening.ogg")
	if Globals.current_scene.name=="Game":
		music.stream=load("res://Sound/Stage1.ogg")
	if Globals.current_scene.name=="Game2":
		music.stream=load("res://Sound/Stage2.ogg")
	if Globals.current_scene.name=="Game3":
		music.stream=load("res://Sound/Stage3.ogg")
	if Globals.current_scene.name=="Game4":
		music.stream=load("res://Sound/Stage4.ogg")
	if Globals.current_scene.name=="Game5":
		music.stream=load("res://Sound/Stage5.ogg")
	
func _play_rain():
	if Globals.current_scene.its_raining:
		if !$Rain.playing:
			$Rain.play()
	else:
		if $Rain.playing:
			$Rain.stop() 
