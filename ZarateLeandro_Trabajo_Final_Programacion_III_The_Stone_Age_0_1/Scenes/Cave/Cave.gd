extends Node2D

var sheltered_units=0

func _on_Area2D_body_entered(body):
	if "Unit" in body.name:
		body.visible=false
		sheltered_units+=1
