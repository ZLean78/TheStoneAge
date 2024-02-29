extends Node2D

var sheltered_units=0

func _on_Area2D_body_entered(body):
	if "Unit" in body.name:
		body.visible=false
		sheltered_units+=1


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				if get_tree().root.get_child(0).name=="Game2":
					get_tree().root.get_child(0).develop_stone_weapons.visible = not get_tree().root.get_child(0).develop_stone_weapons.visible
					get_tree().root.get_child(0).invent_wheel.visible = not get_tree().root.get_child(0).invent_wheel.visible
					get_tree().root.get_child(0).discover_fire.visible = not get_tree().root.get_child(0).discover_fire.visible
					get_tree().root.get_child(0).make_claypot.visible = not get_tree().root.get_child(0).make_claypot.visible
					get_tree().root.get_child(0).develop_agriculture.visible = not get_tree().root.get_child(0).develop_agriculture.visible
				
