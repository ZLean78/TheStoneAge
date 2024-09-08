extends "res://Scenes/Building/Building.gd"




	
func _get_townhall_damage(body):
	if "Citizen" in body.name:
		body.house_entered=true
	if "Stone" in body.name && body.owner_name=="EnemyVehicle":
		condition-=10
		bar.value=condition
		if condition<=0:
			polygon.visible=false
			Globals.is_townhall_down=true
			queue_free()
			tree.emit_signal("remove_building")
				


func _on_Area2D_body_entered(body):
	if "Citizen" in body.name:
		body.house_entered=true

func _on_Area2D_body_exited(body):
	if "Citizen" in body.name:
		body.house_entered=false




func _on_Area2D_mouse_entered():
	mouse_entered=true


func _on_Area2D_mouse_exited():
	mouse_entered=false
