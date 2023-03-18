extends Node2D

signal lake_entered
signal lake_exited
var is_touching




# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_mouse_entered():
	get_tree().root.get_child(0).emit_signal("is_claypot")


func _on_Area2D_mouse_exited():
	get_tree().root.get_child(0).emit_signal("is_arrow")


func _on_Area2D_body_entered(body):
	if("Unit" in body.name):
		is_touching = true
		emit_signal("lake_entered")
		body._set_lake_touching(true)


func _on_Area2D_body_exited(body):
	if("Unit" in body.name):
		is_touching = false
		emit_signal("lake_exited")
		body._set_lake_touching(false)
		get_tree().root.get_child(0).prompts_label.text = get_tree().root.get_child(0).start_string
