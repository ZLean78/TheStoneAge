extends "res://Scenes/Unit/Unit.gd"

onready var animation=$Animation

#Marca de jefe guerrero.
onready var warchief_mark=$WarchiefMark

var spear
export (PackedScene) var spear_scene
var stone
export (PackedScene) var stone_scene

#Posición inicial, se actualiza cada vez que hacemos click con el botón derecho.
var startPosition = Vector2()



#Variable que indica si se está arrastrando el mouse sobre la unidad.
var dragging = true


#Variables agregadas
#var device_number = 0
#!!!!
var motion = Vector2()

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

#Indica si la unidad puede agregar puntos de comida o no.
var can_add = false




#Indica si está lloviendo para la unidad.
var its_raining = false

#Vector2 que indica el tamaño de la pantalla.
var screensize = Vector2(ProjectSettings.get("display/window/size/width"),ProjectSettings.get("display/window/size/height"))

#Indica si la unidad está tocando un enemigo animal.
var is_enemy_touching=false

##Tigre que la unidad está tocando
#var tiger = null

##Indica si la unidad está tocando un árbol frutal.
#var fruit_tree_touching = false
#
##Indica si la unidad está tocando una planta (para obtener hojas).
#var plant_touching = false
#
##Indica si la unidad está tocando una cantera (para obtener piedra).
#var quarry_touching = false
#
#Indica si la unidad está tocando un charco (para obtener lodo).
var puddle_touching = false
#
##Indica si la unidad está tocando un pino (para obtener madera).
#var pine_tree_touching = false
#
#Indica si la unidad está tocando el lago (para obtener agua).
var lake_touching = false

#Indica si la unidad está tocando un pickable (objecto para recoger).
var pickable_touching = false


#Variable que indica el pickable que la unidad está tocando
var pickable = null


#Para saber si la unidad ha sido marcada para eliminación.
var is_deleted=false


#Para saber si la unidad ha sido convertida en jefe guerrero.
var is_warchief = false

#Para saber si la unidad es general.
var is_general = false

#Indica si la unidad puede disparar.
var can_shoot = true

#Vector que indica la dirección en la que la unidad va a moverse.
var direction = Vector2.ZERO


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

#Polígono de navegación
onready var nav2d=tree.get_node("nav")

#Variables para curarse o curar a otro
#Tiempo a esperar para curarse uno mismo.
var heal_counter=60
#Si puede curarse ella misma.
var can_heal_itself=false
#Si puede curar a otro.
var can_heal_another


var heal_timer=null
var pickable_timer=null



func _ready():
	
	heal_timer=Timer.new()
	heal_timer.set("wait_time",1)
	heal_timer.set("one_shot",true)
	heal_timer.connect("timeout",self,"enable_heal",[can_heal_another])
	add_child(heal_timer)
	
	pickable_timer=Timer.new()
	pickable_timer.set("wait_time",1)
	pickable_timer.set("one_shot",true)
	pickable_timer.connect("timeout",self,"enable_pickable")
	add_child(pickable_timer)
	
	bar=$Bar
	bar.value=health
	
	foot=$Foot
	
	sprite = $scalable/sprite
	bag_sprite = $scalable/bag_sprite
	shoot_node = $shootNode
	shoot_point = $shootNode/shootPoint
	
	
	#Salud.
	health = MAX_HEALTH
	
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
			
	if(!has_bag):
		bag_sprite.visible=false
	else:
		bag_sprite.visible=true
	
	
	bar.visible=true
	foot.visible=false
	
	
	
	

func _physics_process(delta):
	
	to_delta=delta
		
	if selected:
		if foot.visible == false:
			foot.visible = true
	else:
		if foot.visible == true:
			foot.visible = false
	
	if target_position!=Vector2.ZERO:
		if position.distance_to(target_position) > 7:
			_move_along_path(SPEED*delta)
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
	animation._animate(sprite,is_dressed,is_girl,bag_sprite,velocity,target_position)	
		
	#Cambiar los cuadros de animación del player.
	if position.distance_to(target_position) <= 10:
		sprite.stop()
	else:
		sprite.play()
		
	
		
	
			
	
	if is_warchief:
		var self_heal_timer=get_tree().create_timer(1.0).connect("timeout",self,"decrease_heal_counter")
		

			


	if can_heal_itself:
		self_heal()

	if health>MAX_HEALTH:
		health=MAX_HEALTH
		can_heal_itself=false
		heal_counter=60
			
	
	
		

	var shoot_timer=get_tree().create_timer(2.0).connect("timeout",self,"enable_shot")
		

	
		
	
	if is_warchief && can_heal_another:
		if body_entered!=null && is_instance_valid(body_entered):
			if "Citizen" in body_entered.name || "Warrior" in body_entered.name && !("Enemy" in body_entered.name):
				heal(body_entered)
	
	heal_timer.start()
	pickable_timer.start()
		
	
		
	
		
func _collect_pickable(var _pickable):
	if _pickable.type == "fruit_tree" or _pickable.type == "pine_tree" or _pickable.type == "plant" or _pickable.type == "quarry" or _pickable.type == "copper":
		if _pickable.touching && !_pickable.empty && pickable_touching:
			if((abs(position.x-_pickable.position.x)<50)&&
			(abs(position.y-_pickable.position.y)<50)):
				if _pickable.type=="fruit_tree":
					if(has_bag):
						if(_pickable.points>=4):
							Globals.food_points +=4
							_pickable.points-=4
						else:
							Globals.food_points += _pickable.points
							_pickable.points = 0
					else:					
						Globals.food_points +=1
						_pickable.points-=1
						#if _pickable.points <= 0:
						#_pickable.empty = true
				elif _pickable.type == "pine_tree":
					if(Globals.is_stone_weapons_developed):
						if(_pickable.points>=4):
							Globals.wood_points +=4
							_pickable.points-=4
						else:
							Globals.wood_points += _pickable.points
							_pickable.points = 0
					else:					
						Globals.wood_points +=1
						_pickable.points-=1
				elif _pickable.type == "plant":
					if(has_bag):
						if(_pickable.points>=4):
							Globals.leaves_points +=4
							_pickable.points-=4
						else:
							Globals.leaves_points+=_pickable.points
							_pickable.points=0
					else:
						Globals.leaves_points+=1
						_pickable.points-=1
				elif _pickable.type == "quarry":
					if(Globals.is_stone_weapons_developed):
						if(_pickable.points>=4):
							Globals.stone_points+=4
							_pickable.points-=4
						else:
							Globals.stone_points+=_pickable.points
							_pickable.points=0
					else:
						Globals.stone_points+=1
						_pickable.points-=1
				elif _pickable.type == "copper":
					if(Globals.is_stone_weapons_developed):
						if(_pickable.points>=4):
							Globals.copper_points+=4
							_pickable.points-=4
						else:
							Globals.copper_points+=_pickable.points
							_pickable.points=0
					else:
						Globals.copper_points+=1
						_pickable.points-=1
			if _pickable.points <= 0:
				_pickable.empty = true	
	else:
		if _pickable.touching && pickable_touching:
			if _pickable.type == "puddle" && puddle_touching:
				Globals.clay_points+=4
			elif _pickable.type == "lake" && lake_touching:
				if tree.name == "Game2":
					if Globals.is_claypot_made:
						Globals.water_points+=4
					else:
						tree.prompts_label.text="Debes desarrollar el cuenco de barro \n para poder transportar agua."
				else:
					Globals.water_points+=4
				
func _get_rain_damage():	
	if tree.its_raining:
		if (!is_sheltered):
			if(health>0):
				if(!is_dressed):
					health-=MAX_ENERGY_LOSS
				else:
					health-=MIN_ENERGY_LOSS
				bar.value=health
				
			else:
				_set_selected(false)			
				is_deleted=true
		else:				
			if(health<MAX_HEALTH):
				health+=MAX_ENERGY_LOSS
				bar.value=health
					
		
func _get_damage(var _collider):
	if _collider!=null && is_instance_valid(_collider):
		if "Tiger" in _collider.name && _collider.visible && is_enemy_touching:
			if is_warchief:
				if(health>0):
					health-=MIN_ENERGY_LOSS
					bar.value=health
					
				else:
					_set_selected(false)			
					is_deleted=true	
			else:
				if(health>0):
					health-=MAX_ENERGY_LOSS
					bar.value=health
					
				else:
					_set_selected(false)			
					is_deleted=true
		if "Mammoth" in _collider.name && is_enemy_touching:
			if health>0:
				health-=(MAX_ENERGY_LOSS+15)
				bar.value=health
				
			else:
				_set_selected(false)			
				is_deleted=true
		if "EnemySpear" in _collider.name:
			if health>0:
				health-=MIN_ENERGY_LOSS
				bar.value=health
				
			else:
				_set_selected(false)			
				is_deleted=true		
		if "Stone" in _collider.name && _collider.owner_name=="EnemyCitizen":
			if health>0:
				health-=MIN_ENERGY_LOSS
				bar.value=health
				
			else:
				_set_selected(false)			
				is_deleted=true				
	

		
		
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
		




func _on_fruit_tree_fruit_tree_entered():
	can_add = true
	is_sheltered = true		

func _on_fruit_tree_fruit_tree_exited():
	can_add = false
	is_sheltered = false

	
func _set_puddle_touching(var _puddle):
	puddle_touching=_puddle
	


func _set_lake_touching(var _lake):
	lake_touching=_lake

func _set_pickable_touching(var _pickable):
	pickable_touching=_pickable
	
func _set_pickable(_pickable):
	pickable=_pickable	

func _set_its_raining(var _its_raining):
	its_raining = _its_raining
	
func _set_erased(var _is_dead):
	is_dead=_is_dead
	




#########TIMER FUNCTIONS################
func decrease_heal_counter():
	if health<MAX_HEALTH && heal_counter>0:
		heal_counter-=1
		if heal_counter<=0:
			can_heal_itself=true

func enable_heal(_can_heal_another):
	_can_heal_another=!_can_heal_another

func enable_shot():
	can_shoot=!can_shoot
	
func enable_pickable():
	if pickable!=null:
		_collect_pickable(pickable)
	
		
func heal(_body):
	if _body.health<_body.MAX_HEALTH:
		_body.health+=5
		_body.bar.value=_body.health
		can_heal_another=false
		return
				
				
		
	if _body.health>_body.MAX_HEALTH:
		_body.health=_body.MAX_HEALTH
			
	can_heal_another=false
			
		
		
		
			
func self_heal():	
	if health<MAX_HEALTH:
		health+=5
		bar.value=health
		
		
		
		



func _shoot():
	
	if is_warchief || is_general:
		var bullet_target = tree.touching_enemy.position
		shoot_node.look_at(bullet_target)				
		var angle = shoot_node.rotation
		var forward = Vector2(cos(angle),sin(angle))
		var the_tilemap=get_tree().get_nodes_in_group("tilemap")
		var spear_count=0
		for tilemap_child in the_tilemap[0].get_children():
			if "Bullet" in tilemap_child.name:
				spear_count+=1
		if spear_count<2:
			spear = spear_scene.instance()
			shoot_point.rotation = angle				
			spear.position = Vector2(shoot_point.global_position.x,shoot_point.global_position.y)
			spear.set_dir(forward)
			spear.rotation = angle
			spear.owner_name="Citizen"
			the_tilemap[0].add_child(spear)
		
	
	else:
		target_position = tree.touching_enemy.position
		shoot_node.look_at(target_position)
		var angle
		if target_position.x<position.x:
			angle=1/2*(1/2*sin((target_position.x-position.x)*9.8/-200))+shoot_node.rotation
		else:
			angle=1/2*(1/2*sin((target_position.x-position.x)*9.8/200))+shoot_node.rotation
		var new_stone = stone_scene.instance()
		new_stone.owner_name="Citizen"
		shoot_point.rotation = angle				
		new_stone.position = Vector2(shoot_point.global_position.x,shoot_point.global_position.y)
		if target_position.x<position.x:
			new_stone.set_velocity(Vector2(-100,-100))
		else:
			new_stone.set_velocity(Vector2(100,-100))
		new_stone.rotation = angle		
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
			

	
	


func _on_Area2D_body_entered(body):
	body_entered=body





func _on_Area2D_body_exited(body):
	body_entered=null

