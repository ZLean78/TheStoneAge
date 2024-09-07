extends "res://Scenes/Citizen/Citizen.gd"

onready var general_mark

# Called when the node enters the scene tree for the first time.
func _ready():
	general_mark=warchief_mark
	is_girl=false
	is_general=true
	is_dressed=true
	has_bag=true
	bar=$Bar
	bar.value=health
	
