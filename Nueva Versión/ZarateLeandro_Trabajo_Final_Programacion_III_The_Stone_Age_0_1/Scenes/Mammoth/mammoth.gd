extends KinematicBody2D

var start_position
var state=0
var target_position=Vector2()
var body_entered
var velocity=Vector2()
var is_dead=false
var speed=50.0
var life=120
onready var progress_bar=$ProgressBar
export var is_flipped:bool
onready var warriors=get_tree().get_root().get_child(0).get_node("Warriors")
onready var citizens=get_tree().get_root().get_child(0).get_node("Units")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	start_position=position
	progress_bar.value = life
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
					get_tree().root.get_child(0).food_points+=90
					get_tree().root.get_child(0).wood_points+=60
					get_tree().root.get_child(0).stone_points+=40
					is_dead=true
					queue_free()
	
	#Actualizar barra de vida.
	progress_bar.value=life
		
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
			if body_entered!=null && is_instance_valid(body_entered):
				target_position=body_entered.position
		2:
			target_position=start_position
			if position.distance_to(target_position)<=5:
				state=0
				


func _on_Area2D_body_entered(body):
	if "Bullet" in body.name || "Stone" in body.name:
		life-=5
		body.queue_free()
		if life <=0:
			is_dead=true
			queue_free()
	
				


func _on_Mammoth_mouse_entered():
	get_tree().get_root().get_child(0)._on_Game3_is_sword()
	get_tree().root.get_child(0).emit_signal("is_sword")
	get_tree().root.get_child(0).touching_enemy=self



func _on_Mammoth_mouse_exited():
	get_tree().get_root().get_child(0)._on_Game3_is_arrow()



	


func _on_DetectionArea_body_entered(body):
	if "Warrior" in body.name || "Unit2" in body.name:
		body_entered=body
		for mammoth in get_parent().get_children():
			if is_instance_valid(mammoth):
				mammoth.state = 1
