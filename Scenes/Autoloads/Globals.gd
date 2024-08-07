extends Node

var current_scene=null
var root

#Variables de íconos del mouse.
var basket=load("res://Scenes/MouseIcons/basket.png")
var arrow=load("res://Scenes/MouseIcons/arrow.png")
var pick_mattock=load("res://Scenes/MouseIcons/pick_mattock.png")
var sword=load("res://Scenes/MouseIcons/sword.png")
var claypot=load("res://Scenes/MouseIcons/claypot.png")
var hand=load("res://Scenes/MouseIcons/hand.png")
var axe=load("res://Scenes/MouseIcons/axe.png")
var house=load("res://Scenes/MouseIcons/house.png")
var house_b=load("res://Scenes/MouseIcons/house_b.png")
var townhall=load("res://Scenes/MouseIcons/townHall.png")
var townhall_b=load("res://Scenes/MouseIcons/townHall_b.png")
var fort=load("res://Scenes/MouseIcons/fort_s.png")
var fort_b=load("res://Scenes/MouseIcons/fort_sb.png")
var barn=load("res://Scenes/MouseIcons/barn_s.png")
var barn_b=load("res://Scenes/MouseIcons/barn_sb.png")
var tower=load("res://Scenes/MouseIcons/tower_s.png")
var tower_b=load("res://Scenes/MouseIcons/tower_sb.png")

#var settings=load("res://Scenes/Settings/Settings.tscn")

#Puntos de recursos de la comunidad.
var food_points = 2015
var leaves_points = 2000
var stone_points = 2000
var wood_points = 2000
var clay_points = 2000
var water_points = 2000
var copper_points = 2000

#Puntos de recursos del pueblo enemigo:
var e_food_points = 0
var e_leaves_points = 0
var e_stone_points = 0
var e_wood_points = 0
var e_clay_points = 0
var e_water_points = 0
var e_copper_points = 0

#Condiciones que afectan a toda la comunidad
var group_dressed = false
var group_has_bag = false

var screen_size:Vector2

var settings_scene=load("res://Scenes/Settings/Settings.tscn")
var settings=settings_scene.instance()

func _ready():
	root=get_tree().root
	current_scene = root.get_child(root.get_child_count()-1)
	screen_size=Vector2(1280,720)
	


	

func go_to_scene(path):
	call_deferred("_deferred_go_to_scene", path)

func _deferred_go_to_scene(path):
	current_scene.free()
	
	var s = ResourceLoader.load(path)
	
	current_scene = s.instance()
	
	get_tree().root.add_child(current_scene)
	
	#Opcional, para hacerlo compatible con la API the SceneTree.change_scene_to_file(). 
	get_tree().current_scene=current_scene
	
