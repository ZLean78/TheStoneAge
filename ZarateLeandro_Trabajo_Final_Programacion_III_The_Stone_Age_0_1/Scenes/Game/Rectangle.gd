extends ColorRect

var food_points = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _set_food_points(var _food_points):
	food_points=_food_points	
	_set_label_food_points(food_points)

func _set_label_food_points(var _food_points):
	$Label.text = "FOOD: " + str(_food_points)

