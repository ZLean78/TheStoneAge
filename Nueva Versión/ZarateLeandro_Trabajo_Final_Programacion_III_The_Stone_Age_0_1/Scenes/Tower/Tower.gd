extends StaticBody2D


export var condition=0
export var condition_max=0
onready var root=get_tree().root.get_child(0)
onready var units=get_tree().root.get_child(0).get_node("Units")
onready var timer=$Timer
onready var polygon=$CollisionPolygon2D
#onready var all_timer=get_tree().root.get_child(0).get_node("food_timer")
onready var bar=$Bar
onready var shoot_point=$ShootPoint
onready var shoot_point2=$ShootPoint2
var mouse_entered=false
var body_entered=null
var target_position=Vector2.ZERO
var can_shoot=false

export (float) var MIN_DISTANCE=0

#Proyectil, piedra para lanzar al enemigo.
var spear
export var spear_scene=preload("res://Scenes/Bullet/Bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
	bar.value=condition
	if body_entered!=null:
		_get_damage(body_entered)
	_detect_enemies()
	
func _tower_build():
	if condition<condition_max:
		condition+=3
		


func _get_damage(body):
	if is_instance_valid(body):
		if "EnemySpear" in body.name:
			condition-=3
			if condition<0:
				polygon.visible=false
				if root.get_node("Towers").get_child_count()<=0:
					root.is_first_tower_built=false
				queue_free()
				root.emit_signal("remove_building")
	else:
		body_entered=null


func _on_Area2D_body_entered(body):
	body_entered=body
	if "Unit" in body.name:
		body.tower_entered=true
	


func _on_Area2D_body_exited(body):
	if "Unit" in body.name:
		body_entered=null
		body.tower_entered=false


func _on_Timer_timeout():
	for citizen in units.get_children():
		if citizen.tower_entered && citizen.position.distance_to(self.position)<50:
			_tower_build()
	if can_shoot==false:
		can_shoot=true
	timer.start()


func _on_Tower_mouse_entered():
	mouse_entered=true


func _on_Tower_mouse_exited():
	mouse_entered=false
	
func _detect_enemies():
	for an_enemy in root.enemy_warriors_node.get_children():
		if is_instance_valid(an_enemy):
			if position.distance_to(an_enemy.position)<MIN_DISTANCE:
				target_position=an_enemy.position
				if can_shoot:
					_shoot()
				
func _shoot():
	var the_tilemap=get_tree().get_nodes_in_group("tilemap")
	var spear_target = target_position
		
	
	if spear_target.x>position.x:
		
		shoot_point.look_at(spear_target)		
		var angle = shoot_point.rotation
		var forward = Vector2(cos(angle),sin(angle))
		var spear_count=0
		for tilemap_child in the_tilemap[0].get_children():
			if "Bullet" in tilemap_child.name:
				spear_count+=1
		if spear_count==0:		
			spear = spear_scene.instance()
			shoot_point.rotation = angle	
			spear.position = Vector2(shoot_point.global_position.x,shoot_point.global_position.y)
			spear.set_dir(forward)
			spear.rotation = angle
			#spear.owner_name="Enemy_Warrior"
			#target_position=spear_target		
			the_tilemap[0].add_child(spear)
	else:
		
		shoot_point2.look_at(spear_target)	
		var angle = shoot_point2.rotation
		var forward = Vector2(cos(angle),sin(angle))
		var spear_count=0
		for tilemap_child in the_tilemap[0].get_children():
			if "Bullet" in tilemap_child.name:
				spear_count+=1
		if spear_count==0:		
			spear = spear_scene.instance()
			shoot_point2.rotation = angle	
			spear.position = Vector2(shoot_point2.global_position.x,shoot_point2.global_position.y)
			spear.set_dir(forward)
			spear.rotation = angle
			#spear.owner_name="Enemy_Warrior"
			#target_position=spear_target		
			the_tilemap[0].add_child(spear)
	can_shoot=false

