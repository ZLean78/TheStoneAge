extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _unhandled_input(event):
	if event is InputEventKey && event.scancode == KEY_R:
		if event.is_pressed():
			_decrease_energy()
		

func _decrease_energy():
	if($Background.get_child(0).scale.x > 0):
		$Background.get_child(0).scale.x -= 0.033

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
