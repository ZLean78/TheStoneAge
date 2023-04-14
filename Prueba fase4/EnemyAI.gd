extends Node2D

const SPEED=100.0
var velocity = Vector2()
onready var agent: NavigationAgent2D = $AI_agent
onready var move_timer = $move_timer

export (PackedScene) var CivilizationMetrics
onready var root=get_tree().root.get_child(0)
onready var camera=root.get_node("Camera")


enum States {
	IDLE,
	MOVING,
	ATTACKING,
	DEAD
}

var current_state=States.MOVING
var all_units=[]
var all_enemy_units=[]

# Called when the node enters the scene tree for the first time.
func _ready():
	
	all_units=root.all_units
	
	for i in range(0,11):
		var enemy_unit = root.Unit2.instance()
		enemy_unit.faction_type=2
		all_enemy_units.append(enemy_unit)
	
	
		root.get_node("TileMap").add_child(enemy_unit)
		call_deferred("_set_enemy_unit_position",enemy_unit)
	

func _physics_process(delta):
	
	_FSM()
	
		
	
func _FSM():
	# Lógica de la FSM
	match current_state:
		States.IDLE:
			#call_deferred("_set_enemy_unit_target",enemy_unit,enemy_unit.position)	
			for i in range(0,11):	
				_set_enemy_unit_target(all_enemy_units[i],all_enemy_units[i].position)
			pass	
		States.MOVING:
		
			if agent.is_navigation_finished():
				return
	
			for i in range(0,all_enemy_units.size()):
				var direction = all_enemy_units[i].global_position.direction_to(agent.get_next_location())
	
				velocity = all_enemy_units[i].move_and_slide(velocity)
				all_enemy_units[i].velocity=velocity
	
				var desired_velocity = direction * SPEED 
				var steering = (desired_velocity - velocity) 
				velocity += steering
	
	

	
#			#animar al personaje
			
	
				#Cambiar los cuadros de animación de la unidad enemiga.
				if all_enemy_units[i].velocity.length()>0:
					all_enemy_units[i].velocity = all_enemy_units[i].velocity.normalized()*50.0
				
					# Orientar la unidad.
					if all_enemy_units[i].velocity.x<0:
						all_enemy_units[i].get_node("scalable").scale.x=-1
					else:
						all_enemy_units[i].get_node("scalable").scale.x=1
			
					for tree in root.all_trees:
						if all_enemy_units[i].position.distance_to(tree.position)<170:
						
							var the_tree = tree
							all_enemy_units[i].target_position=the_tree.position

							if all_enemy_units[i].position.distance_to(the_tree.position)>0:
								update_pathfinding(the_tree.position)	
							
#							if !enemy_unit.sprite.is_playing():
#								enemy_unit.sprite.play(enemy_unit.sprite.animation)
						else:
							update_pathfinding(all_enemy_units[i].target_position)
						
			pass		
		States.ATTACKING:
			# Comportamiento del estado ATTACKING
			pass
		States.DEAD:
			# Comportamiento del estado DEAD
			pass


func _set_enemy_unit_position(_enemy_unit):
	_enemy_unit.position = Vector2(camera.position.x,camera.position.y)

func _set_enemy_unit_target(_enemy_unit,_enemy_unit_position):
	_enemy_unit.target_position = _enemy_unit_position
	
func update_pathfinding(_position):
	for i in range(0,all_enemy_units.size()):
		if all_enemy_units[i].position.distance_to(_position)<170 && all_enemy_units[i].position.distance_to(_position)>=10:		
			agent.set_target_location(_position)
		elif all_enemy_units[i].position.distance_to(_position)>170:
			agent.set_target_location(Vector2(-937,-520))
		else:
			current_state = States.IDLE
