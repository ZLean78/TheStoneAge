extends Node2D

@onready var tool_bar = get_node("ToolbarContainer/SubViewport/ToolBar")
@onready var unit_node = get_tree().get_root().get_node("MainScene/SubViewportContainer/SubViewport/World/Units")
@onready var house = preload("res://Houses/BarbHouse.tscn")
@onready var houses =  get_tree().get_root().get_node("MainScene/SubViewportContainer/SubViewport/World/Houses")
@onready var camera =  get_tree().get_root().get_node("MainScene/SubViewportContainer/SubViewport/World/Camera")
@onready var navreg = get_tree().get_root().get_node("MainScene/SubViewportContainer/SubViewport/World/NavigationRegion2D")
@onready var world = get_tree().get_root().get_node("MainScene/SubViewportContainer/SubViewport/World")
@onready var tilemap = get_tree().get_root().get_node("MainScene/SubViewportContainer/SubViewport/World/TileMap")
@onready var townhall_node = get_tree().get_root().get_node("MainScene/SubViewportContainer/SubViewport/World/TownHall")
@onready var townhall = preload("res://TownHall/town_hall.tscn")

var navigation_mesh: NavigationPolygon
var region_rid: RID

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
	#pass

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
								
					

func _on_sub_viewport_container_mouse_exited():	
	tool_bar.button_down=false
	tool_bar.townhall_button_down=false
	Input.set_custom_mouse_cursor(null)
	Game.cursor_mode="Default"
	
