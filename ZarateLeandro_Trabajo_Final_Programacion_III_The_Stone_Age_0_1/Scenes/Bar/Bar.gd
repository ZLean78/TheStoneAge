extends Node2D



func _unhandled_input(event):
	if event is InputEventKey && event.scancode == KEY_R:
		if event.is_pressed():
			_decrease_energy()
		

func _decrease_energy():
	if($Background.get_child(0).scale.x > 0):
		$Background.get_child(0).scale.x -= 0.033
		
func _increase_energy():
	if($Background.get_child(0).scale.x < 30):
		$Background.get_child(0).scale.x += 0.033


