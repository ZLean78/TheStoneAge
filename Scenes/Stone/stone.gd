extends KinematicBody2D

var start_position=Vector2.ZERO
var gravity=9.8
var velocity_x=0
var velocity_y=0
var speedY = 0
var owner_name=""
var to_delta

func _ready():
	start_position=position

func _process(delta):
	speedY += gravity*delta
	velocity_y+= speedY
	to_delta=delta
	move_projectile()

func move_projectile():
	var collision = move_and_collide(Vector2(velocity_x,velocity_y)*to_delta)
	
	
	if collision != null:
		if owner_name=="EnemyCitizen":
			if("Citizen" in collision.collider.name || "Warrior" in collision.collider.name || "Vehicle" in collision.collider.name 
			|| "House" in collision.collider.name  || "Fort" in collision.collider.name || "Barn" in collision.collider.name
			&& !("Enemy in collision.collider.name")):
				collision.collider._get_damage(self)
				
		elif owner_name=="EnemyVehicle":
			if("Citizen" in collision.collider.name || "Warrior" in collision.collider.name || "Vehicle" in collision.collider.name 
			|| "House" in collision.collider.name  || "Fort" in collision.collider.name || "Barn" in collision.collider.name
			&& !("Enemy in collision.collider.name")):
				collision.collider._get_damage(self)
			
			elif "TownHall" in collision.collider.name:
				collision.collider._get_townhall_damage(self)
				
		elif owner_name=="Citizen":
			if ("EnemyCitizen" in collision.collider.name || "EnemyWarrior" in collision.collider.name || "EnemyVehicle" in collision.collider.name
			 ||  "EnemyHouse" in collision.collider.name || "EnemyFort" in collision.collider.name):
				collision.collider._get_damage(self)
				
		elif owner_name=="Vehicle":
			if ("EnemyCitizen" in collision.collider.name || "EnemyWarrior" in collision.collider.name || "EnemyVehicle" in collision.collider.name
			 ||  "EnemyHouse" in collision.collider.name || "EnemyFort" in collision.collider.name):
				collision.collider._get_damage(self)
				
			elif "EnemyTownhall" in collision.collider.name:
				collision.collider._get_damage(self)
			
		queue_free()
			
			
		
			

	

	if position.distance_to(start_position)>250:
		queue_free()

func set_velocity(_velocity):
	velocity_x=_velocity.x
	velocity_y=_velocity.y
