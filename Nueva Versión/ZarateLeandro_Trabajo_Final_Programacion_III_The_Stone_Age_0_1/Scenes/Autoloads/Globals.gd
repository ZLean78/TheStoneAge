extends Node

var current_scene=null
var root

#Variables de íconos del mouse.
var basket=load("res://Scenes/MouseIcons/basket.png")
var arrow=load("res://Scenes/MouseIcons/arrow.png")




#Puntos de recursos de la comunidad.
var food_points = 15
var leaves_points = 0

#Condiciones que afectan a toda la comunidad
var group_dressed = false
var group_has_bag = false


func _ready():
	root=get_tree().root
	current_scene = root.get_child(root.get_child_count()-1)
	
	

func go_to_scene(path):
	call_deferred("_deferred_go_to_scene", path)

func _deferred_go_to_scene(path):
	current_scene.free()
	
	var s = ResourceLoader.load(path)
	
	current_scene = s.instance()
	
	get_tree().root.add_child(current_scene)
	
	#Opcional, para hacerlo compatible con la API the SceneTree.change_scene_to_file(). 
	get_tree().current_scene=current_scene
	
