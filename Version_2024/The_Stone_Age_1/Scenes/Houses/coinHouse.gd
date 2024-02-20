extends StaticBody2D

@onready var progress_bar = $ProgressBar
@onready var timer = $Timer

var POP = preload("res://Scenes/Globals/pop.tscn")

var totalTime = 100.0
var currentTime 

# Called when the node enters the scene tree for the first time.
func _ready():
	currentTime = totalTime
	#var progress_bar_max_value = totalTime
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if currentTime < 0:
		foodCollected()
		


func _on_timer_timeout():
	currentTime-=1
	var tween = get_tree().create_tween()
	tween.tween_property(progress_bar,"value",currentTime,0.1).set_trans(Tween.TRANS_LINEAR)
	
func foodCollected():
	Game.Food+=10
	_ready()
	var pop = POP.instantiate()
	add_child(pop)
	pop.show_value(str(10),false)
	
	


func _on_mouse_entered():
	Game.mouse_entered = true


func _on_mouse_exited():
	Game.mouse_entered = false
