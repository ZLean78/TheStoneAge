extends StaticBody2D

@onready var select = $Selected
@onready var bar = get_node("Bar")
@export var camera: Camera2D
var mouseEntered = false
var unitEntered = false
var selected = false
var condition = 0






# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	bar.value = condition
	select.visible = selected
	if $Timer.is_stopped():
		$Timer.start()
	
func _input(event):
	if event.is_action_pressed("LeftClick"):
		if mouseEntered == true:
			selected = !selected
			if selected == true:
				var spawn_position = Vector2(get_tree().get_root().get_window().size.x/2,get_tree().get_root().get_window().size.y/2)
				Game.spawn_unit(spawn_position)

func _build_house():
	if unitEntered and condition < 100 and $Timer.stop:
		condition+=10
		


func _on_mouse_entered():
	mouseEntered = true
	Game.mouse_entered = true
	


func _on_mouse_exited():
	mouseEntered = false
	Game.mouse_entered = false
	


func _on_area_2d_body_entered(body):
	if "Unit" in body.name:
		body.follow_cursor=false
		body.navi.set_velocity(Vector2.ZERO)
		body.navi.target_position = body.position
		unitEntered = true
	

func _on_timer_timeout():
	_build_house()


func _on_area_2d_body_exited(_body):
	unitEntered = false
