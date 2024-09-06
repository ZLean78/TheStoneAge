extends KinematicBody2D


var direction=Vector2()

#Variables origen y destino de navegación.
var firstPoint = position
var index = 0

var target_position = Vector2.ZERO
var velocity = Vector2()
var selected=false
var to_delta=0.0
var is_flipped=false
var can_shoot=true
var just_shot=false

#Salud de la unidad.
export (float) var health = 100


onready var nav2d
onready var sprite
onready var bar
onready var foot=$Selected
onready var shootNode=$scalable/shootNode
onready var shootPoint=$scalable/shootNode/shootPoint

export (PackedScene) var stone_scene

export (float) var SPEED = 100.0
var tree
var path=PoolVector2Array()

#Señales que informan si la unidad ha sido seleccionada o desseleccionada.
signal was_selected
signal was_deselected

#Para saber si la unidad ha sido eliminada.
var is_deleted=false
var distance=Vector2.ZERO
var mouse_entered=false
var shootTimer=0
var shootEveryXSecond=2
func _ready():
	health=100
	bar=$Bar
	foot=$Selected
	SPEED=100.0
	bar.value=health
	tree=Globals.current_scene
	sprite=$scalable/Sprite
	selected=false
	to_delta=0.0
	nav2d=tree.get_node("nav")
	foot=$Selected
	tree=Globals.current_scene
	nav2d=tree.get_node("nav")
	connect("was_selected",tree,"_select_unit",[self])
	connect("was_deselected",tree,"_deselect_unit",[self])
	target_position=get_parent().get_tree().root.get_child(3).townhall.position
	target_position.x-=130
	target_position.y+=35

	

func _physics_process(delta):
	to_delta=delta
		
	if selected:
		bar.visible = true
		foot.visible = true
	else:
		bar.visible = false
		foot.visible = false
	
	shootTimer-=delta
	if target_position!=null:
		if position.distance_to(target_position) >= 5:
			_create_path(target_position)	
		
	
	if position.distance_to(target_position) >= 5:
		_move_along_path(SPEED*delta)
	else:
		velocity=Vector2.ZERO
#		get_tree().create_timer(1.0).connect("timeout",self,"_shoot")
		if (shootTimer <= 0):
			_shoot()
			shootTimer = shootEveryXSecond
		
		
		
	
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
	$Animation._animate(sprite,velocity,target_position)	
		
	#Cambiar los cuadros de animación del player.
	if position.distance_to(target_position) < 5:
		sprite.play()
	else:
		sprite.stop()
	
	$Bar.value=health
	

		
func _move_along_path(speed):	
	var last_point=position
	
	while path.size():		
		var distance_between_points = last_point.distance_to(path[0])
		if distance_between_points>10:
			position=lerp(last_point,path[0],speed/distance_between_points)
			return
		
#		speed-=distance_between_points
#		last_point=path[0]
		position=path[0]
		path.remove(0)
		
		set_process(false)



func _create_path(target_position):
	var arrPath: PoolVector2Array = nav2d.get_simple_path(position,target_position,true)
	path = arrPath


func _shoot():
	if is_instance_valid(get_parent().get_tree().root.get_child(3).townhall):	
		var target_position=get_parent().get_tree().root.get_child(3).townhall.position	
		var shotHeight = 50
		var distX = abs(target_position.x-shootPoint.global_position.x)
		var distY = abs(target_position.y-shootPoint.global_position.y) + shotHeight
		var vy = sqrt(2*9.8*distY)
		var travelTime = vy/4.9
		var vx = distX/travelTime
		vx*=7.05
		vy*=5	
		var new_stone = stone_scene.instance()
		new_stone.owner_name="Catapult"
		new_stone.position = Vector2(shootPoint.global_position.x,shootPoint.global_position.y)
		if target_position.x<position.x:
			new_stone.set_velocity(Vector2(-vx,-vy))
		else:
			new_stone.set_velocity(Vector2(vx,-vy))
		var the_tilemap=get_tree().get_nodes_in_group("tilemap")
		the_tilemap[0].add_child(new_stone)
		can_shoot=false
		just_shot=true

func _set_selected(value):
	if selected!=value:
		selected=value

		bar.visible = value
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
	


func _on_Vehicle_was_selected():
	tree._select_unit(self)
	


func _on_all_timer_timeout():
	can_shoot=true


func _on_Sprite_animation_finished():
	just_shot=false
	$Animation._animate(sprite,velocity,target_position)

func _get_damage(body):
	health-=3
	if health<=0:
		queue_free()


func _on_Area2D_mouse_entered():
	mouse_entered=true
	tree._on_Game5_is_sword()
	tree.touching_enemy=self


func _on_Area2D_mouse_exited():
	mouse_entered=true
	tree._on_Game5_is_sword()
	tree.touching_enemy=null


func _on_Area2D_body_entered(body):
	if "Bullet" in body.name || ("Stone" in body.name && body.owner_name=="Citizen"):
		_get_damage(body)


func _on_Area2D_body_exited(body):
	pass # Replace with function body.
