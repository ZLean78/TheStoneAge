extends KinematicBody2D


var gravity=Vector2(0,9.8)
var velocity_x=Vector2.ZERO
var velocity_y=Vector2(0,-250)

func _physics_process(delta):
	velocity_y+=gravity
	move_projectile()

func move_projectile():
	var collision = move_and_slide(velocity_x+velocity_y)
	
#	if collision != null:
#		if "Tiger" in collision.collider.name || "Mammoth" in collision.collider.name:
#			if "Tiger" in collision.collider.name:
#				collision.collider.unit.is_tiger_touching=false
#				collision.collider.unit=null
#			#collision.collider.queue_free()
#		queue_free()

func set_velocity(_velocity):
	velocity_x=_velocity
