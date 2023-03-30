extends KinematicBody2D

var velocity = Vector2.ZERO

export var life=100

onready var agent: NavigationAgent2D = $tiger_agent
var unit
var units = []

onready var move_timer = $move_timer

var is_flipped = false
var is_chasing = false
var is_dead = false

signal tiger_entered
signal tiger_exited




func _ready():
	move_timer.connect("timeout",self,"update_pathfinding")
	
#	
func _physics_process(delta):
	if agent.is_navigation_finished():
		return
		
	var direction = global_position.direction_to(agent.get_next_location())
	
	var desired_velocity = direction * 50.0
	var steering = (desired_velocity - velocity) * delta * 4.0
	velocity += steering
	
	velocity = move_and_slide(velocity)
	
	# Orientar al tigre.
	if velocity.x<0:
		$AnimatedSprite.flip_h=true
	else:
		$AnimatedSprite.flip_h=false
			
	
	if is_dead==true:
		visible=false	
			
	
func update_pathfinding():
	if !is_dead:
		if unit!=null && abs(position.distance_to(unit.global_position))<400:		
			agent.set_target_location(unit.global_position)
		elif unit!=null && abs(position.distance_to(unit.global_position))>400:
			unit.is_chased=false
			unit=null
			is_chasing=false
			agent.set_target_location(Vector2(-937,-520))
		



func _on_Area2D_body_entered(body):
	if is_chasing:
		if "Unit" in body.name:
			body.is_tiger_touching=true 
			body.tiger=self
			emit_signal("tiger_entered")
		elif "Bullet" in body.name:
			body.visible=false
			life-=5
			if life <=0:
				is_dead=true
				is_chasing=false
				unit.is_chased=false
				unit = null
				


func _on_Area2D_body_exited(body):
	if is_chasing:
		if body==unit:
			body.is_tiger_touching=false
			emit_signal("tiger_exited")


func _on_Area2D_mouse_entered():
	get_tree().root.get_child(0).emit_signal("is_sword")


func _on_Area2D_mouse_exited():
	get_tree().root.get_child(0).emit_signal("is_arrow")
