extends Node2D

onready var tree_instance
onready var unit_instance

func _ready():
	tree_instance=Globals.current_scene
	unit_instance=get_parent()

func _animate(sprite,velocity,target_position):
	if unit_instance.just_shot:
		sprite.animation = "horizontal_shot"
	else:
		sprite.animation = "horizontal"
#		if velocity.y < 0:
#			if abs(velocity.y) > abs(velocity.x):
#				sprite.animation = "vertical"
#				sprite.flip_v=false	
#			else:
#				sprite.animation = "horizontal"
#				sprite.flip_v=false
#		if velocity.x < 0:
#			if abs(velocity.y) > abs(velocity.x):
#				sprite.animation = "vertical"
#				sprite.flip_v=false
#			else:
#				sprite.animation = "horizontal"
#				sprite.flip_v=false
#		if velocity.y > 0:
#			if abs(velocity.y) > abs(velocity.x):
#				sprite.animation = "vertical"
#				sprite.flip_v=true	
#			else:
#				sprite.animation = "horizontal"
#				sprite.flip_v=false
#
#		if velocity.x > 0:
#			if abs(velocity.y) > abs(velocity.x):
#				sprite.animation = "vertical"
#				sprite.flip_v=false
#			else:
#				sprite.animation = "horizontal"
#				sprite.flip_v=false	
	
	
