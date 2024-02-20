extends Node2D

@onready var tree = preload("res://WorldObjects/tree.tscn")
@onready var house = preload("res://Scenes/FoodHouse/foodHouse.tscn")

@onready var resources = get_node("../Resources")
@onready var barb_houses = get_node("../Houses")

var tile_size = 16

#enum {OBSTACLE,COLLECTIBLE,RESOURCE}
var grid_size = Vector2(160,160)
var grid = []
var can_spawn_house=false
var can_spawn_barbhouse=false

# Called when the node enters the scene tree for the first time.
func _ready():
	#print(OBSTACLE)
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)
	
	var positions = []
	for i in range(50):
		var xcoor = (randi()%int(grid_size.x))
		var ycoor = (randi()%int(grid_size.y))
		var grid_pos = Vector2(xcoor,ycoor)
		if not grid_pos in positions:			
			positions.append(grid_pos)
			
	
	
	for pos in positions:
		var new_tree = tree.instantiate()
		new_tree.set_position(tile_size*pos)
		grid[pos.x][pos.y] = "OBSTACLE"
		add_child(new_tree)
		
func _unhandled_input(_event):
	if Input.is_action_pressed("LeftCtrl"):
		can_spawn_house = true
	else:
		can_spawn_house = false


func _input(event):
	
	if event.is_action_pressed("LeftClick") && can_spawn_house:
		var mouse_pos = get_global_mouse_position()
		var multiX = int(round(mouse_pos.x)/tile_size)		
		#var numX = multiX*tile_size
		var multiY = int(round(mouse_pos.y)/tile_size)		
		#var numY = multiY*tile_size
		var new_pos = Vector2(multiX,multiY)
		var around = false
		
		for i in range(tile_size):
			if (grid[multiX+i][multiY] != null) or (grid[multiX-i][multiY] != null) or (grid[multiX][multiY+i] != null) or (grid[multiX][multiY-i] != null):
				around = true
		
			if grid[multiX][multiY] == null:
				if around == false:
					var new_house = house.instantiate()
					new_house.set_position(tile_size*new_pos)
					grid[multiX][multiY] = "RESOURCE"
					resources.add_child(new_house)
				else:
					print("ALREADY HAS A BUILDING NEAR IT.")		
		pass
