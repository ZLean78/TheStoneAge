extends Node2D

var units_in_cave = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if "Unit" in body.name:
		body.is_cave_sheltered = true
		body.visible = false
		units_in_cave+=1


func _on_area_2d_body_exited(body):
	if "Unit" in body.name:
		body.is_cave_sheltered = false
		body.visible = true
		units_in_cave-=1
