extends Node2D


@onready var unit = preload("res://Scenes/Unit/Unit.tscn")
@onready var houses = get_tree().get_root().get_node("MainScene/SubViewportContainer/SubViewport/World/Houses")
@onready var unit_node = get_tree().get_root().get_node("MainScene/SubViewportContainer/SubViewport/World/Units")
@onready var worldPath = get_tree().get_root().get_node("MainScene/SubViewportContainer/SubViewport/World")
@onready var house_path = get_tree().get_root().get_node("MainScene/SubViewportContainer/SubViewport/World/Houses")
@onready var miniMapPath = get_tree().get_root().get_node("MainScene/SubViewportContainer/SubViewport/World/UI/MiniMap/SubViewportContainer/SubViewport")
@onready var camera = get_tree().get_root().get_node("MainScene/SubViewportContainer/SubViewport/World/Camera")
var house_position = Vector2.ZERO

func _process(_delta):	
	if houses.get_child_count()>0 and unit_node.get_child_count()/houses.get_child_count()>=4:
		$Label.text = "No tienes suficientes casas para crear una unidad"
		$Yes.visible = false
		$No.visible = true
		$No.text = "Ok"
	else:
		$Label.text = "¿Deseas crear esta unidad?"
		$Yes.visible = true
		$No.visible = true
		$No.text = "No"
	

		
func _on_yes_pressed():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_position_X = rng.randi_range(-camera.zoom.x/2,-camera.zoom.x/2)
	var random_position_Y = rng.randi_range(-camera.zoom.y/2,-camera.zoom.y/2)
	for i in house_path.get_child_count():
		if house_path.get_child(i).selected == true:
			house_position = Vector2(house_path.get_child(i).position.y, house_path.get_child(i).position.y)
	
	
	var unit1 = unit.instantiate()
	var unit_position = house_position + Vector2(random_position_X,random_position_Y)
	unit1.position = unit_position
	for aUnit in unit_node.get_children():
		if aUnit.position == unit1.position:
			unit1.position += Vector2(50,50)
			
	unit_node.add_child(unit1)
	worldPath._get_units()
	
	miniMapPath._ready()


func _on_no_pressed():
	for i in house_path.get_child_count():
		if house_path.get_child(i).selected == true:
			house_path.get_child(i).selected = false
	queue_free()
