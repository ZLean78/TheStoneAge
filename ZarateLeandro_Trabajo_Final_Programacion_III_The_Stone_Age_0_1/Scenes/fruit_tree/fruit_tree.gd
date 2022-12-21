extends Node2D

var points = 30
onready var the_sprite = get_child(0)
signal fruit_tree_entered
signal fruit_tree_exited
var is_touching = false
var is_empty = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _physics_process(_delta):
	_fruit_tree_animate()

func _on_Area2D_body_entered(body):
	if("Unit" in body.name):
		is_touching = true
		emit_signal("fruit_tree_entered")
		body._set_fruit_tree_touching(true)


func _on_Area2D_body_exited(body):
	if("Unit" in body.name):
		is_touching = false
		emit_signal("fruit_tree_exited")
		body._set_fruit_tree_touching(false)


func _fruit_tree_animate():	
	if is_empty == true:
		$AnimationPlayer.play("empty")
	else:
		$AnimationPlayer.play("full")
