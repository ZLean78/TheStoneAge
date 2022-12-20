extends Node2D

var unit_count = 1
var food_points = 0
var its_raining = false
#
#var dragging = false
#var selected = []
#var drag_start = Vector2.ZERO
#var select_rectangle = RectangleShape2D.new()

#onready var select_draw = $SelectDraw

onready var food_timer = $food_timer
onready var tile_map = $TileMap
export (PackedScene) var Unit

func _process(delta):
	$The_Canvas._set_enemy_attack(int($Rain_Timer.time_left))
	$The_Canvas._set_food_points(int(food_points))	
	$Camera2D_1._set_its_raining(its_raining)
	
	
	
#func _unhandled_input(event):	
#	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
#		if event.is_pressed():
#			for unit in selected:
#				unit.collider.deselect()
#
#			selected = []
#			dragging = true
#			drag_start = event.position
#		elif dragging:
#			dragging = false
#			select_draw.update_status(drag_start,event.position,dragging)
#			var drag_end = event.position
#			select_rectangle.extents = (drag_end - drag_start) / 2
#			var space = get_world_2d().direct_space_state
#			#var space = $Camera2D_1.
#			var query = Physics2DShapeQueryParameters.new()
#			query.set_shape(select_rectangle)
#			query.transform = Transform2D(0,(drag_end + drag_start) / 2)
#			selected = space.intersect_shape(query)
#			for unit in selected:
#				unit.collider.select()
#
#	if dragging:
#		if event is InputEventMouseMotion:
#			select_draw.update_status(drag_start,event.position,dragging)
#func _ready():
	#get_viewport().set_size_override(true, Vector2(1024,608)) # Custom size for 2D.
	#get_viewport().set_size_override_stretch(true) # Enable stretch for custom size.

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
		
		

func _collect_food():
	var all_units=[]
	var all_trees=[]
	var children = get_tree().root.get_child(0).get_children()
	
	for a_node in children:
		if a_node.get_class() == "KinematicBody2D":
			if(a_node.can_add):
				all_units.append(a_node)
				print(a_node)
				for another_node in children:
					if "fruit_tree" in another_node.name:
						all_trees.append(another_node)
						print(another_node)
						for a_unit in all_units:
							for a_tree in all_trees:								
								if a_tree.is_touching && !a_tree.is_empty && a_unit.can_add:
									var the_tree = a_tree
									var the_unit = a_unit
									the_unit.food_points +=1
									the_tree.points-=1																		
									if the_tree.points <= 0:
										the_tree.is_empty = true
										food_points+=the_unit.food_points
										the_unit.food_points = 0
										
										
						
		
func _to_get_damage():
	var all_units=[]
	var all_trees=[]
	var children = get_tree().root.get_child(0).get_children()
	
	
	for a_node in children:
		if a_node.get_class() == "KinematicBody2D":
			if its_raining:
				a_node.its_raining = true
											

#func _get_damage():
#	var all_units=[]
#	var sheltered_units=[]
#	var unsheltered_units=[]
#	var children = get_tree().root.get_child(0).get_children()
#
#	for a_node in children:
#		if a_node.get_class() == "KinematicBody2D":
#			if(its_raining && !a_node.is_sheltered):
#				unsheltered_units.append(a_node)
#				for u_node in unsheltered_units:
#					if(u_node.energy_points>0):
#						u_node.energy_points-=1
#						u_node.get_child(4)._decrease_energy()
#					else:
#						u_node.queue_free()
		
						
					
			

						
	
func _on_CreateCitizen_pressed():
	_create_unit()

func _on_food_timer_timeout():
	_collect_food()
	_to_get_damage()

func _rain_pour():
	if(!its_raining):	
		its_raining=true
	else:
		its_raining=false
	
	


	


func _on_Rain_Timer_timeout():	
	_rain_pour()

	#$Rain_Timer.start()
	
