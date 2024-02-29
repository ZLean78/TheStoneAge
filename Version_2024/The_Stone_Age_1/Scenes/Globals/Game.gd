extends Node

@onready var spawn = preload("res://Scenes/Globals/spawn_unit.tscn")
@onready var mini_map = preload("res://Scenes/MiniMap/MiniMap.gd")
@onready var mini_map_scene = preload("res://Scenes/MiniMap/MiniMap.tscn")
@onready var barbHouse = load("res://MouseIcons/barbHouse.png")
@onready var greyBarbHouse = load("res://MouseIcons/barbHouseGrey.png")
@onready var townHall = load("res://MouseIcons/townHall.png")
@onready var greyTownHall = load("res://MouseIcons/townHallGrey.png")
@onready var man = load("res://MouseIcons/man.png")
#@onready var camera = get_node("MainScene/SubViewportContainer/SubViewport/World/Camera")


var Wood = 0
var Food = 0
var mouse_entered = false
var cursor_mode = null

func spawn_unit(position):
	var path = get_tree().get_root().get_node("MainScene/SubViewportContainer/SubViewport/World/UI")
	var hasSpawned = false
	for i in path.get_child_count():
		if "spawned_unit" in path.get_child(i).name:
			hasSpawned = true
	if hasSpawned == false:		
		var spawned_unit = spawn.instantiate()
		spawned_unit.position = position
		path.add_child(spawned_unit)


