extends Node2D


@onready var unit_node=get_tree().get_root().get_node("MainScene/SubViewportContainer/SubViewport/World/Units")
@onready var resources_node = $Resources
@onready var food_label = $Resources/FoodLabel
@onready var wood_label = $Resources/WoodLabel

var button_down=false
var townhall_button_down=false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	food_label.text = str(Game.Food) 
	wood_label.text = str(Game.Wood)
	var units = unit_node
	for unit in units.get_children():
		if unit.selected:
			if button_down:
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
	
		

func _on_button_pressed():
	button_down=!button_down
		


func _on_town_hall_button_pressed():
	townhall_button_down=!townhall_button_down













