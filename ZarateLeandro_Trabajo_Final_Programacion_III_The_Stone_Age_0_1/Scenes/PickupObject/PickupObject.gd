extends Node2D

var points = 30
onready var the_sprite = null
var type=null
var touching = false
var empty = false



# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _physics_process(_delta):
	pass

func _on_Area2D_body_entered(body):
	if("Unit" in body.name):
		touching = true
		body._set_pickable_touching(true)
#		if type=="fruit_tree":
#			body._set_fruit_tree_touching(true)
#		elif type=="pine_tree":
#			body._set_pine_tree_touching(true)
		


func _on_Area2D_body_exited(body):
	if("Unit" in body.name):
		touching = false
		body._set_pickable_touching(false)
#		if type=="fruit_tree":
#			body._set_fruit_tree_touching(false)
#		elif type=="pine_tree":
#			body._set_pine_tree_touching(false)	
		





func _on_Area2D_mouse_entered():
	if type == "fruit_tree":
		get_parent().emit_signal("is_basket")
	elif type == "pine_tree":
		get_parent().emit_signal("is_axe")
	elif type == "quarry":
		get_parent().emit_signal("is_pick_mattock")	
	elif type == "plant":
		get_parent().emit_signal("is_basket")
		


func _on_Area2D_mouse_exited():
	get_parent().emit_signal("is_arrow")



