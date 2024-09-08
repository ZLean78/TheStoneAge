extends StaticBody2D


export var condition=0
export var condition_max=0
onready var tree
onready var citizens
onready var timer=$Timer
onready var polygon=$CollisionPolygon2D
onready var bar=$Bar
var mouse_entered=false


func _ready():
	tree=Globals.current_scene	
	citizens=tree.get_node("Citizens")
	
func _process(_delta):
	bar.value=condition

func _build():
	if condition<condition_max:
		condition+=1	
		
			


func _on_Area2D_body_entered(body):
	if "Citizen" in body.name:
		body.house_entered=true
	if ("Citizen" in body.name || "Spear" in body.name) && "Enemy" in body.owner_name && !("Townhall" in self.name):
		_get_damage(body)

func _on_Area2D_body_exited(body):
	if "Citizen" in body.name:
		body.house_entered=false


func _on_Timer_timeout():
	for citizen in citizens.get_children():
		if citizen.house_entered && citizen.position.distance_to(self.position)<150:
			_build()
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
		





