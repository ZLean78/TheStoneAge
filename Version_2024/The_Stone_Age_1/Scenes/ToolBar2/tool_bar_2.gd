extends Node2D

@onready var unit_node=get_tree().get_root().get_node("MainScene/SubViewportContainer/SubViewport/World/Units")
var unit_button_down=false
var house_button_down=false
var townhall_button_down=false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var units = unit_node
	for unit in units.get_children():
		if unit.selected:
			if house_button_down:
				if Game.mouse_entered:
					Input.set_custom_mouse_cursor(Game.greyBarbHouse)
					Game.cursor_mode = "GreyBarbHouse"
				else:
					Input.set_custom_mouse_cursor(Game.barbHouse)
					Game.cursor_mode = "BarbHouse"			
			elif townhall_button_down:
				if Game.mouse_entered:
					Input.set_custom_mouse_cursor(Game.greyTownHall)
					Game.cursor_mode = "GreyTownHall"
				else:
					Input.set_custom_mouse_cursor(Game.townHall)
					Game.cursor_mode = "TownHall"			
			else:
				Input.set_custom_mouse_cursor(null)
				Game.cursor_mode = "Default"
			
		elif unit_button_down:
			if Game.mouse_entered:
				Input.set_custom_mouse_cursor(Game.greyBarbHouse)
				Game.cursor_mode = "GreyMan"
			else:
				Input.set_custom_mouse_cursor(Game.man)
				Game.cursor_mode = "Man"
		else:
			Input.set_custom_mouse_cursor(null)
			Game.cursor_mode = "Default"
			
		


func _on_unit_button_pressed():
	unit_button_down=!unit_button_down
	
	

func _on_unit_button_mouse_entered():
	#Game.mouse_entered=true
	pass

func _on_house_button_pressed():
	house_button_down=!house_button_down


func _on_house_button_mouse_entered():
	#Game.mouse_entered=true
	pass

func _on_town_hall_button_pressed():
	townhall_button_down=!townhall_button_down


func _on_town_hall_button_mouse_entered():
	#Game.mouse_entered=true
	pass
