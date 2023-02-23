extends KinematicBody2D


export var path_to_unit=NodePath()

var velocity = Vector2.ZERO

onready var agent: NavigationAgent2D = $tiger_agent
var unit
var units = []
onready var move_timer = $move_timer

var is_flipped = false

func _ready():
	unit = get_tree().root.get_child(0).find_node("Unit2")
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
		if(is_flipped==false):			
			scale.x = -1
			is_flipped = true
	if velocity.x>0:
		if(is_flipped==true):			
			scale.x = 1
			is_flipped = false
	
func update_pathfinding():
	#agent.set_target_location(unit.global_position)
	
	for a_unit in get_tree().root.get_child(0).all_units:
		#if(abs(position.distance_to(a_unit.position))<20):
		if a_unit:
			agent.set_target_location(a_unit.global_position)
			


func _on_Area2D_body_entered(body):
	if(body.name=="Unit2"):
		body.is_tiger_touching=true


func _on_Area2D_body_exited(body):
	if(body.name=="Unit2"):
		body.is_tiger_touching=false
