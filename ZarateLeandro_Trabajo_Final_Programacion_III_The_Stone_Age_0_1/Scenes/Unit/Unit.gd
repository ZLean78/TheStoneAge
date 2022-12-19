extends KinematicBody2D



export (float) var SPEED = 0.0
export (float) var MAX_HEALTH = 100.0
onready var health = MAX_HEALTH

var food_points = 0
var dragging = true

var is_flipped = false
var click_relative = 16
var dead = false

#Variables agregadas
var device_number = 0
var motion = Vector2()
var velocity = Vector2()
var touch_enabled = false
var is_girl = false


var target_position = Vector2(0,0)

var can_add = false

var can_add_multiple = false



signal health_change
signal im_dead
signal food_points_change

var selected = false

var screensize = Vector2(ProjectSettings.get("display/window/size/width"),ProjectSettings.get("display/window/size/height"))

func _ready():
	
	
	emit_signal("health_change",health)
	if !is_girl:
		$sprite.animation = "male_idle1"
	if is_girl:
		$sprite.animation = "female_idle1"
	
	


func _physics_process(_delta):	
	
	position.x = clamp(position.x,0,screensize.x)
	position.y = clamp(position.y,0,screensize.y)	
	
	var food_timer = get_tree().root.get_child(0).get_child(2)
	# Orientar al player.
	if velocity.x<0:
		if(is_flipped==false):
			scale.x = -1
			is_flipped = true
	if velocity.x>0:
		if(is_flipped==true):
			scale.x = -1
			is_flipped = false
	
				
	#animar al personaje	
	_animate()	
		
	# Cambiar los cuadros de animación del player.
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		if(!$sprite.is_playing()):
			$sprite.play()
	else:
		$sprite.stop()
		
		if(food_timer.is_stopped()):
			food_timer.start()
	
		

func _unhandled_input(event):	
	#velocity = velocity.normalized()
	if event is InputEventKey:
		if event.scancode == KEY_0:
			device_number = 0
		if event.scancode == KEY_1:
			device_number = 1
		if event.scancode == KEY_2:
			device_number = 2
		if event.scancode == KEY_3:
			device_number = 3
		if event.scancode == KEY_4:
			device_number = 4	
		###############
#		if event.scancode == KEY_I:
#			if(!is_girl):
#				is_girl = true
#			else:
#				is_girl = false
	if event is InputEventMouseButton && event.button_index == BUTTON_RIGHT:
		device_number = 2

func select():
	selected = true
	$Selected.visible = true
	
func deselect():
	selected = false
	$Selected.visible = false

func hurt(amount):
	health-=amount
	#esto podría ir en un setter
	if health <= 0:
		if !dead:
			emit_signal("im_dead")
			dead = true
			set_physics_process(false) 
		health = 0
		return
	elif health > 100:
		health = 100
	emit_signal("health_change",health)


func _on_Target_Position_body_entered(body):
	velocity = Vector2(0,0)
	touch_enabled = false
	#device_number = 0
	if !is_girl:
		$sprite.animation = "male_idle1"
	if is_girl:
		$sprite.animation = "female_idle1"


func _on_Target_Position1_body_entered(body):
	velocity = Vector2(0,0)
	if !is_girl:
		$sprite.animation = "male_idle1"
	if is_girl:
		$sprite.animation = "female_idle1"
		

		
func _animate():
	if(!is_girl):
		if velocity == Vector2(0,0):
			if $sprite.animation == "male_backwalk":
				$sprite.animation = "male_idle2"
			elif $sprite.animation == "male_frontwalk":
				$sprite.animation = "male_idle1"
			elif $sprite.animation == "male_sidewalk":
				$sprite.animation = "male_idle3"
#			else:
#				$sprite.animation = "male_idle1"
		else:
			if velocity.y < 0:
				if abs(velocity.y) > abs(velocity.x):
					$sprite.animation = "male_backwalk"
				else:
					$sprite.animation = "male_sidewalk"
			elif velocity.y > 0:
				if abs(velocity.y) > abs(velocity.x):
					$sprite.animation = "male_frontwalk"
				else:
					$sprite.animation = "male_sidewalk"
			elif velocity.x < 0:
				if abs(velocity.x) > abs(velocity.y):
					$sprite.animation = "male_sidewalk"
				else:
					$sprite.animation = "male_backwalk"
			elif velocity.x > 0:
				if abs(velocity.x) > abs(velocity.y):
					$sprite.animation = "male_sidewalk"
				else:
					$sprite.animation = "male_frontwalk"
#			else:
#				$sprite.animation = "male_idle1"			
	else:
		if velocity == Vector2(0,0):
			if $sprite.animation == "female_backwalk":
				$sprite.animation = "female_idle2"
			elif $sprite.animation == "female_frontwalk":
				$sprite.animation = "female_idle1"
			elif $sprite.animation == "female_sidewalk":
				$sprite.animation = "female_idle3"		
#			else:
#				$sprite.animation = "female_idle1"
		else:
			if velocity.y < 0:
				if abs(velocity.y) > abs(velocity.x):
					$sprite.animation = "female_backwalk"
				else:
					$sprite.animation = "female_sidewalk"
			elif velocity.y > 0:
				if abs(velocity.y) > abs(velocity.x):
					$sprite.animation = "female_frontwalk"
				else:
					$sprite.animation = "female_sidewalk"
			elif velocity.x < 0:
				if abs(velocity.x) > abs(velocity.y):
					$sprite.animation = "female_sidewalk"
				else:
					$sprite.animation = "female_backwalk"
			elif velocity.x > 0:
				if abs(velocity.x) > abs(velocity.y):
					$sprite.animation = "female_sidewalk"
				else:
					$sprite.animation = "female_frontwalk"
#			else:
#				$sprite.animation = "female_idle1"	
		
	if device_number == 2:
		#if position.distance_to(get_node("Mouse_Device/Target_Position1").position) < 5:
		target_position = get_viewport().get_mouse_position()		
#		if position.distance_to(target_position) < 5:
#			if(!is_girl):
#				$sprite.animation = "male_idle1"
#			else:
#				$sprite.animation = "female_idle1"
	
	if device_number == 4:
		#if position.distance_to(get_node("Single_Tap_Device/Target_Position").position) < 5:
		target_position = get_viewport().get_mouse_position()
		if position.distance_to(target_position) < 5:
			if(!is_girl):
				$sprite.animation = "male_idle1"
			else:
				$sprite.animation = "female_idle1"
	



func _on_fruit_tree_fruit_tree_entered():	
	can_add = true	
	#get_tree().root.get_child(0)._collect_food()
	
	
func _on_fruit_tree_fruit_tree_exited():
	can_add = false
	



func _on_player_mouse_entered():
	if device_number == 2:
		selected = true
