extends KinematicBody2D

var start_position=Vector2.ZERO
var gravity=Vector2(0,9.8)
var velocity_x=Vector2.ZERO
var velocity_y=Vector2(0,-200)
var owner_name=""
var to_delta

func _ready():
	start_position=position

func _physics_process(delta):
	velocity_y+=gravity
	to_delta=delta
	move_projectile()

func move_projectile():
	var collision = move_and_collide((velocity_x+velocity_y)*to_delta)
	
	if collision != null:
		if("Unit2" in collision.collider.name || "Warrior" in collision.collider.name
		|| "EnemyCitizen" in collision.collider.name || "EnemyWarrior" in collision.collider.name
		|| "House" in collision.collider.name || "EnemyHouse" in collision.collider.name
		|| "Townhall" in collision.collider.name || "EnemyTownhall" in collision.collider.name):
			collision.collider._get_damage(self)
		queue_free()

	

#	if position.distance_to(start_position)>250:
#		queue_free()

func set_velocity(_velocity):
	velocity_x=_velocity
