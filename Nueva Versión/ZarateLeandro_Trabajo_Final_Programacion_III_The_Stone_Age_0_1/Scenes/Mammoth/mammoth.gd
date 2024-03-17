extends KinematicBody2D

var start_position
var state=0
var target_position=Vector2()
var body_entered
var velocity=Vector2()
var speed=50.0
export var is_flipped:bool


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	start_position=position
	if is_flipped==false:
		$Scalable.scale.x=1
	else:
		$Scalable.scale.x=-1

func _physics_process(delta):
	
	check_state()
	
	if position.distance_to(target_position)>5:
		var direction=(target_position-position)
		velocity=direction.normalized()*speed*delta
		
		var collision = move_and_collide(velocity)

		#if collision != null:
			#if "Unit" in collision.collider.name || "Warrior" in collision.collider.name:
				#collision.collider._get_damage()
		
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
			if body_entered!=null && !body_entered.dead:
				target_position=body_entered.position
				if position.distance_to(body_entered.position) > 400:
					state=2
					body_entered=null
		2:
			target_position=start_position
			if position.distance_to(target_position)<=5:
				state=0
				


func _on_Area2D_body_entered(body):
	if "Unit" in body.name || "Warrior" in body.name:
		body_entered=body
		state=1
