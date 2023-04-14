extends "res://Scenes/RTS_Other_Entities/RTS_Other_Entities.gd"

export (NodePath) var rh
onready var nv_agent: NavigationAgent2D = $Entities_Agent
onready var ray: RayCast2D = $Ray
var is_selected = false
var scene_root=self
var selection_oval = scene_root.find_node("SelectionOval")
var target = Vector2(0,0)
var _entity = self  #Variable que representa la entidad en sí. La usamos para acceder a todas sus variables desde los otros scripts.
var camera = root.get_node("Camera")



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	target = position


func _get_target():
	return target

func _set_target(_target):
	target =_target

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Preguntamos si la entidad es seleccionable
	if !is_selectable:
		return
		
	if is_selected:
		if Input.is_action_just_released("ui_left_mouse_button") || Input.is_action_just_released("ui_right_mouse_button"):
			if ray.collide_with_bodies:
				pass
		
