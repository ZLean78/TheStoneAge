extends KinematicBody2D


var start_position
var state=0
var target_position=Vector2()
var body_entered
var velocity=Vector2()
var is_dead=false
var speed=35.0
var life=100
var tiger_number
onready var bar=$ProgressBar

export var is_flipped:bool
onready var warriors=get_tree().get_root().get_child(0).get_node("Warriors")
onready var citizens=get_tree().get_root().get_child(0).get_node("Units")

func _ready():
	
	start_position=position
	
	if is_flipped==false:
		$Scalable.scale.x=1
	else:
		$Scalable.scale.x=-1

func _physics_process(delta):
	
	#Comprobar máquina de estados.
	check_state()
	
	#Mover y comprobar colisiones.
	if visible && position.distance_to(target_position)>5:
		var direction=(target_position-position)
		velocity=direction.normalized()*speed
		
		var collision = move_and_slide(velocity)

#		if collision!=null && is_instance_valid(collision.collider):
#			if "Bullet" in collision.collider.name || "Stone" in collision.collider.name:
#				life-=20
#				if life <=0:
#					is_dead=true
#					queue_free()
	
	#Actualizar barra de vida.
	$ProgressBar.value=life
		
	# Orientar al mamut.
	if velocity.x<0:
		if(is_flipped==false):			
			$Scalable.scale.x = -1
			is_flipped = true
	if velocity.x>0:
		if(is_flipped==true):			
			$Scalable.scale.x = 1
			is_flipped = false
			
			
func _get_damage(var the_beast):
	if "Stone" in the_beast.name:
		the_beast.queue_free()
		if life>0:
			life-=20
	else:
		queue_free()
	
	if "Bullet" in the_beast.name:
		the_beast.queue_free()
		if life>0:
			life-=30
	else:
		queue_free()
		
		
	
func check_state():
	
	match state:
		0:
			if visible:
				if tiger_number==1:
					target_position=get_tree().root.get_child(0).tiger_target.position
				if tiger_number==2:
					target_position=get_tree().root.get_child(0).spawn_position.position
				if tiger_number==3:
					target_position=get_tree().root.get_child(0).tiger_spawn.position
			
		1: 
			if body_entered!=null && is_instance_valid(body_entered):
				if visible && body_entered!=null && is_instance_valid(body_entered):
					target_position=body_entered.position
				if body_entered!=null && position.distance_to(body_entered.position)>400:
					state=2
		2:
			if visible:
				target_position=start_position
				if position.distance_to(target_position)<=5:
					state=0
				


func _on_Area2D_body_entered(body):
	if "Stone" in body.name:
		life-=3
		body.queue_free()
	
	if "Bullet" in body.name:
		life-=10
		body.queue_free()	
	
	if life <=0:
		get_tree().root.get_child(0).food_points+=60
		get_tree().root.get_child(0).wood_points+=40
		get_tree().root.get_child(0).stone_points+=20
		is_dead=true
		queue_free()
	
	if "Unit" in body.name || "Warrior" in body.name:
		body.is_enemy_touching=true
	
				
func _on_Area2D_body_exited(body):
	if "Unit" in body.name || "Warrior" in body.name:
		body.is_enemy_touching=false
	

func _on_Tiger_mouse_entered():
	if get_tree().get_root().get_child(0).name == "Game3":
		get_tree().get_root().get_child(0)._on_Game3_is_sword()
	if get_tree().get_root().get_child(0).name == "Game2":
		get_tree().get_root().get_child(0)._on_Game2_is_sword()
	get_tree().root.get_child(0).emit_signal("is_sword")
	get_tree().root.get_child(0).touching_enemy=self



func _on_Tiger_mouse_exited():
	if get_tree().get_root().get_child(0).name == "Game3":
		get_tree().get_root().get_child(0)._on_Game3_is_arrow()
	if get_tree().get_root().get_child(0).name == "Game2":
		get_tree().get_root().get_child(0)._on_Game2_is_arrow()



	


func _on_DetectionArea_body_entered(body):
	if "Warrior" in body.name || "Unit2" in body.name:
		body_entered=body
		for tiger in get_parent().get_children():
			if tiger.visible && is_instance_valid(tiger):
				tiger.state = 1






