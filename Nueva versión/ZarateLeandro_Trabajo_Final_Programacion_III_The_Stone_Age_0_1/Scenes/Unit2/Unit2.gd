extends KinematicBody2D

#Proyectil, piedra para lanzar al enemigo.
var bullet
export var bullet_scene=preload("res://Scenes/Bullet/Bullet.tscn")

#Velocidad
export (float) var SPEED = 250.0
#Máximo de Salud
export (float) var MAX_HEALTH = 100.0

#variable que indica el nodo raíz.
onready var root=get_tree().root.get_child(0)

#Temporizador de comida, agrega un punto de comida por segundo cuando la unidad toca un árbol frutal.
onready var food_timer = root.find_node("food_timer")
#Salud
onready var health = MAX_HEALTH

#Variable que indica si está seleccionada la unidad.
var selected = false setget _set_selected
#Marca de selección
onready var box = $Selected
#onready var label = $label
#Barra de Energía
onready var bar = $Bar
onready var all_timer = $all_timer
onready var sprite = get_node("scalable/sprite")
onready var bag_sprite = get_node("scalable/bag_sprite")
onready var shoot_node = $shootNode
onready var shoot_point = $shootNode/shootPoint


#Variable que indica si el jugador debe moverse.
var move_p = false
#Vector2 que indica cuánto debe moverse el jugador.
var to_move = Vector2()
#PoolVector2Array que indica el camino variable teniendo en cuenta el Polígono de navegación.
var path = PoolVector2Array()
#Posición inicial, se actualiza cada vez que hacemos click con el botón derecho.
var initialPosition = Vector2()

#Puntos de comida de la unidad.
var food_points = 0
#Puntos de energía.
var energy_points = 100
#Variable que indica si se está arrastrando el mouse sobre la unidad.
var dragging = true

#Indica si la animación de la unidad debe estar flipeada en x.
var is_flipped = false
var is_chased = false
#var click_relative = 16
#Indica si la unidad ha muerto.
var dead = false



#Variables agregadas
#var device_number = 0
#!!!!
var motion = Vector2()
#Vector2 que indica la velocidad en x e y para las animaciones.
var velocity = Vector2()
#!!!!!
var touch_enabled = false
#Indica si la unidad se encuentra bajo refugio.
var is_sheltered = false
#Indica si la unidad es o no mujer.
var is_girl = false
#Indica si la unidad está vestida (tiene túnica de hojas o no).
var is_dressed = false
#Indica si tiene cesta de hojas o no.
var has_bag = false
#Indica si la unidad ha sido eliminada o no.
var is_erased = false


#Posición adonde la unidad debe moverse.
var target_position = Vector2.ZERO

#Indica si la unidad puede agregar puntos de comida o no.
var can_add = false
#Indica si la unidad puede agregar puntos de hojas.
var can_add_leaves = false

#var can_add_multiple = false

#Indica si está lloviendo para la unidad.
var its_raining = false

#Vector2 que indica el tamaño de la pantalla.
var screensize = Vector2(ProjectSettings.get("display/window/size/width"),ProjectSettings.get("display/window/size/height"))

#Indica si la unidad está tocando un tgre
var is_tiger_touching=false

#Tigre que la unidad está tocando
var tiger = null

#Indica si la unidad está tocando un árbol frutal.
var fruit_tree_touching = false

#Indica si la unidad está tocando una planta (para obtener hojas).
var plant_touching = false

#Indica si la unidad está tocando una cantera (para obtener piedra).
var quarry_touching = false

#Indica si la unidad está tocando un charco (para obtener lodo).
var puddle_touching = false

#Indica si la unidad está tocando un pino (para obtener madera).
var pine_tree_touching = false

#Indica si la unidad está tocando el lago (para obtener agua).
var lake_touching = false

#Indica si la unidad está tocando un pickable (objecto para recoger).
var pickable_touching = false


#Variable que indica el pickable que la unidad está tocando
var pickable = null

#!!!!

#Variable contador para diferenciar cuándo ha acabado el timer "all_timer".
var timer_count=1

#Para saber si la unidad ha sido eliminada.
var is_deleted=false

#Para saber si la unidad ha sido convertida en jefe guerrero.
var is_warchief = false

var can_shoot = true

var to_delta = 0.0

var direction = Vector2.ZERO

var has_arrived = false

var colliding_body: KinematicBody2D

var is_colliding_body=false

var body_velocity = Vector2.ZERO

#Señal de cambio de salud (incremento o decremento).
signal health_change
#Señal de que la unidad ha muerto.
signal im_dead
#signal food_points_change

#Señales de que la unidad fue seleccionada y desseleccionada.
signal was_selected
signal was_deselected


func _ready():
	connect("was_selected",get_tree().root.get_child(0),"select_unit")
	connect("was_deselected",get_tree().root.get_child(0),"deselect_unit")
	emit_signal("health_change",health)
	has_bag=true
	is_dressed=true
	if(!is_dressed):
		if !is_girl:
			sprite.animation = "male_idle1"
		if is_girl:
			sprite.animation = "female_idle1"
	else:
		if !is_girl:
			sprite.animation = "male_idle1_d"
		if is_girl:
			sprite.animation = "female_idle1_d"
	
	
	box.visible = false
	#label.visible = false
	bar.visible = false
	#label.text = name
	#randomize()
	#bar.value = randi() % 90 + 10
	

func _set_selected(value):
	if selected != value:
		selected = value
		box.visible = value
		#label.visible = value
		bar.visible = value
		if selected:
			emit_signal("was_selected",self)
		else:
			emit_signal("was_deselected",self)


	
	

func _physics_process(delta):
	
	to_delta=delta
	
	position.x = clamp(position.x,-1028,screensize.x)
	position.y = clamp(position.y,-608,screensize.y)	
	
	if selected:
		if box.visible == false:
			box.visible = true
	else:
		if box.visible == true:
			box.visible = false
	
	if !has_arrived:
		if target_position!=Vector2.ZERO:
			if position.distance_to(target_position) > 10:
				_move_to_target(target_position)
			else:
				has_arrived=true
				target_position=position
				velocity=Vector2.ZERO
		
	
	if is_colliding_body && body_velocity==Vector2.ZERO:
		velocity=Vector2.ZERO		
	
	
	"""if move_p:
		path = get_tree().root.get_child(0).get_node("nav").get_simple_path(position,target_position)
		velocity=(target_position-position)
		initialPosition = position
		move_p = false
	if path.size()>0:
		move_towards(initialPosition,path[0],delta)
	else:
		velocity=Vector2(0,0)"""	
	
	# Orientar al player.
	if velocity.x<0:
		if(is_flipped==false):			
			$scalable.scale.x = -1
			is_flipped = true
	if velocity.x>0:
		if(is_flipped==true):			
			$scalable.scale.x = 1
			is_flipped = false
	
				
	#animar al personaje	
	_animate()	
		
	#Cambiar los cuadros de animación del player.
	if velocity.length() > 0:
		#velocity = velocity.normalized() * SPEED
		if(!sprite.is_playing()):
			sprite.play()
	else:
		sprite.stop()
	
	
		
	#revisar si está tocando un árbol
	_check_fruit_tree_touching()
	_check_plant_touching()
	_check_pine_tree_touching()
	
#	if(Input.is_action_just_pressed("shoot") && selected):
#		bullet = bullet_scene.instance()
#		bullet.position = Vector2(shoot_point.global_position.x,shoot_point.global_position.y)
#		bullet.set_dir($scalable.scale.x)
#		get_parent().add_child(bullet)
		
		
	if(all_timer.is_stopped()):
		all_timer.start()
		
	
		
func _collect_pickable(var _pickable):
	if _pickable.type == "fruit_tree" or _pickable.type == "pine_tree" or _pickable.type == "plant" or _pickable.type == "quarry":
		if _pickable.touching && !_pickable.empty && pickable_touching:
			if((abs(position.x-_pickable.position.x)<50)&&
			(abs(position.y-_pickable.position.y)<50)):
				if _pickable.type=="fruit_tree":
					if(has_bag):
						if(_pickable.points>=4):
							root.food_points +=4
							_pickable.points-=4
						else:
							root.food_points += _pickable.points
							_pickable.points = 0
					else:					
						root.food_points +=1
						_pickable.points-=1
						#if _pickable.points <= 0:
						#_pickable.empty = true
				elif _pickable.type == "pine_tree":
					if(root.is_stone_weapons_developed):
						if(_pickable.points>=4):
							root.wood_points +=4
							_pickable.points-=4
						else:
							root.wood_points += _pickable.points
							_pickable.points = 0
					else:					
						root.wood_points +=1
						_pickable.points-=1
				elif _pickable.type == "plant":
					if(has_bag):
						if(_pickable.points>=4):
							root.leaves_points +=4
							_pickable.points-=4
						else:
							root.leaves_points+=_pickable.points
							_pickable.points=0
					else:
						root.leaves_points+=1
						_pickable.points-=1
				elif _pickable.type == "quarry":
					if(root.is_stone_weapons_developed):
						if(_pickable.points>=4):
							root.stone_points+=4
							_pickable.points-=4
						else:
							root.stone_points+=_pickable.points
							_pickable.points=0
					else:
						root.stone_points+=1
						_pickable.points-=1
			if _pickable.points <= 0:
				_pickable.empty = true	
	else:
		if _pickable.touching && pickable_touching:
			if _pickable.type == "puddle" && puddle_touching:
				root.clay_points+=4
			elif _pickable.type == "lake" && lake_touching:
				if root.name == "Game2":
					if root.is_claypot_made:
						root.water_points+=4
					else:
						root.prompts_label.text="Debes desarrollar el cuenco de barro \n para poder transportar agua."
				else:
					root.water_points+=4
				
					


		
func _get_damage(var the_tiger):
	if is_chased && is_tiger_touching:
		if is_warchief:
			if(energy_points>0):
				if(!is_dressed):
					energy_points-=10
				else:
					energy_points-=5
				bar._set_energy_points(energy_points)
				bar._update_energy()
			else:
				the_tiger.unit = null
				the_tiger.is_chasing = false
				_set_selected(false)			
				is_deleted=true				
		else:
			if(energy_points>0):
				if(!is_dressed):
					energy_points-=15
				else:
					energy_points-=10
				bar._set_energy_points(energy_points)
				bar._update_energy()
			else:
				if the_tiger:
					the_tiger.unit = null
					the_tiger.is_chasing = false
					_set_selected(false)			
					is_deleted=true
#								


	
	
func move_towards(pos,point,delta):
	var v = (point-pos).normalized()
	v *=delta*SPEED
	position += v
	if position.distance_squared_to(point) < 5:
		path.remove(0)
		initialPosition = position
		

func _move_to_target(target):
	direction = (target-position)*SPEED
	velocity=(direction*to_delta).normalized()
	move_and_collide(velocity)
	
		
func move_unit(point):
	to_move = point
	move_p = true
	
	
	
	

func _unhandled_input(event):
	if event is InputEventMouseButton && event.button_index == BUTTON_RIGHT:
		if get_tree().root.get_child(0).name == "Game2":
			if selected:
				has_arrived = false
				target_position = get_global_mouse_position()
			else:
				has_arrived=false
				target_position=position
		if get_tree().root.get_child(0).name == "Game3":
			if selected:
				has_arrived = false
				target_position=get_global_mouse_position()
			else:
				has_arrived = false
				target_position=position
		if get_tree().root.get_child(0).sword_mode:
			if get_tree().root.get_child(0).touching_tiger!=null:
				target_position = get_tree().root.get_child(0).touching_tiger.position
				if selected && can_shoot:
					shoot_node.look_at(target_position)				
					var angle = shoot_node.rotation
					var forward = Vector2(cos(angle),sin(angle))
					bullet = bullet_scene.instance()
					shoot_point.rotation = angle				
					bullet.position = Vector2(shoot_point.global_position.x,shoot_point.global_position.y)
					bullet.set_dir(forward)
					bullet.rotation = angle		
					get_parent().add_child(bullet)
					can_shoot=false
			

func _on_Unit_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():			
			if event.button_index == BUTTON_LEFT:
				_set_selected(not selected)
				root.select_last()
				





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
		sprite.animation = "male_idle1"
	if is_girl:
		sprite.animation = "female_idle1"


func _on_Target_Position1_body_entered(_body):
	velocity = Vector2(0,0)
	if !is_girl:
		sprite.animation = "male_idle1"
	if is_girl:
		sprite.animation = "female_idle1"
		

		
func _animate():
	if(!is_dressed):
		if(!is_girl):
			if velocity == Vector2(0,0):
				if sprite.animation == "male_backwalk":
					sprite.animation = "male_idle2"
					if(bag_sprite.visible):
						bag_sprite.animation = "bag_2"
				elif sprite.animation == "male_frontwalk":
					sprite.animation = "male_idle1"
					if(bag_sprite.visible):
						bag_sprite.animation = "bag_1"
				elif sprite.animation == "male_sidewalk":
					sprite.animation = "male_idle3"
					if(bag_sprite.visible):
						bag_sprite.animation = "bag_3"
#				else:
#					$sprite.animation = "male_idle1"
			else:
				if velocity.y < 0:
					if abs(velocity.y) > abs(velocity.x):
						sprite.animation = "male_backwalk"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_2"
					else:
						sprite.animation = "male_sidewalk"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_3"
				elif velocity.y > 0:
					if abs(velocity.y) > abs(velocity.x):
						sprite.animation = "male_frontwalk"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_1"
					else:
						sprite.animation = "male_sidewalk"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_3"
				elif velocity.x < 0:
					if abs(velocity.x) > abs(velocity.y):
						sprite.animation = "male_sidewalk"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_3"
					else:
						sprite.animation = "male_backwalk"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_2"
				elif velocity.x > 0:
					if abs(velocity.x) > abs(velocity.y):
						sprite.animation = "male_sidewalk"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_3"
					else:
						sprite.animation = "male_frontwalk"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_1"
#				else:
#				$sprite.animation = "male_idle1"			
		else:
			if velocity == Vector2(0,0):
				if sprite.animation == "female_backwalk":
					sprite.animation = "female_idle2"
					if(bag_sprite.visible):
						bag_sprite.animation = "bag_2"
				elif sprite.animation == "female_frontwalk":
					sprite.animation = "female_idle1"
					if(bag_sprite.visible):
						bag_sprite.animation = "bag_1"
				elif sprite.animation == "female_sidewalk":
					sprite.animation = "female_idle3"	
					if(bag_sprite.visible):
						bag_sprite.animation = "bag_3"	
#				else:
#					$sprite.animation = "female_idle1"
			else:
				if velocity.y < 0:
					if abs(velocity.y) > abs(velocity.x):
						sprite.animation = "female_backwalk"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_2"
					else:
						sprite.animation = "female_sidewalk"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_3"
				elif velocity.y > 0:
					if abs(velocity.y) > abs(velocity.x):
						sprite.animation = "female_frontwalk"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_1"
					else:
						sprite.animation = "female_sidewalk"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_3"
				elif velocity.x < 0:
					if abs(velocity.x) > abs(velocity.y):
						sprite.animation = "female_sidewalk"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_3"
					else:
						sprite.animation = "female_backwalk"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_2"
				elif velocity.x > 0:
					if abs(velocity.x) > abs(velocity.y):
						sprite.animation = "female_sidewalk"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_3"
					else:
						sprite.animation = "female_frontwalk"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_1"
#				else:
#					$sprite.animation = "female_idle1"	
	else:
		if(!is_girl):
			if velocity == Vector2(0,0):
				if sprite.animation == "male_backwalk_d":
					sprite.animation = "male_idle2_d"
					if(bag_sprite.visible):
						bag_sprite.animation = "bag_2"
				elif sprite.animation == "male_frontwalk_d":
					sprite.animation = "male_idle1_d"
					if(bag_sprite.visible):
						bag_sprite.animation = "bag_1"
				elif sprite.animation == "male_sidewalk_d":
					sprite.animation = "male_idle3_d"
					if(bag_sprite.visible):
						bag_sprite.animation = "bag_3"
#				else:
#					$sprite.animation = "male_idle1"
			else:
				if velocity.y < 0:
					if abs(velocity.y) > abs(velocity.x):
						sprite.animation = "male_backwalk_d"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_2"
					else:
						sprite.animation = "male_sidewalk_d"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_3"
				elif velocity.y > 0:
					if abs(velocity.y) > abs(velocity.x):
						sprite.animation = "male_frontwalk_d"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_1"
					else:
						sprite.animation = "male_sidewalk_d"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_3"
				elif velocity.x < 0:
					if abs(velocity.x) > abs(velocity.y):
						sprite.animation = "male_sidewalk_d"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_3"
					else:
						sprite.animation = "male_backwalk_d"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_2"
				elif velocity.x > 0:
					if abs(velocity.x) > abs(velocity.y):
						sprite.animation = "male_sidewalk_d"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_3"
					else:
						sprite.animation = "male_frontwalk_d"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_1"
#				else:
#				$sprite.animation = "male_idle1"			
		else:
			if velocity == Vector2(0,0):
				if sprite.animation == "female_backwalk_d":
					sprite.animation = "female_idle2_d"
					if(bag_sprite.visible):
						bag_sprite.animation = "bag_2"
				elif sprite.animation == "female_frontwalk_d":
					sprite.animation = "female_idle1_d"
					if(bag_sprite.visible):
						bag_sprite.animation = "bag_1"
				elif sprite.animation == "female_sidewalk_d":
					sprite.animation = "female_idle3_d"	
					if(bag_sprite.visible):
						bag_sprite.animation = "bag_3"	
#				else:
#					$sprite.animation = "female_idle1"
			else:
				if velocity.y < 0:
					if abs(velocity.y) > abs(velocity.x):
						sprite.animation = "female_backwalk_d"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_2"
					else:
						sprite.animation = "female_sidewalk_d"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_3"
				elif velocity.y > 0:
					if abs(velocity.y) > abs(velocity.x):
						sprite.animation = "female_frontwalk_d"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_1"
					else:
						sprite.animation = "female_sidewalk_d"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_3"
				elif velocity.x < 0:
					if abs(velocity.x) > abs(velocity.y):
						sprite.animation = "female_sidewalk_d"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_3"
					else:
						sprite.animation = "female_backwalk_d"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_2"
				elif velocity.x > 0:
					if abs(velocity.x) > abs(velocity.y):
						sprite.animation = "female_sidewalk_d"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_3"
					else:
						sprite.animation = "female_frontwalk_d"
						if(bag_sprite.visible):
							bag_sprite.animation = "bag_1"
#				else:
#					$sprite.animation = "female_idle1"	
		
			
	
		
		
	
	
	#if position.distance_to(get_node("Single_Tap_Device/Target_Position").position) < 5:
	#target_position = get_global_mouse_position()
	if position.distance_to(target_position) < 5:
		if(!is_dressed):
			if(!is_girl):
				sprite.animation = "male_idle1"
			else:
				sprite.animation = "female_idle1"
		else:
			if(!is_girl):
				sprite.animation = "male_idle1_d"
			else:
				sprite.animation = "female_idle1_d"
		if(bag_sprite.visible):
			bag_sprite.animation = "bag_1"
	


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

func _on_tiger_tiger_entered():
	is_tiger_touching=true

func _on_tiger_tiger_exited():
	is_tiger_touching=false

func _on_player_mouse_entered():
	selected = true

	
func _set_fruit_tree_touching(var _fruit_tree):
	fruit_tree_touching=_fruit_tree
	
func _set_plant_touching(var _plant):
	plant_touching=_plant
	
func _set_quarry_touching(var _quarry):
	quarry_touching=_quarry
	
func _set_puddle_touching(var _puddle):
	puddle_touching=_puddle
	
func _set_pine_tree_touching(var _pine_tree):
	pine_tree_touching=_pine_tree

func _set_lake_touching(var _lake):
	lake_touching=_lake

func _set_pickable_touching(var _pickable):
	pickable_touching=_pickable
	
func _set_pickable(_pickable):
	pickable=_pickable	

func _set_its_raining(var _its_raining):
	its_raining = _its_raining
	
func _set_erased(var _is_erased):
	is_erased=_is_erased
	
func _check_fruit_tree_touching():
	_set_fruit_tree_touching(fruit_tree_touching)
	
func _check_plant_touching():
	_set_plant_touching(plant_touching)

func _check_quarry_touching():
	_set_quarry_touching(quarry_touching)
	
func _check_puddle_touching():
	_set_puddle_touching(puddle_touching)
	
func _check_pine_tree_touching():
	_set_pine_tree_touching(pine_tree_touching)
#	
func _on_all_timer_timeout():
	timer_count=0
	can_shoot=true
	if tiger!=null:
		_get_damage(tiger)
	if pickable!=null:
		_collect_pickable(pickable)
	

func _die():
	queue_free()









func _on_Area2D_body_entered(body):
	if "Unit" in body.name:
		colliding_body = body
		is_colliding_body = true
		body_velocity = body.velocity


func _on_Area2D_body_exited(body):
	if "Unit" in body.name:
		colliding_body = null
		is_colliding_body = false
