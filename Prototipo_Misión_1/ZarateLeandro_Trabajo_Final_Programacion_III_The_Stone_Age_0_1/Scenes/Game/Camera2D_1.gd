extends Camera2D

var its_raining = false

const MAX_CAMERA_DISTANCE = 50.0
const MAX_CAMERA_PERCENT = 0.1
const CAMERA_SPEED = 0.01

var dragging = false
var selected = []
var drag_start = Vector2.ZERO
var select_rectangle = RectangleShape2D.new()

onready var select_draw = get_tree().root.get_child(0).get_child(3)

#export (NodePath) onready var camera = get_node(camera)

func _unhandled_input(event):
	
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		if event.pressed:	
			for unit in selected:
				if(!unit.collider.is_erased):					
					unit.collider.deselect()	
				else:
					unit.collider.visible=false
					unit.collider.queue_free()
			selected = []
			dragging = true
			drag_start = get_global_mouse_position()
		elif dragging:
			dragging = false
			select_draw.update_status(drag_start,get_global_mouse_position(),dragging)
			var drag_end = get_global_mouse_position()			
			select_rectangle.extents = (drag_end-drag_start)/2
			var space = get_world_2d().direct_space_state
			var query = Physics2DShapeQueryParameters.new()
			query.set_shape(select_rectangle)
			query.transform = Transform2D(0,(drag_end+drag_start)/2)
			selected = space.intersect_shape(query)
			for unit in selected:
				unit.collider.select()

	if dragging:
		if event is InputEventMouseMotion:
			#var drag_end=event.position
			select_draw.update_status(drag_start,get_global_mouse_position(),dragging)
	
	if event is InputEventKey && event.scancode == KEY_C:
		var the_unit = get_tree().root.get_child(0).get_child(1)	
		the_unit.queue_free()


func _process(_delta):

	var the_children = get_tree().root.get_child(0).get_children()
	var unit
	
	var viewport = get_viewport()
	var viewport_center = viewport.size / 2.0
	var direction = viewport.get_mouse_position() - viewport_center
	var percent = (direction / viewport.size * 2.0).length()
	
	var camera_position = Vector2()

	for a_node in the_children:
		if "Unit" in a_node.name && a_node.selected:
			unit = a_node			
	
			if(unit.selected):				
				if percent < MAX_CAMERA_PERCENT:
					camera_position = unit.position + direction.normalized() * MAX_CAMERA_DISTANCE * (percent / MAX_CAMERA_PERCENT)
				else:
					camera_position = unit.position  + direction.normalized() * MAX_CAMERA_DISTANCE
		else:			
			if percent < MAX_CAMERA_PERCENT:
				camera_position = get_global_mouse_position()  + direction.normalized() * MAX_CAMERA_DISTANCE * (percent / MAX_CAMERA_PERCENT)
			else:
				camera_position = get_global_mouse_position()  + direction.normalized() * MAX_CAMERA_DISTANCE

	global_position = lerp(global_position, camera_position, CAMERA_SPEED)
	
	
func _set_its_raining(var _its_raining):
	its_raining = _its_raining
	
	if(its_raining):
		$AnimatedSprite.visible = true
		if(!$AnimatedSprite.playing):
			$AnimatedSprite.play("default")
	else:
		$AnimatedSprite.visible = false
		$AnimatedSprite.stop()
