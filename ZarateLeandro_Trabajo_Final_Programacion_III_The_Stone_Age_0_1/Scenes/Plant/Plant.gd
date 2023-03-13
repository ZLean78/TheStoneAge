extends Node2D

var points = 60
onready var the_sprite = get_child(0)
signal plant_entered
signal plant_exited
var is_touching = false
var is_empty = false




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	_plant_animate()



func _plant_animate():	
	if is_empty == true:
		$AnimationPlayer.play("empty")
	else:
		$AnimationPlayer.play("full")


func _on_Area2D_body_entered(body):
	if("Unit" in body.name):
		is_touching = true
		emit_signal("plant_entered")
		body._set_plant_touching(true)


func _on_Area2D_body_exited(body):
	if("Unit" in body.name):
		is_touching = false
		emit_signal("plant_exited")
		body._set_plant_touching(false)


func _on_Area2D_mouse_entered():
	get_parent().emit_signal("is_basket")
	


func _on_Area2D_mouse_exited():
	get_parent().emit_signal("is_arrow")
	
