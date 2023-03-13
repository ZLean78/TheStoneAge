extends KinematicBody2D

var velocity = Vector2.ZERO

onready var agent: NavigationAgent2D = $tiger_agent
var unit
var units = []
onready var move_timer = $move_timer

var is_flipped = false
var is_chasing = false

signal tiger_entered
signal tiger_exited

func _ready():
	#unit = get_tree().root.get_child(0).find_node("Unit2")
	#agent.set_target_location(unit.global_position)
	move_timer.connect("timeout",self,"update_pathfinding")
	
#	for a_unit in units:
#		if(position.distance_to(a_unit)<20):
#			agent.set_target_location(a_unit.global_position)
#			move_timer.connect("timeout",self,"update_pathfinding")

func _physics_process(delta):
	if agent.is_navigation_finished():
		return
		
	var direction = global_position.direction_to(agent.get_next_location())
	
	var desired_velocity = direction * 50.0
	var steering = (desired_velocity - velocity) * delta * 4.0
	velocity += steering
	
	velocity = move_and_slide(velocity)
	
	# Orientar al player.
	if velocity.x<0:
		$AnimatedSprite.flip_h=true
	else:
		$AnimatedSprite.flip_h=false
			
	
		
			
	
func update_pathfinding():
	if unit!=null && abs(position.distance_to(unit.global_position))<400:		
		agent.set_target_location(unit.global_position)
	elif unit!=null && abs(position.distance_to(unit.global_position))>400:
		unit.is_chased=false
		unit=null
		is_chasing=false
		agent.set_target_location(Vector2(-937,-520))
		
	
#	for a_unit in get_tree().root.get_child(0).all_units:
#		#if(abs(position.distance_to(a_unit.position))<20):
#		if a_unit:
#			agent.set_target_location(a_unit.global_position)
			

#

			





	


func _on_Area2D_body_entered(body):
	if is_chasing:
		if body==unit:
			body.is_tiger_touching=true 
			emit_signal("tiger_entered")


func _on_Area2D_body_exited(body):
	if is_chasing:
		if body==unit:
			body.is_tiger_touching=false
			emit_signal("tiger_exited")
