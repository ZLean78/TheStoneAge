extends StaticBody2D


@onready var progress_bar = get_node("ProgressBar")
@onready var timer = get_node("Timer")
var total_time = 5
var current_time
var units = 0
var can_give_wood=true



# Called when the node enters the scene tree for the first time.
func _ready():
	current_time = total_time
	progress_bar.max_value = total_time



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	progress_bar.value = current_time
	if current_time < 0:
		treeChopped()
		


func _on_chop_area_body_entered(body):
	if "Unit" in body.name:
		units+=1
		body.is_sheltered = true
		if can_give_wood:
			startChopping()
		


func _on_chop_area_body_exited(body):
	if "Unit" in body.name:
		units-=1
		body.is_sheltered = false
		if units <= 0:
			timer.stop()


func _on_timer_timeout():
	var chop_speed=0.5*units
	current_time-=chop_speed	
	var tween = get_tree().create_tween()
	tween.tween_property(progress_bar,"value",current_time,0.2).set_trans(Tween.TRANS_LINEAR)
	
func startChopping():
	timer.start()
	
func treeChopped():	
	queue_free()
	Game.Wood+=15
	
func _on_mouse_entered():
	Game.mouse_entered = true


func _on_mouse_exited():
	Game.mouse_entered = false
