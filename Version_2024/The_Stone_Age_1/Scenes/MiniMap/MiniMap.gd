extends SubViewport

@onready var camera = get_node("Camera")

var World = preload("res://Scenes/World/world.tscn")

var barbHouse = preload("res://Scenes/MiniMap/MiniMapSprites/BarbHouseSprite.tscn")
var unit = preload("res://Scenes/MiniMap/MiniMapSprites/UnitSprite.tscn")
var tree = preload("res://Scenes/MiniMap/MiniMapSprites/TreeSprite.tscn")
var foodHouse = preload("res://Scenes/MiniMap/MiniMapSprites/FoodHouseSprite.tscn")
var townHall = preload("res://Scenes/MiniMap/MiniMapSprites/TownHallSprite.tscn")
var fruitTree = preload("res://Scenes/MiniMap/MiniMapSprites/FruitTreeSprite.tscn")
var cave = preload("res://Scenes/MiniMap/MiniMapSprites/CaveSprite.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():	
	updateMap()
	
func updateMap():
	for i in get_child_count()-3:
		get_child(i+3).queue_free()
	
	for i in get_node("Units").get_child_count():
		get_node("Units").get_child(i).queue_free()
		
	
	var HousesPath = get_node("../../../../Houses")
	var UnitsPath = get_node("../../../../Units")
	var TreesPath = get_node("../../../../Trees")
	var ResourcesPath = get_node("../../../../Resources")
	var TownHallPath = get_node("../../../../TownHall")
	var FruitTreesPath = get_node("../../../../FruitTrees")
	var CavePath = get_node("../../../../Cave")
	
	for i in HousesPath.get_child_count():
		var houseInstance = barbHouse.instantiate()
		add_child(houseInstance)
		houseInstance.position = HousesPath.get_child(i).position/2
		
	for i in UnitsPath.get_child_count():
		var unitInstance = unit.instantiate()
		get_node("Units").add_child(unitInstance)
		unitInstance.position = UnitsPath.get_child(i).position/2
		
	for i in TreesPath.get_child_count():
		var treeInstance = tree.instantiate()
		add_child(treeInstance)
		treeInstance.position = TreesPath.get_child(i).position/2
		
	for i in ResourcesPath.get_child_count():
		var foodHouseInstance = foodHouse.instantiate()
		add_child(foodHouseInstance)
		foodHouseInstance.position = ResourcesPath.get_child(i).position/2
		
	for i in TownHallPath.get_child_count():
		var townHallInstance = townHall.instantiate()
		add_child(townHallInstance)
		townHallInstance.position = TownHallPath.get_child(i).position/2
	
	for i in FruitTreesPath.get_child_count():
		var fruitTreeInstance = fruitTree.instantiate()
		add_child(fruitTreeInstance)
		fruitTreeInstance.position = FruitTreesPath.get_child(i).position/2
	
	for i in CavePath.get_child_count():
		var caveInstance = cave.instantiate()
		add_child(caveInstance)
		caveInstance.position = CavePath.get_child(i).position/2
		

func _process(_delta):
	var cameraPath = get_node("../../../../Camera")
	var UnitsPath = get_node("../../../../Units")
	camera.position = cameraPath.position/2
	camera.zoom = cameraPath.zoom/2

	var unitsTotal = get_node("Units")
	for i in UnitsPath.get_child_count():
		unitsTotal.get_child(i).position = UnitsPath.get_child(i).position/2
		
func _input(event):
	var cameraPath = get_node("../../../../Camera")
	if event.is_action_pressed("LeftClick"):
		camera.position = event.position
		cameraPath.position = event.position*2
	

