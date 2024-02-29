extends Node2D

@onready var empty_tree=load("res://Sprites/Game_Sprites/fruit_tree2.png")
@onready var progress_bar = $ProgressBar
@onready var sprite=$Sprite2D
@onready var timer=$Timer
var food_points=30
var unit_entered=false


func _process(_delta):
	progress_bar.value=food_points*100/30

func _on_area_2d_body_entered(body):
	if "Unit" in body.name:
		unit_entered=true
		body.is_sheltered = true


func _on_area_2d_body_exited(body):
	if "Unit" in body.name:
		unit_entered=false
		body.is_sheltered = false

func _gather_food():
	if unit_entered:
		if food_points>0:
			food_points-=1
			Game.Food+=1
		
	if food_points<=0:
		sprite.texture=empty_tree

func _on_timer_timeout():
	_gather_food()
	timer.start()
