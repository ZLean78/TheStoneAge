extends Node2D


var condition=0
onready var root=get_tree().root.get_child(0)
onready var units=get_tree().root.get_child(0).get_node("Units")
onready var timer=$Timer
#onready var all_timer=get_tree().root.get_child(0).get_node("food_timer")
onready var bar=$Bar


	
	
func _process(delta):
	bar.value=condition

func _townhall_build():
	if condition<80:
		condition+=1	
		
			
			
			


func _on_Area2D_body_entered(body):
	if "Unit" in body.name:
		body.townhall_entered=true





func _on_Area2D_body_exited(body):
	if "Unit" in body.name:
		body.townhall_entered=false


func _on_Timer_timeout():
	for citizen in units.get_children():
		if citizen.townhall_entered:
			_townhall_build()
	timer.start()
