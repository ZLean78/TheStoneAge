extends Node2D


export var condition=0
export var condition_max=0
onready var root=get_tree().root.get_child(0)
onready var units=get_tree().root.get_child(0).get_node("Units")
onready var timer=$Timer
#onready var all_timer=get_tree().root.get_child(0).get_node("food_timer")
onready var bar=$Bar
var mouse_entered=false
var body_entered=null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
	bar.value=condition
	
func _tower_build():
	if condition<condition_max:
		condition+=3


func _on_Area2D_body_entered(body):
	body_entered=body
	if "Unit" in body.name:
		body.tower_entered=true
	if "EnemySpear" in body.name:
		body.queue_free()
		condition-=3
		if condition<0:
			queue_free()


func _on_Area2D_body_exited(body):
	if "Unit" in body.name:
		body_entered=null
		body.tower_entered=false


func _on_Timer_timeout():
	for citizen in units.get_children():
		if citizen.tower_entered && citizen.position.distance_to(self.position)<50:
			_tower_build()
	timer.start()


func _on_Tower_mouse_entered():
	mouse_entered=true


func _on_Tower_mouse_exited():
	mouse_entered=false
