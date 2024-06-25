extends Node2D

var civilization_number=0
var civilization_name=""

func _ready():
	add_child(Globals.settings)
	randomize()
	AudioPlayer._select_music()
	AudioPlayer.music.play()
	$Narrative.text=$Narrative.text+_get_civilization()
	$AnimationPlayer.play("Billboard")


func _on_Button_pressed():
	remove_child(Globals.settings)
	Globals.go_to_scene("res://Scenes/Credits/Credits.tscn")

func _get_civilization()->String:
	
	civilization_number=randi()%4+1
	
	match civilization_number:
		1:
			civilization_name=" los Sumerios."
		2:
			civilization_name=" los Asirios."
		3:
			civilization_name=" los Caldeos."
		4: 
			civilization_name=" los Acadios."
	
	return civilization_name
			 

func _unhandled_input(event):
	if event.is_action_pressed("EscapeKey"):
		Globals.settings.visible=!Globals.settings.visible

func _clear_globals():
	
	Globals.food_points = 15
	Globals.leaves_points = 0
	Globals.stone_points = 0
	Globals.wood_points = 0
	Globals.clay_points = 0
	Globals.water_points = 0
	Globals.copper_points = 0

	Globals.e_food_points = 0
	Globals.e_leaves_points = 0
	Globals.e_stone_points = 0
	Globals.e_wood_points = 0
	Globals.e_clay_points = 0
	Globals.e_water_points = 0
	Globals.e_copper_points = 0

	Globals.group_dressed = false
	Globals.group_has_bag = false

	Globals.is_fire_discovered = false
	Globals.is_wheel_invented = false
	Globals.is_stone_weapons_developed = false
	Globals.is_claypot_made = false
	Globals.is_agriculture_developed = false
	Globals.is_townhall_created = false
	Globals.is_pottery_developed=false
	Globals.is_carpentry_developed=false
	Globals.is_mining_developed=false
	Globals.is_metals_developed=false
	Globals.is_first_tower_built=false
	Globals.is_barn_built=false
	Globals.is_fort_built=false
	Globals.is_enemy_fort_built=false
	Globals.is_townhall_down=false
	Globals.is_enemy_townhall_down=false

	Globals.houses_p=[]
	Globals.townhall_p=Vector2()
	Globals.barn_p=Vector2()
	Globals.fort_p=Vector2()
	Globals.towers_p=[]
	Globals.warchief_index=0
	
