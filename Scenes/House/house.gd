extends StaticBody2D


export var condition=0
export var condition_max=0
onready var tree
onready var citizens
onready var timer=$Timer
onready var polygon=$CollisionPolygon2D
#onready var all_timer=get_tree().root.get_child(0).get_node("food_timer")
onready var bar=$Bar
var mouse_entered=false


func _ready():
	tree=Globals.current_scene	
	citizens=tree.get_node("Citizens")
	
func _process(_delta):
	bar.value=condition

func _house_build():
	if condition<condition_max:
		condition+=1	
		
			


func _on_Area2D_body_entered(body):
	if "Citizen" in body.name:
		body.house_entered=true

func _on_Area2D_body_exited(body):
	if "Citizen" in body.name:
		body.house_entered=false


func _on_Timer_timeout():
	for a_citizen in citizens.get_children():
		if a_citizen.house_entered && a_citizen.position.distance_to(self.position)<150:
			_house_build()
	timer.start()

func _get_damage(body):
	if is_instance_valid(body):
		if "Spear" in body.name:
			condition-=3
		if "Stone" in body.name && body.owner_name=="EnemyCitizen":
			condition-=3
	if condition<=0:
		polygon.visible=false
		queue_free()
		tree.emit_signal("remove_building")










