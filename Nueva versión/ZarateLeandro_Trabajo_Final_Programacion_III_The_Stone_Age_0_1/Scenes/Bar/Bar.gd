extends Node2D

var energy_points=0

#func _unhandled_input(event):
#	if event is InputEventKey && event.scancode == KEY_R:
#		if event.is_pressed():
#			_decrease_energy()

func _set_energy_points(var _energy_points):
	energy_points = _energy_points

#func _decrease_energy():
#	if($Background.get_child(0).scale.x > 0):
#		$Background.get_child(0).scale.x -= 0.033
#
#func _increase_energy():
#	if($Background.get_child(0).scale.x < 30):
#		$Background.get_child(0).scale.x += 0.033

func _update_energy():
	print("bar energy: " + str(energy_points))
	$Background.get_child(0).scale.x = energy_points/100
	print($Background.get_child(0).scale.x)


