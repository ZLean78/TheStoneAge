extends Node2D

var unit_count = 1

var food_points = 0
#
#var dragging = false
#var selected = []
#var drag_start = Vector2.ZERO
#var select_rectangle = RectangleShape2D.new()

#onready var select_draw = $SelectDraw



onready var tile_map = $TileMap

export (PackedScene) var Unit



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
	if food_points >=30:
		var new_Unit = Unit.instance()
		unit_count+=1
		new_Unit.position = Vector2(get_viewport().size.x/2,get_viewport().size.y/2)
		if(unit_count%2==0):
			new_Unit.is_girl=true
		else:
			new_Unit.is_girl=false
		tile_map.add_child(new_Unit)
		food_points-=30	
		var label = $CanvasLayer.get_child(0).get_child(0).get_child(1)	
		label.text = "FOOD: " + str(food_points)

func _collect_food():
	var children = get_tree().root.get_child(0).get_children()
	
	for a_node in children:
		if a_node.get_class() == "KinematicBody2D" && a_node.can_add:
			
			for another_node in children:
				if ("fruit_tree" in another_node.name) && another_node.is_touching && another_node.is_empty == false:
					food_points +=1
					var label = $CanvasLayer.get_child(0).get_child(0).get_child(1)
					label.text = "FOOD: " + str(food_points)
					another_node.points-=1
					if another_node.points <= 0:
						another_node.is_empty = true
	
	



func _on_CreateCitizen_pressed():
	_create_unit()




func _on_food_timer_timeout():
	_collect_food()


func _on_fruit_tree_fruit_tree_entered():
	pass # Replace with function body.
