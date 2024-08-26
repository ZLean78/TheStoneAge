extends StaticBody2D


export var condition=0
export var condition_max=0
onready var tree
onready var citizens
onready var timer=$Timer
#onready var all_timer=get_tree().root.get_child(0).get_node("food_timer")
onready var bar=$Bar

var mouse_entered=false

func _ready():
	tree=Globals.current_scene
	citizens=tree.get_node("Units")
	
func _process(_delta):
	bar.value=condition

func _townhall_build():
	if condition<condition_max:
		condition+=1	
		
			
			
			


func _on_Area2D_body_entered(body):
	if "Unit" in body.name:
		body.townhall_entered=true





func _on_Area2D_body_exited(body):
	if "Unit" in body.name:
		body.townhall_entered=false


func _on_Timer_timeout():
	for citizen in citizens.get_children():
		if citizen.townhall_entered:
			_townhall_build()
	timer.start()


func _on_Area2D_mouse_entered():
	mouse_entered=true


func _on_Area2D_mouse_exited():
	mouse_entered=false
	
func _get_damage(body):
	if is_instance_valid(body):
		if "EnemySpear" in body.name:
			condition-=3
		if "Stone" in body.name && body.owner_name=="EnemyCitizen":
			condition-=3
	if condition<=0:
		queue_free()



