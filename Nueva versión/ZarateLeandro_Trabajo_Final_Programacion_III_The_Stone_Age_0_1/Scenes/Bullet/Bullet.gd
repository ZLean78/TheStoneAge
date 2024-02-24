extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dir = 0
var speed = 400

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_move_bullets(delta)

func _move_bullets(var _to_delta):
	#var new_position=position.x+2
	var collision = move_and_collide(speed*dir*_to_delta)
	
	if collision != null:
		if collision.collider.name == "TileMap":
			queue_free()
		elif collision.collider.name == "Tiger":
			queue_free()
			collision.collider.queue_free()
	
			

func set_dir(new_dir):
	dir = new_dir
	scale.x = 1
	
func set_speed(new_speed):
	speed = new_speed
