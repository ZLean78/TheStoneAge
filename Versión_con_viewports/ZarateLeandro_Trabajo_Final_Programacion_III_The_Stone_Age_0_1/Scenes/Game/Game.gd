extends Node2D

var unit_count = 1
var food_points = 0
var its_raining = false

onready var game_screen = $GameScreen
onready var panel = $Panel
onready var food_timer = game_screen.get_node("Viewport/food_timer")
onready var the_canvas = $Panel.get_node("Viewport/The_Canvas")
onready var camera2d_1 = $GameScreen.get_node("Viewport/Camera2D_1")
onready var rain_timer = $GameScreen.get_node("Viewport/Rain_Timer")
onready var tile_map
var cave
export (PackedScene) var Unit

var all_units=[]
var all_trees=[]
var sheltered=[]

var dragging = false
var selected = []
var drag_start = Vector2.ZERO
var select_rectangle = RectangleShape2D.new()


onready var select_draw = game_screen.find_node("Viewport/SelectDraw")

var is_flipped = false

var screensize = Vector2(ProjectSettings.get("display/window/size/width"),ProjectSettings.get("display/window/size/height"))

func _ready():
	tile_map=$GameScreen.get_node("Viewport/TileMap")
	cave=tile_map.get_node("Cave")
	all_trees.append($GameScreen.get_node("Viewport/fruit_tree"))
	all_trees.append($GameScreen.get_node("Viewport/fruit_tree2"))
	all_trees.append($GameScreen.get_node("Viewport/fruit_tree3"))
	all_trees.append($GameScreen.get_node("Viewport/fruit_tree4"))
	all_trees.append($GameScreen.get_node("Viewport/fruit_tree5"))
	all_trees.append($GameScreen.get_node("Viewport/fruit_tree6"))
	all_units.append($GameScreen.get_node("Viewport/Unit"))
	
	

#export (NodePath) onready var camera = get_node(camera)

#func _unhandled_input(event):
#
#	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
#		if event.pressed:	
#			for unit in selected:
#				if(!unit.collider.is_erased):					
#					unit.collider.deselect()	
#				else:
#					unit.collider.visible=false
#					unit.collider.queue_free()
#			selected = []
#			dragging = true
#			drag_start = camera2d_1.get_global_mouse_position()
#		elif dragging:
#			dragging = false
#			select_draw.update_status(drag_start,camera2d_1.get_global_mouse_position(),dragging)
#			var drag_end = camera2d_1.get_global_mouse_position()		
#			select_rectangle.extents = (drag_end-drag_start)/2
#			var space = get_world_2d().direct_space_state
#			var query = Physics2DShapeQueryParameters.new()
#			query.set_shape(select_rectangle)
#			query.transform = Transform2D(0,(drag_end+drag_start)/2)
#			selected = space.intersect_shape(query)
#			for unit in selected:
#				unit.collider.select()
#
#	if dragging:
#		if event is InputEventMouseMotion:
#			#var drag_end=event.position
#			select_draw.update_status(drag_start,camera2d_1.get_global_mouse_position(),dragging)
#
#	if event is InputEventKey && event.scancode == KEY_C:
#		var the_unit = get_tree().root.get_child(0).get_child(1)	
#		the_unit.queue_free()
		
	
		

func _process(_delta):
	the_canvas._set_enemy_attack(int(rain_timer.time_left))
	the_canvas._set_food_points(int(food_points))	
	camera2d_1._set_its_raining(its_raining)
	for a_unit in all_units:
		
		a_unit.position.x = clamp(a_unit.position.x,0,screensize.x)
		a_unit.position.y = clamp(a_unit.position.y,0,screensize.y)
	
	
		a_unit._set_its_raining(its_raining)
	
#		
		
#		
	

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
			if a_tree.is_touching && !a_tree.is_empty && a_unit.fruit_tree_touching:
				var the_tree = all_trees[all_trees.find(a_tree,0)]
				var the_unit = all_units[all_units.find(a_unit,0)]
				if((abs(the_unit.position.x-the_tree.position.x)<5)&&
				(abs(the_unit.position.y-the_tree.position.y)<5)):					
					food_points +=1
					the_tree.points-=1
					if the_tree.points <= 0:
						the_tree.is_empty = true
						
				
func _get_damage():
	for a_unit in all_units:		
		for a_tree in all_trees:			
			if(its_raining && !a_unit.fruit_tree_touching && !all_units.size()==0):
				var the_unit = all_units[all_units.find(a_unit,0)]
				if(the_unit.energy_points>0):
					the_unit.energy_points-=1
					the_unit.get_child(4)._decrease_energy()
				else:
					the_unit.deselect()					
					all_units.erase(the_unit)	
					the_unit._set_erased(true)
#					else:
#						the_unit.visible = false
#						if(all_units.size()<=1 && food_points<15):
#							$The_Canvas._set_phrase("Has sido derrotado.")				
					
			elif(its_raining && a_unit.fruit_tree_touching):
				var the_unit = all_units[all_units.find(a_unit,0)]
				if(the_unit.energy_points<30):
					the_unit.energy_points+=1
					the_unit.get_child(4)._increase_energy()
	if(all_units.size()==0 && food_points<15):
		the_canvas._set_phrase("Has sido derrotado.")	
	if(cave.sheltered_units>=12):
		the_canvas._set_phrase("Has ganado.")	
	
func _on_CreateCitizen_pressed():
	_create_unit()

func _on_food_timer_timeout():
	if(all_units.size()>-1):
		_collect_food()
		_get_damage()
	

func _rain_pour():
	if(!its_raining):	
		its_raining=true
	else:
		its_raining=false
	

func _on_Rain_Timer_timeout():	
	_rain_pour()

	
	



