extends KinematicBody2D


var start_position
var state=0
var target_position=Vector2()
var body_entered
var velocity=Vector2()
var is_dead=false
var speed=35.0
var life=100

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
	if position.distance_to(target_position)>5:
		var direction=(target_position-position)
		velocity=direction.normalized()*speed*delta
		
		var collision = move_and_collide(velocity)

		if collision!=null && is_instance_valid(collision.collider):
			if "Bullet" in collision.collider.name || "Stone" in collision.collider.name:
				life-=20
				if life <=0:
					is_dead=true
					queue_free()
	
	#Actualizar barra de vida.
	
		
	# Orientar al mamut.
	if velocity.x<0:
		if(is_flipped==false):			
			$Scalable.scale.x = -1
			is_flipped = true
	if velocity.x>0:
		if(is_flipped==true):			
			$Scalable.scale.x = 1
			is_flipped = false
	
func check_state():
	
	match state:
		0:
			target_position=position					
		1: 
			if visible && body_entered!=null && is_instance_valid(body_entered):
				target_position=body_entered.position
		2:
			target_position=start_position
			if position.distance_to(target_position)<=5:
				state=0
				


func _on_Area2D_body_entered(body):
	if "Bullet" in body.name || "Stone" in body.name:
		life-=10
		body.queue_free()
		if life <=0:
			is_dead=true
			queue_free()
	
				


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



