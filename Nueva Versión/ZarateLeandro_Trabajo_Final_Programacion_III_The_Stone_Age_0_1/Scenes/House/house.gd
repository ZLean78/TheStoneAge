extends Node2D


var condition=0
onready var root=get_tree().root.get_child(0)
onready var units=get_tree().root.get_child(0).get_node("Units")
onready var timer=$Timer
onready var bar=$Bar


	
	
func _process(delta):
	for citizen in units.get_children():
		if citizen.house_entered:
			_house_build()
		bar.value=condition

func _house_build():
	if condition<20 && root.wood_points>0 && root.clay_points>0:
		if timer.is_stopped():
			condition+=1
			root.wood_points-=1
			root.clay_points-=2
			timer.start()


func _on_Area2D_body_entered(body):
	if "Unit" in body.name:
		body.house_entered=true





func _on_Area2D_body_exited(body):
	if "Unit" in body.name:
		body.house_entered=false
