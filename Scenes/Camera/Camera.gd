######################################
####Código nuevo
#####################################

extends Camera2D

export var panSpeed=30.0

export var speed=10.0

export var zoomSpeed=10.0

export var zoomMargin=0.1

export var zoomMin=0.25

export var zoomMax=1.0

export var marginX=50.0

export var marginY=50.0

var mousePos=Vector2()

var mousePosGlobal=Vector2()

var start=Vector2()

var startV=Vector2()

var end=Vector2()

var endV=Vector2()

var zoomFactor=1.0

var zooming=false

var is_dragging=false

#var move_to_point=Vector2()

onready var tree=Globals.current_scene

#onready var rectd = tree.find_node("draw_rect")

onready var select_draw



var its_raining=false

var camera_lock=false

signal area_selected
#signal start_move_selection

func _ready():
	
	connect("area_selected",get_parent(),"_area_selected",[self])
	#connect("start_move_selection",get_parent(),"start_move_selection",[self])
	#select_draw = Globals.current_scene.select_draw
	#pass

func _process(delta):
	
	
	
	#smooth movement
	var inpx = (int(Input.is_action_pressed("ui_right"))
				 - int(Input.is_action_pressed("ui_left")))
	var inpy = (int(Input.is_action_pressed("ui_down"))
				 - int(Input.is_action_pressed("ui_up")))
	position.x=lerp(position.x,position.x+inpx*panSpeed*zoom.x,panSpeed*delta)
	position.y=lerp(position.y,position.y+inpy*panSpeed*zoom.y,panSpeed*delta)
	

	#movimiento de cámara con mouse
	if Input.is_action_pressed("mouse_wheel_pressed"):
		camera_lock=!camera_lock
	
	if !camera_lock:
		#chequear posición del mouse
		if mousePos.x < marginX:
			position.x=lerp(position.x,position.x-abs(mousePos.x-marginX)/marginX*panSpeed*zoom.x,panSpeed*delta)
		elif mousePos.x > ProjectSettings.get("display/window/size/width") - marginX:
			position.x=lerp(position.x,position.x+abs(mousePos.x-ProjectSettings.get("display/window/size/width")+marginX)/marginX*panSpeed*zoom.x,panSpeed*delta)
		if mousePos.y < marginY:
			position.y=lerp(position.y,position.y-abs(mousePos.y-marginY)/marginY*panSpeed*zoom.y,panSpeed*delta)
		elif mousePos.y > ProjectSettings.get("display/window/size/height") - marginY:
			position.y=lerp(position.y,position.y+abs(mousePos.y-ProjectSettings.get("display/window/size/height")+marginY)/marginY*panSpeed*zoom.y,panSpeed*delta)

	

	if Input.is_action_just_pressed("ui_left_mouse_button"):
		if get_parent().arrow_mode:
			start = mousePosGlobal
			startV = mousePos
			is_dragging = true	
	if is_dragging:
		if startV.distance_to(mousePos)>20:
			end = mousePosGlobal
			endV = mousePos
			tree.select_draw.update_status(start,mousePosGlobal+Vector2(6,12),is_dragging)
			#var drag_end = mousePos
	if Input.is_action_just_released("ui_left_mouse_button"):
		if startV.distance_to(mousePos)>20:
			end = mousePosGlobal
			endV = mousePos
			is_dragging = false
			tree.select_draw.update_status(start,mousePosGlobal,is_dragging)				
			emit_signal("area_selected")
		else:
			end = start
			is_dragging = false

	#zoom in
	zoom.x = lerp(zoom.x,zoom.x*zoomFactor,zoomSpeed*delta)
	zoom.y = lerp(zoom.y,zoom.y*zoomFactor,zoomSpeed*delta)

	zoom.x=clamp(zoom.x,zoomMin,zoomMax)
	zoom.y=clamp(zoom.y,zoomMin,zoomMax)
	

	position.x=clamp(position.x,-1650,1650)
	position.y=clamp(position.y,-960,960)


	if not zooming:
		zoomFactor = 1.0





func _input(event):

	if (event is InputEventMouseButton):
		if(event.is_pressed()):
			zooming = true
			if(event.button_index==BUTTON_WHEEL_UP):
				zoomFactor -= 0.01 *zoomSpeed				
			if(event.button_index==BUTTON_WHEEL_DOWN):
				zoomFactor += 0.01 *zoomSpeed				
		else:
			zooming = false


	if event is InputEventMouse:
		mousePos = event.position
		mousePosGlobal = get_global_mouse_position()

	
					
	
func _set_its_raining(var _its_raining):
	its_raining = _its_raining

	if(its_raining):
		$AnimatedSprite.visible = true
		if(!$AnimatedSprite.playing):
			$AnimatedSprite.play("default")
	else:
		$AnimatedSprite.visible = false
		$AnimatedSprite.stop()

