extends Camera2D

#Camera Controls
@export var SPEED = 20.0
@export var ZOOM_SPEED = 20.0
@export var ZOOM_MARGIN = 0.1
@export var ZOOM_MIN = 0.5
@export var ZOOM_MAX = 3.0

@onready var units_node = get_node("../Units")
@onready var viewport = get_tree().get_root().get_node("MainScene/SubViewportContainer")

var zoom_factor = 1.0
var zooming = false
var zoomPos = Vector2()

var mousePos = Vector2()

var mousePosGlobal = Vector2()
var start = Vector2()
var startV = Vector2()
var end = Vector2()
var endV = Vector2()
var isDragging = false
signal area_selected
signal start_move_selection 
@onready var box=get_node("../UI/Panel")
@warning_ignore("unused_parameter","unused_parameter")

func _ready():
	connect("area_selected",Callable(get_parent(), "_on_area_selected"))
	

func _process(delta):
	
	var InputX = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	var InputY = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	position.x = lerp(position.x,position.x +InputX*SPEED * zoom.x, SPEED*delta)
	position.y = lerp(position.y,position.y +InputY*SPEED * zoom.y, SPEED*delta)
	
	position.x = clamp(position.x,0,get_viewport().size.x/zoom.x)
	position.y = clamp(position.y,0,get_viewport().size.y/zoom.y)
	
	zoom.x = lerp(zoom.x,zoom.x*zoom_factor,ZOOM_SPEED*delta)
	zoom.y = lerp(zoom.y,zoom.y*zoom_factor,ZOOM_SPEED*delta)
	
	zoom.x = clamp(zoom.x,ZOOM_MIN,ZOOM_MAX)
	zoom.y = clamp(zoom.y,ZOOM_MIN,ZOOM_MAX)
	
	if not zooming:
		zoom_factor=1.0
			
	if Input.is_action_just_pressed("LeftClick"):
		start = mousePosGlobal
		startV = mousePos
		isDragging = true
		
	if isDragging:
		end = mousePosGlobal
		endV = mousePos
		draw_area()
		
	if Input.is_action_just_released("LeftClick"):
		if startV.distance_to(mousePos) > 20:
			end = mousePosGlobal
			endV = mousePos
			isDragging = false	
			draw_area(false)
			emit_signal("area_selected",self)			
		else:
			end = start
			draw_area(false)
			isDragging = false
	
	if Input.is_action_just_pressed("RightClick"):
		for unit in units_node.get_children():
			if unit.selected:
				position = unit.position - Vector2(viewport.size.x/2,viewport.size.y/2)
	
	if Input.is_action_just_pressed("mouse_wheel_up"):
		zoom+=Vector2(1,1)
		
		
	if Input.is_action_just_pressed("mouse_wheel_down"):
		zoom-=Vector2(1,1)
		

func _input(event):
	if abs(zoomPos.x - get_global_mouse_position().x) > ZOOM_MARGIN:
		zoom_factor = 1.0
	if abs(zoomPos.y - get_global_mouse_position().y) > ZOOM_MARGIN:
		zoom_factor = 1.0
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			zooming = true
			if event.is_action("mouse_wheel_down"):
				zoom_factor-=0.01*ZOOM_SPEED
				zoomPos = get_global_mouse_position()
			if event.is_action("mouse_wheel_up"):
				zoom_factor+=0.01*ZOOM_SPEED
				zoomPos = get_global_mouse_position()
		else:
			zooming = false		
		
	if event is InputEventMouse:
		mousePos = event.position
		mousePosGlobal = get_global_mouse_position()
		
func draw_area(s=true):
	box.size = Vector2(abs(startV.x-endV.x),abs(startV.y-endV.y))
	var pos = Vector2()
	pos.x = min(startV.x,endV.x)
	pos.y = min(startV.y,endV.y)
	box.position = pos
	box.size *= int(s)
	
	

