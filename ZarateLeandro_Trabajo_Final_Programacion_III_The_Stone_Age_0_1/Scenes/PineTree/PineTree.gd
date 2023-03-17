extends Node2D

var points = 30
onready var the_sprite = get_child(0)
signal pine_tree_entered
signal pine_tree_exited
var is_touching = false
var is_empty = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_empty:
		visible=false


func _on_Area2D_body_entered(body):
	if("Unit" in body.name):
		is_touching = true
		emit_signal("pine_tree_entered")
		body._set_pine_tree_touching(true)


func _on_Area2D_body_exited(body):
	if("Unit" in body.name):
		is_touching = true
		emit_signal("pine_tree_exited")
		body._set_pine_tree_touching(false)


func _on_Area2D_mouse_entered():
	get_parent().emit_signal("is_axe")


func _on_Area2D_mouse_exited():
	get_parent().emit_signal("is_arrow")
