extends StaticBody2D

@onready var select = $Selected
@onready var bar = get_node("Bar")
var mouseEntered = false
var unitEntered = false
var selected = false
var condition = 0
var units = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	bar.value = condition
	select.visible = selected
	if units > 0:
		unitEntered = true
	else:
		unitEntered = false
	if $Timer.is_stopped():
		$Timer.start()

func _build_town_hall():
	if unitEntered and condition < 300 and $Timer.stop:
		condition+=10*units


func _on_area_2d_body_entered(body):
	if "Unit" in body.name:
		body.follow_cursor=false
		body.navi.set_velocity(Vector2.ZERO)
		body.navi.target_position = body.position
		unitEntered = true
		units+=1


func _on_area_2d_body_exited(body):
	if "Unit" in body.name:		
		units-=1
		if units<=0:
			unitEntered=false
		


func _on_timer_timeout():
	_build_town_hall()

