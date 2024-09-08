extends "res://Scenes/Unit/Unit.gd"

#Proyectil, piedra para lanzar al enemigo.
var bullet
export var bullet_scene=preload("res://Scenes/Bullet/Bullet.tscn")



onready var all_timer = $all_timer





#Variable que indica si el jugador debe moverse.
var move_p = false
#Vector2 que indica cuánto debe moverse el jugador.
var to_move = Vector2()

#Posición inicial, se actualiza cada vez que hacemos click con el botón derecho.
var initialPosition = Vector2()

#Puntos de comida de la unidad.
var food_points = 0

#Variable que indica si se está arrastrando el mouse sobre la unidad.
var dragging = true


var is_chased = false
#var click_relative = 16
#Indica si la unidad ha muerto.
var dead = false
var collision 



#Variables agregadas
#var device_number = 0
##!!!!
#var motion = Vector2()
#

#Indica si la unidad se encuentra bajo refugio.
var is_sheltered = false
#Indica si la unidad es o no mujer.
var is_girl = false
#Indica si la unidad está vestida (tiene túnica de hojas o no).
var is_dressed = false
#Indica si tiene cesta de hojas o no.

#Indica si la unidad ha sido eliminada o no.
var is_erased = false



#Indica si la unidad puede agregar puntos de comida o no.
var can_add = false
#Indica si la unidad puede agregar puntos de hojas.
var can_add_leaves = false

#var can_add_multiple = false

#Indica si está lloviendo para la unidad.
var its_raining = false

#Vector2 que indica el tamaño de la pantalla.
var screensize = Vector2(ProjectSettings.get("display/window/size/width"),ProjectSettings.get("display/window/size/height"))

#Indica si la unidad está tocando un tigre
var is_enemy_touching=false

#Tigre que la unidad está tocando
var tiger = null




#Para saber si la unidad ha sido eliminada.
var is_deleted=false





var direction = Vector2.ZERO

#Variables origen y destino de navegación.
var firstPoint = Vector2.ZERO
var secondPoint = Vector2.ZERO
var index = 0

#Polígono de navegación.
onready var nav2d





##Señal de cambio de salud (incremento o decremento).
#signal health_change
##Señal de que la unidad ha muerto.
#signal im_dead
##signal food_points_change




func _ready():
	tree=Globals.current_scene
	SPEED=100.0
	MAX_HEALTH=100.0
	health=MAX_HEALTH
	velocity=Vector2()
	target_position=Vector2()
	bar=$Bar
	foot=$Foot
	path=PoolVector2Array()
	sprite=get_node("scalable/sprite")
	shoot_node=$shootNode
	shoot_point=$shootNode/shootPoint
	is_flipped=false
	timer_count=1
	nav2d=tree.get_node("nav")
#	connect("was_selected",tree,"_select_unit")
#	connect("was_deselected",tree,"_deselect_unit")

	
	tree=Globals.current_scene
	nav2d=tree.get_node("nav")
	
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
	
	bar.value=MAX_HEALTH
	bar.visible = true
	foot.visible = false
	
	

	

func _set_selected(value):
	if selected != value:
		selected = value
		foot.visible = value
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
		if foot.visible == false:
			foot.visible = true
	else:
		if foot.visible == true:
			foot.visible = false
	
	if target_position!=Vector2.ZERO:
		if position.distance_to(target_position) > 10:
			#_move_to_target(target_position)
			_move_along_path(SPEED*delta)
		else:
			velocity=Vector2.ZERO
	
	
		
	
	# Orientar al warrior.
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
	
	
		

		
		
	if(all_timer.is_stopped()):
		all_timer.start()



		
func _get_damage(var body):
	if "Tiger" in body.name && body.visible:
		if(health>0):
			health-=5
			bar.value=health
			
		else:
			_set_selected(false)			
			is_deleted=true
	if "Mammoth" in body.name && is_enemy_touching:
		if health>0:
			health-=30
			bar.value=health
			
		else:
			_set_selected(false)			
			is_deleted=true	
	if "EnemySpear" in body.name:
		body.queue_free()
		if health>0:
			health-=20
			bar.value=health
			
		else:
			_set_selected(false)			
			is_deleted=true	
		
	
func move_towards(pos,point,delta):
	var v = (point-pos).normalized()
	v *=delta*SPEED
	position += v
	if position.distance_squared_to(point) < 5:
		path.remove(0)
		initialPosition = position
		
func _move_along_path(distance):	
	var last_point=position
	direction=last_point-firstPoint
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
	direction = (target-position)*SPEED
	velocity=(direction*to_delta).normalized()
	collision = move_and_collide(velocity)
	
	if collision != null:
		if "Tiger" in collision.collider.name || "Mammoth" in collision.collider.name || "EnemySpear" in collision.collider.name || ("Stone" in collision.collider.name && collision.collider.owner_name=="EnemyCitizen"):
			is_enemy_touching=true
			
	

func _unhandled_input(event):
	if event.is_action_pressed("RightClick"):
		if tree.sword_mode:
			if tree.touching_enemy!=null:
				if is_instance_valid(tree.touching_enemy):
					#if selected && can_shoot:
					if selected:
						_shoot()
				else:
					if tree.name=="Game3":
						tree._on_Game3_is_arrow()
					elif tree.name=="Game4":
						tree._on_Game4_is_arrow()
					elif tree.name=="Game5":
						tree._on_Game5_is_arrow()
		else:
			_walk()
			
	
	
					
func _on_Unit_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():			
			if event.button_index == BUTTON_LEFT:
				_set_selected(not selected)
				tree._select_last()
				


func _on_Target_Position_body_entered(_body):
	velocity = Vector2(0,0)
	
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
				elif sprite.animation == "male_frontwalk":
					sprite.animation = "male_idle1"
				elif sprite.animation == "male_sidewalk":
					sprite.animation = "male_idle3"
			else:
				if velocity.y < 0:
					if abs(velocity.y) > abs(velocity.x):
						sprite.animation = "male_backwalk"
					else:
						sprite.animation = "male_sidewalk"
				elif velocity.y > 0:
					if abs(velocity.y) > abs(velocity.x):
						sprite.animation = "male_frontwalk"
					else:
						sprite.animation = "male_sidewalk"
				elif velocity.x < 0:
					if abs(velocity.x) > abs(velocity.y):
						sprite.animation = "male_sidewalk"
					else:
						sprite.animation = "male_backwalk"
				elif velocity.x > 0:
					if abs(velocity.x) > abs(velocity.y):
						sprite.animation = "male_sidewalk"
					else:
						sprite.animation = "male_frontwalk"
					
		else:
			if velocity == Vector2(0,0):
				if sprite.animation == "female_backwalk":
					sprite.animation = "female_idle2"
				elif sprite.animation == "female_frontwalk":
					sprite.animation = "female_idle1"
				elif sprite.animation == "female_sidewalk":
					sprite.animation = "female_idle3"	
			else:
				if velocity.y < 0:
					if abs(velocity.y) > abs(velocity.x):
						sprite.animation = "female_backwalk"
					else:
						sprite.animation = "female_sidewalk"
				elif velocity.y > 0:
					if abs(velocity.y) > abs(velocity.x):
						sprite.animation = "female_frontwalk"
					else:
						sprite.animation = "female_sidewalk"
				elif velocity.x < 0:
					if abs(velocity.x) > abs(velocity.y):
						sprite.animation = "female_sidewalk"
					else:
						sprite.animation = "female_backwalk"
				elif velocity.x > 0:
					if abs(velocity.x) > abs(velocity.y):
						sprite.animation = "female_sidewalk"
					else:
						sprite.animation = "female_frontwalk"
#				
	else:
		if(!is_girl):
			if velocity == Vector2(0,0):
				if sprite.animation == "male_backwalk_d":
					sprite.animation = "male_idle2_d"
				elif sprite.animation == "male_frontwalk_d":
					sprite.animation = "male_idle1_d"
				elif sprite.animation == "male_sidewalk_d":
					sprite.animation = "male_idle3_d"
			else:
				if velocity.y < 0:
					if abs(velocity.y) > abs(velocity.x):
						sprite.animation = "male_backwalk_d"
					else:
						sprite.animation = "male_sidewalk_d"
				elif velocity.y > 0:
					if abs(velocity.y) > abs(velocity.x):
						sprite.animation = "male_frontwalk_d"
					else:
						sprite.animation = "male_sidewalk_d"
				elif velocity.x < 0:
					if abs(velocity.x) > abs(velocity.y):
						sprite.animation = "male_sidewalk_d"
					else:
						sprite.animation = "male_backwalk_d"
				elif velocity.x > 0:
					if abs(velocity.x) > abs(velocity.y):
						sprite.animation = "male_sidewalk_d"
					else:
						sprite.animation = "male_frontwalk_d"
		else:
			if velocity == Vector2(0,0):
				if sprite.animation == "female_backwalk_d":
					sprite.animation = "female_idle2_d"
				elif sprite.animation == "female_frontwalk_d":
					sprite.animation = "female_idle1_d"
				elif sprite.animation == "female_sidewalk_d":
					sprite.animation = "female_idle3_d"	
			else:
				if velocity.y < 0:
					if abs(velocity.y) > abs(velocity.x):
						sprite.animation = "female_backwalk_d"
					else:
						sprite.animation = "female_sidewalk_d"
				elif velocity.y > 0:
					if abs(velocity.y) > abs(velocity.x):
						sprite.animation = "female_frontwalk_d"
					else:
						sprite.animation = "female_sidewalk_d"
				elif velocity.x < 0:
					if abs(velocity.x) > abs(velocity.y):
						sprite.animation = "female_sidewalk_d"
					else:
						sprite.animation = "female_backwalk_d"
				elif velocity.x > 0:
					if abs(velocity.x) > abs(velocity.y):
						sprite.animation = "female_sidewalk_d"
					else:
						sprite.animation = "female_frontwalk_d"

	

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





func _on_player_mouse_entered():
	selected = true



	
func _set_erased(var _is_erased):
	is_erased=_is_erased
	


#	
func _on_all_timer_timeout():
	#timer_count+=1	
	#if tiger!=null && is_instance_valid(tiger):
		#_get_damage(tiger)
	if body_entered!=null && is_instance_valid(body_entered):
		#if "Tiger" in body_entered.name || "Mammoth" in body_entered.name:
		_get_damage(body_entered)
#	if timer_count>=3:
#		can_shoot=true
#	else:
#		can_shoot=false
#	if timer_count>4:
#		timer_count=0
	all_timer.start()
	
	

func _die():
	queue_free()

func _on_Area2D_body_entered(body):
	body_entered=body
	

func _shoot():
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
		bullet = bullet_scene.instance()
		shoot_point.rotation = angle				
		bullet.position = Vector2(shoot_point.global_position.x,shoot_point.global_position.y)
		bullet.set_dir(forward)
		bullet.rotation = angle
		bullet.owner_name="Warrior"
		#target_position=bullet_target		
		the_tilemap[0].add_child(bullet)
	
	
func _walk():
	firstPoint = global_position	
	secondPoint = target_position		
	var arrPath: PoolVector2Array = nav2d.get_simple_path(firstPoint,secondPoint,true)
	firstPoint = arrPath[0]
	path = arrPath
	index = 0		


