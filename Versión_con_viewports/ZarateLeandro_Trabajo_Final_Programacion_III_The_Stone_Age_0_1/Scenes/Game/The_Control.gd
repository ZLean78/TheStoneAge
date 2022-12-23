extends Control

var food_points = 0
var enemy_attack = 0
var phrase = ""

onready var game_screen = get_tree().root.get_child(0).get_node("GameScreen")
onready var panel = get_tree().root.get_child(0).get_node("Panel")
onready var timer_label = game_screen.get_node("Viewport/Camera2D_1/Timer_Label")
	
func _process(_delta):
	_set_Timer_Label_enemy_attack(enemy_attack)

func _set_food_points(var _food_points):
	food_points=_food_points 
	_set_Rectangle_food_points(food_points)
	
func _set_enemy_attack(var _enemy_attack):
	enemy_attack=_enemy_attack
	_set_Timer_Label_enemy_attack(enemy_attack)

func _set_Rectangle_food_points(var _food_points):
	$Rectangle._set_food_points(food_points)
	
func _set_Timer_Label_enemy_attack(var _enemy_attack):
	timer_label.text = "ATAQUE ENEMIGO: " + str(_enemy_attack)
	
func _set_phrase(var _phrase):
	phrase = _phrase
	$Rectangle._set_phrase(phrase)

