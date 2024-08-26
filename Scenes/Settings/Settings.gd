extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	_on_HScrollBar_scrolling()



func _on_HScrollBar_scrolling():	
	
	match int($HScrollBar.value):
		1:
			Globals.screen_size=Vector2(640,480)
			$Label2.text="640x480"
		2:
			Globals.screen_size=Vector2(800,600)
			$Label2.text="800x600"
		3:
			Globals.screen_size=Vector2(1024,600)
			$Label2.text="1024x600"
		4:
			Globals.screen_size=Vector2(1280,720)
			$Label2.text="1280x720"
		5:
			Globals.screen_size=Vector2(1920,1080)
			$Label2.text="1920x1080"
		6:
			Globals.screen_size=Vector2(2560,1440)
			$Label2.text="2560x1440"
	get_viewport().size=Globals.screen_size
	
		
		
