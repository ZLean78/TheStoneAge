extends "res://Scenes/PickupObject/PickupObject.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	points = 30
	the_sprite = get_child(0)
	type = "pine_tree"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if empty:
		visible=false
	else:
		visible=true



