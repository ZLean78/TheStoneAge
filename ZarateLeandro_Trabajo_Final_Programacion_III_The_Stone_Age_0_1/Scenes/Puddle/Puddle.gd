extends Node2D


signal puddle_entered
signal puddle_exited
var is_touching


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_mouse_entered():
	get_tree().root.get_child(0).emit_signal("is_hand")


func _on_Area2D_mouse_exited():
	get_tree().root.get_child(0).emit_signal("is_arrow")


func _on_Area2D_body_entered(body):
	if("Unit" in body.name):
		is_touching = true
		emit_signal("puddle_entered")
		body._set_puddle_touching(true)


func _on_Area2D_body_exited(body):
	if("Unit" in body.name):
		is_touching = false
		emit_signal("puddle_exited")
		body._set_puddle_touching(false)
