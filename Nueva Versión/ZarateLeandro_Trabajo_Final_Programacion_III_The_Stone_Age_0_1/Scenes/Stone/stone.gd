extends KinematicBody2D


var gravity=Vector2(0,9.8)
var velocity_x=Vector2.ZERO
var velocity_y=Vector2(0,-250)

func _physics_process(delta):
	velocity_y+=gravity
	move_projectile()

func move_projectile():
	move_and_slide(velocity_x+velocity_y)

func set_velocity(_velocity):
	velocity_x=_velocity
