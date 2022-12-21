extends Control

var food_points = 0
var enemy_attack = 0
var phrase = ""
	
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
	$Timer_Label.text = "ENEMY ATTACK: " + str(_enemy_attack)
	
func _set_phrase(var _phrase):
	phrase = _phrase
	$Rectangle._set_phrase(phrase)

