extends Node2D



var faction_type #1-player,2-enemy

#Máximo de tropas permitido
var max_troops

#Número actual de tropas.
var troops_count;

var food_points
var leaves_points
var wood_points
var stone_points
var clay_points
var water_points

var root = get_tree().root.get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _get_number(_number):
	return _number

func _set_number(number,_number):
	number=_number

func check_figures():
	if troops_count != root.troops:
		_set_number(troops_count,root.troops)
		
	if food_points != root.food_points:
		_set_number(food_points,root.food_points)
	
	if leaves_points != root.leaves_points:
		_set_number(leaves_points,root.leaves_points)
		
	if wood_points != root.wood_points:
		_set_number(wood_points,root.wood_points)
		
	if clay_points != root.clay_points:
		_set_number(clay_points,root.clay_points)
	
	if water_points != root.water_points:
		_set_number(water_points,root.water_points)
		
	if stone_points != root.stone_points:
		_set_number(stone_points,root.stone_points)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_figures()
