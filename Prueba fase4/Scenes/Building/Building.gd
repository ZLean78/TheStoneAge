extends "res://Scenes/RTS_Other_Entities/RTS_Other_Entities.gd"


var craft_radius=0.0
var is_crafted=false
var is_craft_completed=false
var build_time=10
var can_craft=false

var scene_root=self
var prompts_label = root.find_node("UI/Base/Rectangle/PromptsLabel")
var animator=scene_root.get_node("AnimatedSprite")


# Called when the node enters the scene tree for the first time.
func _ready():
	if build_time<=0:
		return
		animator.play("Uncompleted")
		
func _set_build():
	if build_time<=0:
		return
		animator.play("Completed")
		
func _craft_point():
	prompts_label.text="Construyendo..."
	build_time-=1
	
	if build_time<=0:
		is_craft_completed=true
		animator.play("Completed")
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
