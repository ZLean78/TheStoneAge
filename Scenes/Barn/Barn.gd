extends Node2D


export var condition=0
export var condition_max=0
onready var tree
onready var citizens
onready var timer=$Timer
#onready var all_timer=get_tree().root.get_child(0).get_node("food_timer")
onready var bar=$Bar
onready var polygon=$CollisionPolygon2D 
var mouse_entered=false
var body_entered
var can_make_attack=true



# Called when the node enters the scene tree for the first time.
func _ready():
	tree=Globals.current_scene
	citizens=tree.get_node("Citizens")
	timer.start()


func _process(_delta):
	bar.value=condition
	if body_entered!=null:
		_get_damage(body_entered)
	
func _barn_build():
	if condition<condition_max:
		condition+=1
	else:
		Globals.is_barn_built=true
		tree._check_victory()
		if tree.name=="Game4" && !tree.victory_obtained && can_make_attack:
			tree._check_buildings()
			can_make_attack=false


func _on_Area2D_body_entered(body):
	if "Citizen" in body.name:
		body.barn_entered=true
	if "EnemySpear" in body.name:
		body_entered=body


func _on_Area2D_body_exited(body):
	if "Citizen" in body.name:
		body.barn_entered=false
		
func _get_damage(body):
	if is_instance_valid(body):
		if "EnemySpear" in body.name:
			condition-=3
			if condition<0:
				polygon.visible=false
				Globals.is_barn_built=false
				queue_free()
				tree.emit_signal("remove_building")
	else:
		body_entered=null


func _on_Timer_timeout():
	for a_citizen in citizens.get_children():
		if a_citizen.barn_entered && a_citizen.position.distance_to(self.position)<70:
			_barn_build()
	if body_entered!=null && is_instance_valid(body_entered):
		_get_damage(body_entered)
	timer.start()
	
		


func _on_Barn_mouse_entered():
	mouse_entered=true


func _on_Barn_mouse_exited():
	mouse_entered=false
