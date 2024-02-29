extends CharacterBody2D

@export var selected = false
@onready var box = get_node("Box")
@onready var navreg = get_tree().get_root().get_node("MainScene/SubViewportContainer/SubViewport/World/NavigationRegion2D")

@onready var target = position
@onready var navi = $NavigationAgent2D
var follow_cursor = false
var speed = 100.0
var direction = Vector2.ZERO
var path = []
var map 
var initialPosition = Vector2.ZERO

func _ready():
	_set_selected(selected)
	add_to_group("units")
	setup_navserver()
	#call_deferred("setup_navserver")
	
func _set_selected(value):
	selected = value
	box.visible = value
	
func _unhandled_input(event):
	if selected:
		if not event.is_action_pressed("RightClick"):
			return
		_update_navigation_path(self.position,get_global_mouse_position())

func setup_navserver():
	#Crear un nuevo mapa "navigation map"
	map = NavigationServer2D.map_create()
	NavigationServer2D.map_set_active(map,true)

	#Crear una nueva región de navegación y agregarla al mapa
	var region = NavigationServer2D.region_create()
	NavigationServer2D.region_set_transform(region,Transform2D())
	NavigationServer2D.region_set_map(region,map)
	
	#Configurarle un "navigation mesh" a la región
	var navigation_poly = NavigationMesh.new()
	navigation_poly = navreg.navigation_polygon
	NavigationServer2D.region_set_navigation_polygon(region,navigation_poly)
	
func _update_navigation_path(start_position,end_position):
	path = NavigationServer2D.map_get_path(map,start_position,end_position,true)
	
	"""get_node("../Line2D").clear_points()
	for i in path:
		get_node("../Line2D").add_point(i)"""
	
	path.remove_at(0)
	set_process(true)
	
func _process(delta):
	var walk_distance=100*delta
	_move_along_path(walk_distance)
	
func _move_along_path(distance):
	var last_point = self.position
	while path.size():
		var distance_between_points = last_point.distance_to(path[0])
		if distance <= distance_between_points:
			self.position = last_point.lerp(path[0],distance/distance_between_points)
			return
			
		distance -= distance_between_points
		last_point = path[0]
		path.remove_at(0)
	self.position = last_point
	set_process(false) 
