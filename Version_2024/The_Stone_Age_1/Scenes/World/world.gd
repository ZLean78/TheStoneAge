extends Node2D


var units = []
var houses
var its_raining = false
var time_count = 50
@export var camera: Camera2D
@onready var particles = $GPUParticles2D
@onready var counter_timer = $CounterTimer
@onready var counter_label = $UI/CounterLabel


func _ready():	
	_get_units()
	
func _process(_delta):
	if its_raining:
		counter_label.text = "La lluvia cesará en: " + str(time_count) + " segundos."
	else:
		counter_label.text = "Peligro en: " + str(time_count) + " segundos."
	
	

func _get_units():
	units = null
	units = get_tree().get_nodes_in_group("units")
	
	

		
				

func _on_area_selected(object):
	var start = object.start
	var end = object.end
	var area = []
	area.append(Vector2(min(start.x,end.x),min(start.y,end.y)))
	area.append(Vector2(max(start.x,end.x),max(start.y,end.y)))
	var ut = _get_units_in_area(area)
	for u in units:
		u._set_selected(false)
	for u in ut:
		u._set_selected(!u.selected)

func _get_units_in_area(area):
	var u = []
	for unit in units:
		if (unit.position.x > area[0].x) and (unit.position.x < area[1].x):
			if (unit.position.y > area[0].y) and (unit.position.y < area[1].y):
				u.append(unit)				
	return u


func _on_sub_viewport_container_mouse_entered():
	pass # Replace with function body.


func _on_danger_timer_timeout():
	time_count-=1
	if time_count == 0:
		if !its_raining:
			its_raining=true
			particles.emitting = true	
			time_count=20			
		else:
			its_raining=false
			particles.emitting = false
			time_count=50
			
