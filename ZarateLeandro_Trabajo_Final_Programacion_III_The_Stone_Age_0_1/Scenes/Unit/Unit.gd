extends KinematicBody2D



export (float) var SPEED = 0.0
export (float) var MAX_HEALTH = 100.0
onready var game_screen = get_tree().root.get_child(0).get_node("GameScreen")
onready var food_timer = game_screen.get_node("Viewport/food_timer")
onready var health = MAX_HEALTH

var food_points = 0
var energy_points = 100
var dragging = true

var is_flipped = false
var click_relative = 16
var dead = false


#Variables agregadas
var device_number = 0
var motion = Vector2()
var velocity = Vector2()
var touch_enabled = false
var is_sheltered = false
var is_girl = false
var is_dressed = false
var has_bag = false
var is_erased = false



var target_position = Vector2(0,0)

var can_add = false
var can_add_leaves = false

var can_add_multiple = false

var its_raining = false

signal health_change
signal im_dead
#signal food_points_change

var selected = false

var screensize = Vector2(ProjectSettings.get("display/window/size/width"),ProjectSettings.get("display/window/size/height"))

var fruit_tree_touching = false
var plant_touching = false

onready var all_timer = $All_Timer

func _ready():	
	emit_signal("health_change",health)
	if(!is_dressed):
		if !is_girl:
			$sprite.animation = "male_idle1"
		if is_girl:
			$sprite.animation = "female_idle1"
	else:
		if !is_girl:
			$sprite.animation = "male_idle1_d"
		if is_girl:
			$sprite.animation = "female_idle1_d"

func _physics_process(_delta):	
	
	position.x = clamp(position.x,0,screensize.x)
	position.y = clamp(position.y,0,screensize.y)	
	
	
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
		
	#revisar si está tocando un árbol
	_check_fruit_tree_touching()
	_check_plant_touching()
		
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


func _on_Target_Position_body_entered(_body):
	velocity = Vector2(0,0)
	touch_enabled = false
	#device_number = 0
	if !is_girl:
		$sprite.animation = "male_idle1"
	if is_girl:
		$sprite.animation = "female_idle1"


func _on_Target_Position1_body_entered(_body):
	velocity = Vector2(0,0)
	if !is_girl:
		$sprite.animation = "male_idle1"
	if is_girl:
		$sprite.animation = "female_idle1"
		

		
func _animate():
	if(!is_dressed):
		if(!is_girl):
			if velocity == Vector2(0,0):
				if $sprite.animation == "male_backwalk":
					$sprite.animation = "male_idle2"
					if($bag_sprite.visible):
						$bag_sprite.animation = "bag_2"
				elif $sprite.animation == "male_frontwalk":
					$sprite.animation = "male_idle1"
					if($bag_sprite.visible):
						$bag_sprite.animation = "bag_1"
				elif $sprite.animation == "male_sidewalk":
					$sprite.animation = "male_idle3"
					if($bag_sprite.visible):
						$bag_sprite.animation = "bag_3"
#				else:
#					$sprite.animation = "male_idle1"
			else:
				if velocity.y < 0:
					if abs(velocity.y) > abs(velocity.x):
						$sprite.animation = "male_backwalk"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_2"
					else:
						$sprite.animation = "male_sidewalk"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_3"
				elif velocity.y > 0:
					if abs(velocity.y) > abs(velocity.x):
						$sprite.animation = "male_frontwalk"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_1"
					else:
						$sprite.animation = "male_sidewalk"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_3"
				elif velocity.x < 0:
					if abs(velocity.x) > abs(velocity.y):
						$sprite.animation = "male_sidewalk"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_3"
					else:
						$sprite.animation = "male_backwalk"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_2"
				elif velocity.x > 0:
					if abs(velocity.x) > abs(velocity.y):
						$sprite.animation = "male_sidewalk"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_3"
					else:
						$sprite.animation = "male_frontwalk"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_1"
#				else:
#				$sprite.animation = "male_idle1"			
		else:
			if velocity == Vector2(0,0):
				if $sprite.animation == "female_backwalk":
					$sprite.animation = "female_idle2"
					if($bag_sprite.visible):
						$bag_sprite.animation = "bag_2"
				elif $sprite.animation == "female_frontwalk":
					$sprite.animation = "female_idle1"
					if($bag_sprite.visible):
						$bag_sprite.animation = "bag_1"
				elif $sprite.animation == "female_sidewalk":
					$sprite.animation = "female_idle3"	
					if($bag_sprite.visible):
						$bag_sprite.animation = "bag_3"	
#				else:
#					$sprite.animation = "female_idle1"
			else:
				if velocity.y < 0:
					if abs(velocity.y) > abs(velocity.x):
						$sprite.animation = "female_backwalk"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_2"
					else:
						$sprite.animation = "female_sidewalk"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_3"
				elif velocity.y > 0:
					if abs(velocity.y) > abs(velocity.x):
						$sprite.animation = "female_frontwalk"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_1"
					else:
						$sprite.animation = "female_sidewalk"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_3"
				elif velocity.x < 0:
					if abs(velocity.x) > abs(velocity.y):
						$sprite.animation = "female_sidewalk"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_3"
					else:
						$sprite.animation = "female_backwalk"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_2"
				elif velocity.x > 0:
					if abs(velocity.x) > abs(velocity.y):
						$sprite.animation = "female_sidewalk"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_3"
					else:
						$sprite.animation = "female_frontwalk"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_1"
#				else:
#					$sprite.animation = "female_idle1"	
	else:
		if(!is_girl):
			if velocity == Vector2(0,0):
				if $sprite.animation == "male_backwalk_d":
					$sprite.animation = "male_idle2_d"
					if($bag_sprite.visible):
						$bag_sprite.animation = "bag_2"
				elif $sprite.animation == "male_frontwalk_d":
					$sprite.animation = "male_idle1_d"
					if($bag_sprite.visible):
						$bag_sprite.animation = "bag_1"
				elif $sprite.animation == "male_sidewalk_d":
					$sprite.animation = "male_idle3_d"
					if($bag_sprite.visible):
						$bag_sprite.animation = "bag_3"
#				else:
#					$sprite.animation = "male_idle1"
			else:
				if velocity.y < 0:
					if abs(velocity.y) > abs(velocity.x):
						$sprite.animation = "male_backwalk_d"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_2"
					else:
						$sprite.animation = "male_sidewalk_d"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_3"
				elif velocity.y > 0:
					if abs(velocity.y) > abs(velocity.x):
						$sprite.animation = "male_frontwalk_d"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_1"
					else:
						$sprite.animation = "male_sidewalk_d"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_3"
				elif velocity.x < 0:
					if abs(velocity.x) > abs(velocity.y):
						$sprite.animation = "male_sidewalk_d"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_3"
					else:
						$sprite.animation = "male_backwalk_d"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_2"
				elif velocity.x > 0:
					if abs(velocity.x) > abs(velocity.y):
						$sprite.animation = "male_sidewalk_d"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_3"
					else:
						$sprite.animation = "male_frontwalk_d"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_1"
#				else:
#				$sprite.animation = "male_idle1"			
		else:
			if velocity == Vector2(0,0):
				if $sprite.animation == "female_backwalk_d":
					$sprite.animation = "female_idle2_d"
					if($bag_sprite.visible):
						$bag_sprite.animation = "bag_2"
				elif $sprite.animation == "female_frontwalk_d":
					$sprite.animation = "female_idle1_d"
					if($bag_sprite.visible):
						$bag_sprite.animation = "bag_1"
				elif $sprite.animation == "female_sidewalk_d":
					$sprite.animation = "female_idle3_d"	
					if($bag_sprite.visible):
						$bag_sprite.animation = "bag_3"	
#				else:
#					$sprite.animation = "female_idle1"
			else:
				if velocity.y < 0:
					if abs(velocity.y) > abs(velocity.x):
						$sprite.animation = "female_backwalk_d"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_2"
					else:
						$sprite.animation = "female_sidewalk_d"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_3"
				elif velocity.y > 0:
					if abs(velocity.y) > abs(velocity.x):
						$sprite.animation = "female_frontwalk_d"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_1"
					else:
						$sprite.animation = "female_sidewalk_d"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_3"
				elif velocity.x < 0:
					if abs(velocity.x) > abs(velocity.y):
						$sprite.animation = "female_sidewalk_d"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_3"
					else:
						$sprite.animation = "female_backwalk_d"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_2"
				elif velocity.x > 0:
					if abs(velocity.x) > abs(velocity.y):
						$sprite.animation = "female_sidewalk_d"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_3"
					else:
						$sprite.animation = "female_frontwalk_d"
						if($bag_sprite.visible):
							$bag_sprite.animation = "bag_1"
#				else:
#					$sprite.animation = "female_idle1"	
		
			
	if device_number == 2:
		target_position = get_global_mouse_position()		
		
	
	if device_number == 4:
		#if position.distance_to(get_node("Single_Tap_Device/Target_Position").position) < 5:
		target_position = get_global_mouse_position()
		if position.distance_to(target_position) < 5:
			if(!is_dressed):
				if(!is_girl):
					$sprite.animation = "male_idle1"
				else:
					$sprite.animation = "female_idle1"
			else:
				if(!is_girl):
					$sprite.animation = "male_idle1_d"
				else:
					$sprite.animation = "female_idle1_d"
			if($bag_sprite.visible):
				$bag_sprite.animation = "bag_1"
	


func _on_fruit_tree_fruit_tree_entered():	
	can_add = true	
	is_sheltered = true
	
	
func _on_fruit_tree_fruit_tree_exited():
	can_add = false
	is_sheltered = false
	
func _on_plant_plant_entered():
	can_add_leaves = true;
	
func _on_plant_plant_exited():
	can_add_leaves = false;


func _on_player_mouse_entered():
	if device_number == 2:
		selected = true

	
func _set_fruit_tree_touching(var _fruit_tree):
	fruit_tree_touching=_fruit_tree
	
func _set_plant_touching(var _plant):
	plant_touching=_plant
	

func _set_its_raining(var _its_raining):
	its_raining = _its_raining
	
func _set_erased(var _is_erased):
	is_erased=_is_erased
	
func _check_fruit_tree_touching():
	_set_fruit_tree_touching(fruit_tree_touching)
	
func _check_plant_touching():
	_set_plant_touching(plant_touching)
#	
func _on_All_Timer_timeout():
	pass
	#_get_damage()


func _on_food_timer_timeout():
	pass # Replace with function body.
