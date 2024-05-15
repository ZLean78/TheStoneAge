extends KinematicBody2D

#Proyectil, piedra para lanzar al enemigo.
var bullet
export var bullet_scene=preload("res://Scenes/Bullet/Bullet.tscn")
#direction del proyectil
var direction = Vector2.ZERO
#para guardar el parámetro delta del procedimiento _physics_process(delta)
var to_delta=0.0
#Velocidad
export (float) var SPEED = 100.0
#Máximo de Salud
export (float) var MAX_HEALTH = 100.0

#Temporizador de comida, agrega un punto de comida por segundo cuando la unidad toca un árbol frutal.
onready var food_timer = get_tree().root.get_child(0).find_node("food_timer")
#Salud


#Variable que indica si está seleccionada la unidad.
var selected = false setget _set_selected
#Marca de selección
onready var box = $Selected
#onready var label = $label
#Barra de Energía
onready var bar = $Bar

#Variable que indica si el jugador debe moverse.
var move_p = false
#Vector2 que indica cuánto debe moverse el jugador.
var to_move = Vector2()
#PoolVector2Array que indica el camino variable teniendo en cuenta el Polígono de navegación.
var path = PoolVector2Array()
#Posición inicial, se actualiza cada vez que hacemos click con el botón derecho.
var initialPosition = Vector2()

#Puntos de comida de la unidad.
#var food_points = 0
#Puntos de energía.
var energy_points = 100


#Indica si la animación de la unidad debe estar flipeada en x.
var is_flipped = false

#Indica si la unidad ha muerto.
var dead = false


#Variables agregadas

#!!!!
var motion = Vector2()
#Vector2 que indica la velocidad en x e y para las animaciones.
var velocity = Vector2()
#!!!!!
var touch_enabled = false
#Indica si la unidad se encuentra bajo refugio.
#var is_sheltered = false
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



#Indica si está lloviendo para la unidad.
var its_raining = false



#Vector2 que indica el tamaño de la pantalla.
var screensize = Vector2(ProjectSettings.get("display/window/size/width"),ProjectSettings.get("display/window/size/height"))

#Indica si la unidad está tocando un árbol frutal.
var fruit_tree_touching = false

#Indica si la unidad está tocando una planta (para obtener hojas).
var plant_touching = false

#Indica si la unidad está tocando el lago (para obtener agua).
var lake_touching=false

#Indica si la unidad está tocando un pickable (objecto para recoger).
var pickable_touching = false

#Variable que indica el pickable que la unidad está tocando
var pickable = null

#!!!!
onready var all_timer = $all_timer

onready var sprite = get_node("scalable/sprite")
onready var bag_sprite = get_node("scalable/bag_sprite")
onready var shoot_point = get_node("scalable/shootNode/shootPoint")

#Variable contador para diferenciar cuándo ha acabado el timer "all_timer".
var timer_count=1



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
	#emit_signal("health_change",health)
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
	
	bar.visible = false
	
	#all_timer.start()
	

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
	
	if selected:
		if box.visible == false:
			box.visible = true
	else:
		if box.visible == true:
			box.visible = false
			
#	position.x = clamp(position.x,0,screensize.x)
#	position.y = clamp(position.y,0,screensize.y)	
	
	if target_position!=Vector2.ZERO:
		if position.distance_to(target_position) > 10:
			_move_to_target(target_position)
		else:
			target_position=position
			velocity=Vector2.ZERO
	
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
		velocity = velocity.normalized() * SPEED
		if(!sprite.is_playing()):
			sprite.play()
	else:
		sprite.stop()
		
	
	
#	if(Input.is_action_just_pressed("shoot") && selected):
#		bullet = bullet_scene.instance()
#		bullet.position = Vector2(shoot_point.global_position.x,shoot_point.global_position.y)
#		bullet.set_dir(scale.x)
#		get_parent().add_child(bullet)
		
		
#	if(food_timer.is_stopped()):
#		food_timer.start()
	
	if(all_timer.is_stopped()):
		timer_count=1
#		all_timer.start()
		

func _collect_pickable(_pickable):
	if !_pickable.empty:
		if _pickable.type == "fruit_tree":
			if timer_count==0:
				if has_bag:
					if _pickable.points>=4:
						get_tree().root.get_child(0).food_points+=4
						_pickable.points-=4
					else:
						get_tree().root.get_child(0).food_points+=_pickable.points
						_pickable.points=0
				else:
					get_tree().root.get_child(0).food_points+=1
					_pickable.points-=1
				#body.count=1
			if _pickable.points==0:
				_pickable.empty=true
		if _pickable.type == "plant":
			if timer_count==0:
				if has_bag:
					if _pickable.points>=4:
						get_tree().root.get_child(0).leaves_points+=4
						_pickable.points-=4
					else:
						get_tree().root.get_child(0).leaves_points+=_pickable.points
						_pickable.points=0
				else:
					get_tree().root.get_child(0).leaves_points+=1
					_pickable.points-=1
				#body.count=1
			if _pickable.points==0:
				_pickable.empty=true	
		
func _get_damage():
	if(get_tree().root.get_child(0).its_raining && !pickable_touching):
		if timer_count==0:
			if(energy_points>0):
				if(!is_dressed):
					energy_points-=3
				else:
					energy_points-=1
					#the_unit.get_child(4)._decrease_energy()
				bar._set_energy_points(energy_points)
				bar._update_energy()
			else:
				visible=false
				_set_selected(false)			
				get_tree().root.get_child(0).all_units.erase(self)	
				_set_erased(true)
					
#				else:
#					the_unit.visible = false
#					if(all_units.size()<=1 && food_points<15):
#					$The_Canvas._set_phrase("Has sido derrotado.")				
					
	elif(get_tree().root.get_child(0).its_raining && pickable_touching):
		if timer_count==0:
			if(energy_points<100):
				energy_points+=1
				#the_unit.get_child(4)._increase_energy()
				bar._set_energy_points(energy_points)
				bar._update_energy()
	
func move_towards(pos,point,delta):
	var v = (point-pos).normalized()
	v *=delta*SPEED
	position += v
	if position.distance_squared_to(point) < 5:
		path.remove(0)
		initialPosition = position
		
func _move_to_target(target):
	direction = (target-position)
	velocity=(direction).normalized()
	var collision = move_and_collide(velocity*to_delta*SPEED)
	
	
		
		
	
	

func _on_Unit_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				_set_selected(not selected)








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
	





func _on_player_mouse_entered():
	selected = true
	
func _set_pickable_touching(var _pickable):
	pickable_touching=_pickable
	

func _set_lake_touching(var _lake):
	lake_touching=_lake	

func _set_pickable(_pickable):
	pickable=_pickable	

func _set_its_raining(var _its_raining):
	its_raining = _its_raining
	
func _set_erased(var _is_erased):
	is_erased=_is_erased
	

#	







	


func _on_all_timer_timeout():
	timer_count=0
	_get_damage()
	if pickable!=null:
		_collect_pickable(pickable)
	
	
