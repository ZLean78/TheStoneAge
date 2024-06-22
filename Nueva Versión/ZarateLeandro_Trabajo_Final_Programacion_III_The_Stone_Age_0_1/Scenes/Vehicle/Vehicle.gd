extends KinematicBody2D


var direction=Vector2()

#Variables origen y destino de navegación.
var firstPoint = Vector2.ZERO
var secondPoint = Vector2.ZERO
var index = 0

var target_position = Vector2.ZERO
var velocity = Vector2()
var selected=false
var to_delta=0.0
var is_flipped=false

#Salud de la unidad.
export (float) var health = 100


onready var nav2d
onready var sprite
#onready var bar=$ProgressBar
onready var foot=$Selected
export (float) var SPEED = 100.0
var tree
var path=PoolVector2Array()

#Señales que informan si la unidad ha sido seleccionada o desseleccionada.
signal was_selected
signal was_deselected

#Para saber si la unidad ha sido eliminada.
var is_deleted=false
var distance=Vector2.ZERO
func _ready():
	health=100
	#bar=$ProgressBar
	foot=$Selected
	SPEED=100.0
	#bar.value=health
	tree=Globals.current_scene
	sprite=$scalable/Sprite
	#target_position=Vector2.ZERO
	#velocity=Vector2.ZERO
	selected=false
	to_delta=0.0
	nav2d=tree.get_node("nav")
	foot=$Selected
	#bar=$ProgressBar
	tree=Globals.current_scene
	nav2d=tree.get_node("nav")
	#connect("was_selected",tree,"_select_unit")
	#connect("was_deselected",tree,"_deselect_unit")
	

func _physics_process(delta):
	to_delta=delta
		
	if selected:
		#bar.visible = true
		foot.visible = true
	else:
		#bar.visible = false
		foot.visible = false
	
#	if target_position!=Vector2.ZERO:
#		if position.distance_to(target_position) > 7:
#			_move_along_path(SPEED*delta)
#			#_move()
#	else:
#		target_position=position
#		velocity=Vector2.ZERO
	
		
	if target_position!=Vector2.ZERO:
		if position.distance_to(target_position) > 10:
			#_move_to_target(target_position)
			_move_along_path(SPEED*delta)
		else:
			velocity=Vector2.ZERO
	
	# Orientar al player.
	if velocity.x<0:
		if(is_flipped==false):			
			$scalable.scale.x = 1
			is_flipped = true
	if velocity.x>0:
		if(is_flipped==true):			
			$scalable.scale.x = -1
			is_flipped = false
	
				
	#animar al personaje	
	$Animation._animate(sprite,velocity,target_position)	
		
	#Cambiar los cuadros de animación del player.
	if position.distance_to(target_position) <= 10:
		sprite.stop()
	else:
		sprite.play()
	
		

		

		
func _move_along_path(distance):	
	var last_point=position
	direction=secondPoint-last_point
	velocity=(direction).normalized()
	while path.size():
		var distance_between_points = last_point.distance_to(path[0])
		if distance_between_points>7:
			last_point=lerp(last_point,path[0],distance/distance_between_points)
			position=last_point
			return
		
		distance-=distance_between_points
		last_point=path[0]
		path.remove(0)
		position=last_point
		set_process(false)

	
	

func _move():
	firstPoint = global_position
	secondPoint = target_position		
	var arrPath: PoolVector2Array = nav2d.get_simple_path(firstPoint,secondPoint,true)
	firstPoint = arrPath[0]
	path = arrPath
	index = 0

func _draw():
	draw_line(firstPoint,target_position,Color.blue)	

#func _move():
#	target_position=get_global_mouse_position()
#	var distance=target_position-position
#	velocity=(SPEED*distance).normalized()
#	move_and_collide(velocity)




func _set_selected(value):
	if selected!=value:
		selected=value

		#bar.visible = value
		foot.visible = value
		if selected:
			emit_signal("was_selected")
			
		else:
			emit_signal("was_deselected")
			

		
		
func _on_Unit_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():			
			if event.button_index == BUTTON_LEFT:
				_set_selected(not selected)
				tree._select_last()







func _on_Vehicle_was_deselected():
	tree._deselect_unit(self)
	print("was deselected emitted")


func _on_Vehicle_was_selected():
	tree._select_unit(self)
	print("was selected emitted")
