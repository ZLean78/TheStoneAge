extends Node2D

var unit_count = 1
var food_points = 0
var its_raining = false


onready var food_timer = $food_timer
onready var tile_map = $TileMap
export (PackedScene) var Unit

var all_units=[]
var all_trees=[]
var sheltered=[]

func _ready():
	#all_trees.append($fruit_tree)
	all_trees.append($fruit_tree2)
	all_trees.append($fruit_tree3)
	all_trees.append($fruit_tree4)
	all_trees.append($fruit_tree5)
	all_trees.append($fruit_tree6)
	all_units.append($Unit)

func _process(delta):
	$The_Canvas._set_enemy_attack(int($Rain_Timer.time_left))
	$The_Canvas._set_food_points(int(food_points))	
	$Camera2D_1._set_its_raining(its_raining)
	for a_unit in all_units:
		a_unit._set_its_raining(its_raining)
	

	

func _create_unit():
	if food_points >=15:
		var new_Unit = Unit.instance()
		unit_count+=1
		new_Unit.position = Vector2(get_viewport().size.x/2,get_viewport().size.y/2)
		if(unit_count%2==0):
			new_Unit.is_girl=true
		else:
			new_Unit.is_girl=false
		tile_map.add_child(new_Unit)
		food_points-=15	
		all_units.append(new_Unit)
		
		

func _collect_food():
	for a_unit in all_units:		
		for a_tree in all_trees:
			if a_tree.is_touching && !a_tree.is_empty && a_unit.can_add:
				var the_tree = all_trees[all_trees.find(a_tree,0)]
				var the_unit = all_units[all_units.find(a_unit,0)]
				the_unit.food_points +=1
				the_tree.points-=1
				if the_tree.points <= 0:
					the_tree.is_empty = true
					food_points+=the_unit.food_points
					the_unit.food_points = 0
	

func _set_sheltered():
	for a_unit in all_units:		
		for a_tree in all_trees:
			if a_tree.is_touching:
				var the_unit = all_units[all_units.find(a_unit,0)]
				the_unit._set_sheltered(true)
			if !a_tree.is_touching:
				var the_unit = all_units[all_units.find(a_unit,0)]
				the_unit._set_sheltered(false)
				
func _get_damage():
	for a_unit in all_units:		
		for a_tree in all_trees:			
			if(its_raining && a_unit.fruit_tree_touching==false):
				var the_unit = all_units[all_units.find(a_unit,0)]
				if(the_unit.energy_points>0):
					the_unit.energy_points-=1
					the_unit.get_child(4)._decrease_energy()
				else:
					the_unit.deselect()
					the_unit.queue_free()
			elif(its_raining && a_unit.fruit_tree_touching):
				var the_unit = all_units[all_units.find(a_unit,0)]
				if(the_unit.energy_points<30):
					the_unit.energy_points+=1
					the_unit.get_child(4)._increase_energy()
	
func _on_CreateCitizen_pressed():
	_create_unit()

func _on_food_timer_timeout():
	_collect_food()
	_set_sheltered()
	_get_damage()
	

func _rain_pour():
	if(!its_raining):	
		its_raining=true
	else:
		its_raining=false
	

func _on_Rain_Timer_timeout():	
	_rain_pour()

	
	



