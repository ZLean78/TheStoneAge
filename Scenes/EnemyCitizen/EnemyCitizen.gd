extends KinematicBody2D

#Proyectil, piedra para lanzar al enemigo.
var bullet
export var bullet_scene=preload("res://Scenes/Bullet/Bullet.tscn")
export var stone_scene=preload("res://Scenes/Stone/stone.tscn")

#Velocidad
export (float) var SPEED = 100.0
#Máximo de Salud
export (float) var MAX_HEALTH = 100.0





#Nodo de la escena actual.
onready var tree

onready var fruit_trees_node
onready var pine_trees_node
onready var plants_node
onready var quarries_node
onready var copper_node
onready var lake_node
onready var puddle_node


#Temporizador de comida, agrega un punto de comida por segundo cuando la unidad toca un árbol frutal.
onready var food_timer


#Variable que indica si está seleccionada la unidad.
var selected = true setget _set_selected
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

#Marca de jefe guerrero.
onready var warchief_mark= $WarchiefMark




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
#Salud.
export (int) var energy_points = MAX_HEALTH
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
var target_position=Vector2.ZERO

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
var is_enemy_touching=false

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

#Para detección de daño. Cuerpo que ingresa al área 2D
var body_entered

#Para saber si la unidad ha sido convertida en jefe guerrero.
var is_warchief = false

var can_shoot = true

var to_delta = 0.0

var direction = Vector2.ZERO

#var has_arrived = false

#var colliding_body: KinematicBody2D



#var body_velocity = Vector2.ZERO

#Variables para levantamiento de construcciones, que indican si una unidad ciudadano
#ha entrado en el Area2D de la construcción para erigirla.
var house_entered=false
var townhall_entered=false
var fort_entered=false
var tower_entered=false
var barn_entered=false

#Variables origen y destino de navegación.
var firstPoint = Vector2.ZERO
var secondPoint = Vector2.ZERO
var index = 0

var AI_state = 0

#Variable enumerador que discrimina el tipo de objetivo.
enum target_type {FRUIT_TREE,PINE_TREE,PLANT,STONE,COPPER,CLAY,WATER}

var target=null
export (target_type) var target_t
export (float) var MIN_DISTANCE
export (float) var MAX_DISTANCE

#Podígono de navegación
onready var nav2d

#Variables para curarse o curar a otro
#var health=MAX_HEALTH
var heal_counter=60
var can_heal_itself=false
var can_heal_another

var is_timer_timeout=false




#Señales de que la unidad fue seleccionada y desseleccionada.
signal was_selected
signal was_deselected


#func _init():
#	call_deferred("ready")
	

func _ready():
	AI_state=1
	tree=Globals.current_scene
	food_timer=tree.food_timer
	fruit_trees_node=tree.get_node("FruitTrees")
	pine_trees_node=tree.get_node("PineTrees")
	plants_node=tree.get_node("Plants")
	quarries_node=tree.get_node("Quarries")
	copper_node=tree.get_node("Coppers")
	lake_node=tree.get_node("Lake")
	puddle_node=tree.get_node("Puddle")
	nav2d=tree.get_node("nav")
	connect("was_selected",tree,"_select_unit")
	connect("was_deselected",tree,"_deselect_unit")
	#emit_signal("health_change",energy_points)
	
	
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
	
	
	box.visible = true
	#label.visible = false
	bar.visible = true
	#label.text = name
	#randomize()
	#bar.value = randi() % 90 + 10
	

	
	
#func _deferred_start():
#	call_deferred("_ready")
	

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
	
	position.x = clamp(position.x,-1028,1028)
	position.y = clamp(position.y,-608,608)	
	
	if AI_state==1 || AI_state==2:
		
		if(AI_state==2):
			_move_along_path((SPEED/2)*delta)
		else:
			_move_along_path(SPEED*delta)
		
		if target_position!=null:
			if position.distance_to(target_position) > MAX_DISTANCE:
				_walk()		
	
	
	if selected:
		if box.visible == false:
			box.visible = true
	else:
		if box.visible == true:
			box.visible = false
	
#	if target_position!=Vector2.ZERO:
#		if position.distance_to(target_position) > 10:			
#			_move_along_path(SPEED*delta)
#		else:
#			target_position=position
#			velocity=Vector2.ZERO
		


	
	# Orientar al player.
	if velocity.x<0:
		if(is_flipped==false):			
			$scalable.scale.x = -1
			is_flipped = true
	if velocity.x>0:
		if(is_flipped==true):			
			$scalable.scale.x = 1
			is_flipped = false
	
	
	
	#Máquina de estados para las acciones.
	_state_machine()		
	#animar al personaje	
	_animate()	
		
	#Cambiar los cuadros de animación del player.
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		if(!sprite.is_playing()):
			sprite.play()
	else:
		sprite.stop()
	
	
		
	#revisar si está tocando un árbol o una planta.
	#_check_fruit_tree_touching()
	#_check_plant_touching()
	#_check_pine_tree_touching()
	

	

	
#	if(Input.is_action_just_pressed("shoot") && selected):
#		bullet = bullet_scene.instance()
#		bullet.position = Vector2(shoot_point.global_position.x,shoot_point.global_position.y)
#		bullet.set_dir($scalable.scale.x)
#		get_parent().add_child(bullet)
		
		
	if(all_timer.is_stopped()):
		timer_count-=1
		all_timer.start()
	
		
func _collect_pickable(var _pickable):
	if _pickable.type == "fruit_tree" or _pickable.type == "pine_tree" or _pickable.type == "plant" or _pickable.type == "quarry" or _pickable.type == "copper":
		if _pickable.touching && !_pickable.empty && pickable_touching:
			if((abs(position.x-_pickable.position.x)<50)&&
			(abs(position.y-_pickable.position.y)<50)):
				if _pickable.type=="fruit_tree":
					if(has_bag):
						if(_pickable.points>=4):
							Globals.e_food_points+=4
							_pickable.points-=4
						else:
							Globals.e_food_points+=_pickable.points
							_pickable.points = 0
					else:					
						Globals.e_food_points+=1
						_pickable.points-=1
						#if _pickable.points <= 0:
						#_pickable.empty = true
				elif _pickable.type == "pine_tree":
					if(tree.is_stone_weapons_developed):
						if(_pickable.points>=4):
							Globals.e_wood_points+=4
							_pickable.points-=4
						else:
							Globals.e_wood_points+=_pickable.points
							_pickable.points = 0
					else:					
						Globals.e_wood_points+=1
						_pickable.points-=1
				elif _pickable.type=="plant":
					if(has_bag):
						if(_pickable.points>=4):
							Globals.e_leaves_points+=4
							_pickable.points-=4
						else:
							Globals.e_leaves_points+=_pickable.points
							_pickable.points=0
					else:
						Globals.e_leaves_points+=1
						_pickable.points-=1
				elif _pickable.type == "copper":
					if(tree.is_stone_weapons_developed):
						if(_pickable.points>=5):
							Globals.e_copper_points+=5
							_pickable.points-=5
						else:
							Globals.e_copper_points+=_pickable.points
							_pickable.points=0
					else:
						Globals.e_copper_points+=1
						_pickable.points-=1
				elif _pickable.type == "quarry":
					if(tree.is_stone_weapons_developed):
						if(_pickable.points>=5):
							Globals.e_stone_points+=5
							_pickable.points-=5
						else:
							Globals.e_stone_points+=_pickable.points
							_pickable.points=5
					else:
						Globals.e_stone_points+=1
						_pickable.points-=1
				if _pickable.points <= 0:
					_pickable.empty = true	
	else:
		if _pickable.touching && pickable_touching:
			if _pickable.type == "puddle" && puddle_touching:
				Globals.e_clay_points+=4
			elif _pickable.type == "lake" && lake_touching:
				if tree.name == "Game2":
					if tree.is_claypot_made:
						Globals.e_water_points+=4
					else:
						tree.prompts_label.text="Debes desarrollar el cuenco de barro \n para poder transportar agua."
				else:
					Globals.water_points+=4
				
					


		
func _get_damage(var the_beast):
	if "Tiger" in the_beast.name && the_beast.visible && is_enemy_touching:
		if is_warchief:
			if(energy_points>0):
				if(!is_dressed):
					energy_points-=10
				else:
					energy_points-=5
				bar._set_energy_points(energy_points)
				
			else:
				_set_selected(false)			
				is_deleted=true				
		else:
			if(energy_points>0):
				if(!is_dressed):
					energy_points-=15
				else:
					energy_points-=10
				bar._set_energy_points(energy_points)
				
			else:
				if the_beast:
					_set_selected(false)			
					is_deleted=true
	if "Mammoth" in the_beast.name && is_enemy_touching:
		if energy_points>0:
			energy_points-=30
			bar._set_energy_points(energy_points)
			
		else:
			_set_selected(false)			
			is_deleted=true
	if "Bullet" in the_beast.name:
		
		if energy_points>0:			
			energy_points-=20
			bar._set_energy_points(self.energy_points)

			print("enemy citizen energy" + str(self.energy_points))
		else:
			is_deleted=true

	if "Warrior" in the_beast.name && is_enemy_touching:
		if energy_points>0:
			energy_points-=20
			bar._set_energy_points(energy_points)
			
		else:
			_set_selected(false)			
			is_deleted=true
	if "Unit2" in the_beast.name && is_enemy_touching:
		if energy_points>0:
			energy_points-=10
			bar._set_energy_points(energy_points)
			
		else:
			_set_selected(false)			
			is_deleted=true
	if "Stone" in the_beast.name && the_beast.owner_name=="Citizen":
		if energy_points>0:
			energy_points-=15
			bar._set_energy_points(energy_points)			
		else:
			_set_selected(false)			
			is_deleted=true
					
								


	
	
func _move_towards(pos,point,delta):
	var v = (point-pos).normalized()
	v *=delta*SPEED
	position += v
	if position.distance_squared_to(point) < 5:
		path.remove(0)
		initialPosition = position
		
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
		

func _move_to_target(target):
	direction = (target-position)
	velocity=(direction).normalized()
	var collision = move_and_collide(velocity*to_delta*SPEED)
	

#func _unhandled_input(event):
#	if event.is_action_pressed("RightClick"):
#		if tree.sword_mode:
#			if tree.touching_enemy!=null:
#				if is_instance_valid(tree.touching_enemy):
#					if selected && can_shoot:
#						if !is_warchief:
#							_shoot()
#						else:
#							for warrior in tree.warriors.get_children():
#								if warrior.position.distance_to(position):
#									warrior._shoot()
#				else:					
#					if tree.name == "Game3":
#						tree._on_Game3_is_arrow()
#					if tree.name == "Game2":
#						tree._on_Game2_is_arrow()
#		else:
#			firstPoint=global_position
#
#
#	if event.is_action_released("RightClick"):		
#		if !tree.sword_mode:
#			_walk()


func _on_Unit_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():			
			if event.button_index == BUTTON_LEFT:
				_set_selected(not selected)
				#tree._select_last()

#func hurt(amount):
#	health-=amount
#	#esto podría ir en un setter
#	if health <= 0:
#		if !dead:
#			emit_signal("im_dead")
#			dead = true
#			set_physics_process(false) 
#		health = 0
#		return
#	elif health > 100:
#		health = 100
#	emit_signal("health_change",health)


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
	if target_position==null || position.distance_to(target_position) < 5:
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

#func _on_tiger_tiger_entered():
#	is_tiger_touching=true

#func _on_tiger_tiger_exited():
#	is_tiger_touching=false

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
#	if body_entered!=null:
#		heal(body_entered)
	timer_count+=1	
	
#	if body_entered!=null && is_instance_valid(body_entered):
#		if "tiger" in body_entered.name || "mammoth" in body_entered.name || "enemy" in body_entered.name:
#			_get_damage(body_entered)
#		if is_warchief:
#			if !("enemy" in body_entered.name) && "unit" in body_entered.name || "warrior" in body_entered.name:
#				heal(body_entered)
		
#	if energy_points<MAX_HEALTH && heal_counter>0:
#		heal_counter-=1
#		if heal_counter<=0:
#			can_heal_itself=true
#
#
#		if can_heal_itself && timer_count>3:
#			self_heal()
	
	
	
	if pickable!=null:
		_collect_pickable(pickable)
	if timer_count>3:
		can_shoot=true
		
	if timer_count>4:
		timer_count=0
		
	all_timer.start()
	
	

func _die():
	queue_free()

func _on_Area2D_body_entered(body):
	if (("Tower" in body.name || "Warrior" in body.name || "Unit" in body.name)
		&& !("Enemy" in body.name)):	
		body_entered=body	
		if is_instance_valid(body_entered):
			if "Warrior" in body.name || "Unit" in body.name:
				body.is_enemy_touching=true
			
	
	
func heal(_body):
	if is_warchief:
		#print(to_delta)	
		if _body.energy_points<_body.MAX_HEALTH:
			#if timer_count==0:
			_body.energy_points+=5
			print("unit energy" + str(_body.energy_points))
			_body.bar._set_energy_points(_body.energy_points)
			
	
			if _body.energy_points>_body.MAX_HEALTH:
				_body.energy_points=_body.MAX_HEALTH
		
		_body.bar.visible=true
		
			
func self_heal():	
	if energy_points<MAX_HEALTH:
		energy_points+=5
		bar._set_energy_points(energy_points)
		
		
		if energy_points>MAX_HEALTH:
			energy_points=MAX_HEALTH
			can_heal_itself=false
			heal_counter=60





func _shoot():
	if(target!=null) && is_instance_valid(target):
		target_position = target.position
		shoot_node.look_at(target_position)				
		var angle = shoot_node.rotation
		#var forward = Vector2(cos(angle),sin(angle))
		var new_stone = stone_scene.instance()
		shoot_point.rotation = angle				
		new_stone.position = Vector2(shoot_point.global_position.x,shoot_point.global_position.y)
		if target_position.x<position.x:
			new_stone.set_velocity(Vector2(-200,0))
		else:
			new_stone.set_velocity(Vector2(200,0))
		new_stone.rotation = angle
		new_stone.owner_name="EnemyCitizen"		
		var the_tilemap=get_tree().get_nodes_in_group("tilemap")
		the_tilemap[0].add_child(new_stone)
		can_shoot=false

func _walk():
	firstPoint = global_position
	secondPoint = target_position		
	var arrPath: PoolVector2Array = nav2d.get_simple_path(firstPoint,secondPoint,true)
	firstPoint = arrPath[0]
	path = arrPath
	index = 0				
			


func _on_Area2D_body_exited(body):
	if "Warrior" in body.name || "Unit" in body.name:
		body.is_enemy_touching=false
		body_entered=null	
	
	
func _choose_target():
	if is_instance_valid(body_entered) && body_entered!=null && ("Warrior" in body_entered.name || "Unit" in body_entered.name) && !("Enemy" in body_entered.name):
		target=body_entered
		target_position=body_entered.position
	else:
		match target_t:
			target_type.PLANT:
				if !(AI_state==2):
					if plants_node.get_child_count()>0:
						for i in range(0,plants_node.get_child_count()):
							if !plants_node.get_child(i).empty:
								target_position=plants_node.get_child(i).position
								break
							else:
								target_position=plants_node.get_child(i+1).position
	
	
			target_type.FRUIT_TREE:
				if !(AI_state==2):
					if fruit_trees_node.get_child_count()>0:
						for i in range(0,fruit_trees_node.get_child_count()):
							if !fruit_trees_node.get_child(i).empty:
								target_position=fruit_trees_node.get_child(i).position
								break
							else:
								target_position=fruit_trees_node.get_child(i+1).position
			target_type.PINE_TREE:
				if !(AI_state==2):
					if pine_trees_node.get_child_count()>0:				
						for i in range(0,pine_trees_node.get_child_count()):
							if !pine_trees_node.get_child(i).empty:
								target_position=pine_trees_node.get_child(i).position
								break
							else:
								target_position=pine_trees_node.get_child(i+1).position		
			target_type.COPPER:
				if !(AI_state==2):
					if copper_node.get_child_count()>0:				
						for i in range(0,copper_node.get_child_count()):
							if !copper_node.get_child(i).empty:
								target_position=copper_node.get_child(i).position
								break
							else:
								target_position=copper_node.get_child(i+1).position
			target_type.STONE:
				if !(AI_state==2):
					if quarries_node.get_child_count()>0:				
						for i in range(0,quarries_node.get_child_count()):
							if !quarries_node.get_child(i).empty:
								target_position=quarries_node.get_child(i).position
								break
							else:
								target_position=quarries_node.get_child(i+1).position
	
	
		


#MUESTRA DE CÓDIGO ANTERIOR
#	if target_t==target_type.PLANT && plants_node.get_child_count()>0:
#		for i in range(0,plants_node.get_child_count()):
#			if i!=0:
#				if plants_node.get_child(i).position.distance_to(position)<plants_node.get_child(i-1).position.distance_to(position):
#					if !plants_node.get_child(i).empty:
#						target=plants_node.get_child(i)
#						target_position=plants_node.get_child(i).position
##						if position.distance_to(root.tower_node.get_child(i).position)==position.distance_to(root.tower_node.get_child(i-1).position):
##							target=root.tower_node.get_child(i)
##							target_position=root.tower_node.get_child(i).position
#			else:
#				if !plants_node.get_child(i).empty:
#					target=plants_node.get_child(i)
#					target_position=plants_node.get_child(i).position	
	

func _state_machine():
	match AI_state:
		0:
			_choose_target()
			AI_state=1
		1:
			if target!=null && is_instance_valid(target):
				if( !("Lake" in target.name) && !("Puddle" in target.name) 
				&& !("Unit" in target.name) && !("Warrior" in target.name)):
					if target.empty:
						AI_state=0
						if target_t==target_type.COPPER:
							print("Cambio buscador de cobre a estado 0")
			else:
				AI_state=0
		2:
			if !(is_instance_valid(body_entered)):
				#print("vuelta a estado 0")
				AI_state=0
			else:	
				if position.distance_to(target_position)<=150 && target_position!=self.position:	
					if can_shoot:
						_shoot()
				else:
					target_position=body_entered.position
				
		3:
			target_position=self.position
			
	if body_entered!=null && is_instance_valid(body_entered):
		#print("se ha detectado un cuerpo")
		#print(body_entered)
		if !("Enemy" in body_entered.name) && ("Warrior" in body_entered.name || "Unit" in body_entered.name):
			
			target_position=body_entered.position
			#print("cambio a estado 2")
			AI_state=2	


	if position.distance_to(target_position)<=50 :
		if can_shoot:
			_shoot()
	
	

func _on_EnemyCitizen_mouse_entered():
	if tree.name=="Game4":
		tree._on_Game4_is_sword()
	if tree.name=="Game5":
		tree._on_Game5_is_sword()
	tree.emit_signal("is_sword")
	tree.touching_enemy=self


func _on_EnemyCitizen_mouse_exited():
	if tree.name=="Game4":
		tree._on_Game4_is_arrow()
	if tree.name=="Game5":
		tree._on_Game5_is_arrow()
	tree.emit_signal("is_arrow")
	tree.touching_enemy=null
