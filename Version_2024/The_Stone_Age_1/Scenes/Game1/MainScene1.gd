extends Node2D

@onready var tool_bar2 = get_node("ToolbarContainer2/SubViewport/ToolBar2")
@onready var tool_bar = get_node("ToolbarContainer/SubViewport/ToolBar")
@onready var unit_node = get_node("SubViewportContainer/SubViewport/World/Units")
@onready var house = preload("res://Scenes/BarbHouse/BarbHouse.tscn")
@onready var houses =  get_node("SubViewportContainer/SubViewport/World/Houses")
@onready var camera =  get_node("SubViewportContainer/SubViewport/World/Camera")
@onready var navreg = get_node("SubViewportContainer/SubViewport/World/NavigationRegion2D")
@onready var world = get_node("SubViewportContainer/SubViewport/World")
@onready var tilemap = get_node("SubViewportContainer/SubViewport/World/TileMap")
@onready var townhall_node = get_node("SubViewportContainer/SubViewport/World/TownHall")
@onready var townhall = preload("res://Scenes/TownHall/town_hall.tscn")
@onready var trees = get_node("SubViewportContainer/SubViewport/World/Trees")
@onready var unit = preload("res://Scenes/Unit/Unit.tscn")


var navigation_mesh: NavigationPolygon
var region_rid: RID

# Called when the node enters the scene tree for the first time.
func _ready():
	tool_bar2.get_node("HouseButton").visible=true
	tool_bar2.get_node("TownHallButton").visible=true
	for tree in trees.get_children():
		tree.can_give_wood = false



func _unhandled_input(event):
	if tool_bar.townhall_button_down:
		var units=unit_node.get_children()
		for unit in units:
			if unit.selected:			
				if Game.cursor_mode=="TownHall" && event.is_action_pressed("RightClick") && houses.get_child_count()>=4 && Game.Wood>=80 && townhall_node.get_child_count()==0:
					var new_townhall = townhall.instantiate()
					new_townhall.position=unit.navi.target_position
					townhall_node.add_child(new_townhall)
					Game.Wood-=80
	
	if tool_bar.button_down:
		var units=unit_node.get_children()
		for unit in units:
			if unit.selected:			
				if Game.cursor_mode=="BarbHouse" && event.is_action_pressed("RightClick") && Game.Wood>=30:
					var new_house = house.instantiate()
					new_house.position=unit.navi.target_position
					houses.add_child(new_house)
					Game.Wood-=30
					
	if tool_bar2.unit_button_down:
		if Game.cursor_mode == "Man" && event.is_action_pressed("RightClick") && Game.Food>=15:
			var new_unit = unit.instantiate()	
			new_unit.position = get_global_mouse_position() + camera.position
			unit_node.add_child(new_unit)
			Game.Food-=15
			world._get_units()				
					

func _on_sub_viewport_container_mouse_exited():	
	tool_bar2.house_button_down=false
	tool_bar2.townhall_button_down=false
	tool_bar2.unit_button_down=false
	Input.set_custom_mouse_cursor(null)
	Game.cursor_mode="Default"
	
