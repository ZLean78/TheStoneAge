extends CharacterBody2D

var selected = false
@onready var box = $Box
@onready var progress_bar = $ProgressBar
@export var navreg: NavigationRegion2D
@export var camera: Camera2D
@onready var main_scene1 = get_tree().get_nodes_in_group("MainScenes")
@onready var viewport = get_tree().get_nodes_in_group("SubViewportContainers")

#@onready var target = position
@onready var navi = $NavigationAgent2D
var follow_cursor = false
var Speed = 100.0
var direction = Vector2.ZERO
var path = PackedVector2Array()
var initialPosition = Vector2.ZERO
var is_sheltered = false
var is_cave_sheltered = false
var health = 100

func _ready():
	_set_selected(selected)
	add_to_group("units")
		
func process(_delta):
	pass

	
func _set_selected(value):
	selected = value
	box.visible = value
	
func _physics_process(_delta:float)->void:	
	if navi.target_position:
		direction = to_local(navi.target_position).normalized()
		velocity = direction * Speed
		if position.distance_to(navi.target_position) > 5:
			move_and_slide()
	
func _make_path():
	navi.target_position = get_global_mouse_position()
	
	

func _input(event):
	if event.is_action_pressed("RightClick") && selected:
		_make_path()	


	"""func _input(event):
	if event.is_action_pressed("RightClick") and selected:
		navi.target_position = get_global_mouse_position()
		

func _physics_process(delta):
	if navi.target_position != Vector2.ZERO:
		direction=global_position.direction_to(navi.target_position)
		var desired_velocity = direction * Speed
		#var steering = (desired_velocity - velocity) * delta * 5.0
		velocity=desired_velocity
		navi.set_velocity(velocity)	
	
	if navi.distance_to_target() > 9:
		move_and_slide()	
	else:
		navi.set_velocity(Vector2.ZERO)"""
		
	






