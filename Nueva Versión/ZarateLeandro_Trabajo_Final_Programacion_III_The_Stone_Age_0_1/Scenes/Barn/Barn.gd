extends Node2D


export var condition=0
export var condition_max=0
onready var root=get_tree().root.get_child(0)
onready var units=get_tree().root.get_child(0).get_node("Units")
onready var timer=$Timer
#onready var all_timer=get_tree().root.get_child(0).get_node("food_timer")
onready var bar=$Bar
var mouse_entered=false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
	bar.value=condition
	
func _barn_build():
	if condition<condition_max:
		condition+=1


func _on_Area2D_body_entered(body):
	if "Unit" in body.name:
		body.barn_entered=true


func _on_Area2D_body_exited(body):
	if "Unit" in body.name:
		body.barn_entered=false


func _on_Timer_timeout():
	for citizen in units.get_children():
		if citizen.barn_entered && citizen.position.distance_to(self.position)<70:
			_barn_build()
	timer.start()


func _on_Barn_mouse_entered():
	mouse_entered=true


func _on_Barn_mouse_exited():
	mouse_entered=false
