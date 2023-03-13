extends Node2D

var points = 300
signal quarry_entered
signal quarry_exited
var is_touching
var is_empty

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta):
	if is_empty:
		visible=false


func _on_Area2D_mouse_entered():
	get_parent().emit_signal("is_pick_mattock")


func _on_Area2D_mouse_exited():
	get_parent().emit_signal("is_arrow")


func _on_Area2D_body_entered(body):
	if("Unit" in body.name):
		is_touching = true
		emit_signal("quarry_entered")
		body._set_quarry_touching(true)


func _on_Area2D_body_exited(body):
	if("Unit" in body.name):
		is_touching = false
		emit_signal("quarry_exited")
		body._set_quarry_touching(false)
