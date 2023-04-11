extends Node2D

var basket=load("res://Scenes/MouseIcons/basket.png")
var arrow=load("res://Scenes/MouseIcons/arrow.png")
var pick_mattock=load("res://Scenes/MouseIcons/pick_mattock.png")
var sword=load("res://Scenes/MouseIcons/sword.png")
var claypot=load("res://Scenes/MouseIcons/claypot.png")
var hand=load("res://Scenes/MouseIcons/hand.png")
var axe=load("res://Scenes/MouseIcons/axe.png")

var unit_count = 1
var food_points = 15
var leaves_points = 0
var stone_points = 0
var wood_points = 0
var clay_points = 0
var water_points = 0

#Hitos anteriores ya cumplidos
var group_dressed = false
var group_has_bag = false

#Variables de hitos
var is_fire_discovered = false
var is_wheel_invented = false
var is_stone_weapons_developed = false
var is_claypot_made = false
var is_agriculture_developed = false


onready var tree = get_tree().root.get_child(0)
onready var food_timer = tree.get_node("food_timer")
onready var timer_label = tree.get_node("UI/Base/TimerLabel")
onready var food_label = tree.get_node("UI/Base/Rectangle/FoodLabel")
onready var prompts_label = tree.get_node("UI/Base/Rectangle/PromptsLabel")
onready var leaves_label = tree.get_node("UI/Base/Rectangle/LeavesLabel")
onready var stone_label = tree.get_node("UI/Base/Rectangle/StoneLabel")
onready var clay_label = tree.get_node("UI/Base/Rectangle/ClayLabel")
onready var wood_label = tree.get_node("UI/Base/Rectangle/WoodLabel")
onready var water_label = tree.get_node("UI/Base/Rectangle/WaterLabel")
#onready var developments_label = tree.get_node("UI/Base/Rectangle/DevelopmentsLabel")
onready var rectangle = tree.get_node("UI/Base/Rectangle")
onready var develop_stone_weapons = tree.get_node("UI/Base/Rectangle/DevelopStoneWeapons")
onready var invent_wheel = tree.get_node("UI/Base/Rectangle/InventWheel")
onready var discover_fire = tree.get_node("UI/Base/Rectangle/DiscoverFire")
onready var make_claypot = tree.get_node("UI/Base/Rectangle/MakeClaypot")
onready var develop_agriculture = tree.get_node("UI/Base/Rectangle/DevelopAgriculture")
onready var camera = tree.get_node("Camera")
onready var tiger_timer = tree.get_node("tiger_timer")
onready var tile_map = tree.get_node("TileMap")
onready var puddle = tree.get_node("TileMap/Puddle")
onready var quarry1 = tree.get_node("TileMap/Quarry1")
onready var quarry2 = tree.get_node("TileMap/Quarry2")
onready var lake = tree.get_node("TileMap/Lake")

var cave

export (PackedScene) var Unit2

var selected_units=[]
var all_units=[]
var all_plants=[]
var all_trees=[]
var all_pine_trees=[]
var all_quarries=[]
var all_pickables=[]
var sheltered=[]
var all_tigers=[]


var dragging = false
var selected = []
var drag_start = Vector2.ZERO
var select_rectangle = RectangleShape2D.new()


onready var draw_rect = get_tree().root.find_node("draw_rect")

var is_flipped = false

var screensize = Vector2(ProjectSettings.get("display/window/size/width"),ProjectSettings.get("display/window/size/height"))

var is_tiger=false
var is_tiger_coundown=false


signal is_arrow
signal is_basket
signal is_pick_mattock
signal is_sword
signal is_claypot
signal is_hand
signal is_axe
var arrow_mode=false
var basket_mode=false
var mattock_mode=false
var sword_mode=false
var claypot_mode=false
var hand_mode=false
var axe_mode=false

var start_string = """Recoge lodo, agua, alimentos, madera, piedra y hojas
para cumplir con cada uno de los hitos
marcados al seleccionar la
entrada de la cueva. Escapa de los tigres dientes de sable
o arrójales piedras haciendo
clic derecho sobre ellos estandoa gran distancia."""


func _ready():
	
	
	all_units=get_tree().get_nodes_in_group("units")
	tile_map=tree.find_node("TileMap")
	cave=tile_map.get_node("Cave")
	all_trees.append(tree.find_node("fruit_tree"))
	all_trees.append(tree.find_node("fruit_tree2"))
	all_trees.append(tree.find_node("fruit_tree3"))
	all_trees.append(tree.find_node("fruit_tree4"))
	all_trees.append(tree.find_node("fruit_tree5"))
	all_trees.append(tree.find_node("fruit_tree6"))
	all_plants.append(tree.find_node("Plant"));
	all_plants.append(tree.find_node("Plant2"));
	#all_units.append(tree.find_node("Unit2"))
	
	
	all_pine_trees.append(tree.find_node("PineTree1"))
	all_pine_trees.append(tree.find_node("PineTree2"))
	all_pine_trees.append(tree.find_node("PineTree3"))
	all_pine_trees.append(tree.find_node("PineTree4"))
	all_pine_trees.append(tree.find_node("PineTree5"))
	all_pine_trees.append(tree.find_node("PineTree6"))
	all_pine_trees.append(tree.find_node("PineTree7"))
	all_pine_trees.append(tree.find_node("PineTree8"))
	
	
	all_tigers.append(tree.find_node("Tiger1"))
	all_tigers.append(tree.find_node("Tiger2"))
	all_tigers.append(tree.find_node("Tiger3"))

	all_quarries.append(quarry1)
	all_quarries.append(quarry2)
	
	_create_unit();
	
		
	
	
	all_units[all_units.size()-1].position = Vector2(camera.get_viewport().size.x/6,camera.get_viewport().size.y/4)
	
	#Agregar ropa y bolso a todas las unidades
	for a_unit in all_units:
		a_unit.is_dressed=true
		a_unit.has_bag=true
		group_dressed=true
		group_has_bag=true
	
#	

	emit_signal("is_arrow")
	arrow_mode=true
	basket_mode=false
	mattock_mode=false
	sword_mode=false
	claypot_mode=false
	hand_mode=false
	axe_mode=false
	

func _process(_delta):
	
	timer_label.text = "ATAQUE ENEMIGO: " + str(int(tiger_timer.time_left))
	food_label.text = str(int(food_points))
	leaves_label.text = str(int(leaves_points))	
	stone_label.text = str(int(stone_points))	
	clay_label.text = str(int(clay_points))
	wood_label.text = str(int(wood_points))
	water_label.text = str(int(water_points))
	

	for a_unit in all_units:

		a_unit.position.x = clamp(a_unit.position.x,-1028,screensize.x)
		a_unit.position.y = clamp(a_unit.position.y,-608,screensize.y)
		
	if !is_tiger:
		if !is_tiger_coundown:
			tiger_timer.start()
			is_tiger_coundown=true	
	
	for a_tiger in all_tigers:
		if a_tiger.visible:
			_tiger_attack()

		
func select_unit(unit):
	if not selected_units.has(unit):
		selected_units.append(unit)
	#print("selected %s" % unit.name)
	#create_buttons()

func deselect_unit(unit):
	if selected_units.has(unit):
		selected_units.erase(unit)
	


func _create_unit():
	if food_points >=15:
		var new_Unit = Unit2.instance()
		unit_count+=1
		new_Unit.position = Vector2(camera.position.x+rand_range(50,100),camera.position.y+rand_range(50,100))
		if(unit_count%2==0):
			new_Unit.is_girl=true
		else:
			new_Unit.is_girl=false
		if(group_dressed):
			new_Unit.is_dressed=true	
		if(group_has_bag):
			new_Unit.has_bag=true	
			new_Unit.get_child(3).visible = true
		tile_map.add_child(new_Unit)
		food_points-=15	
		all_units.append(new_Unit)
		

			
func _check_victory():
	if is_fire_discovered && is_wheel_invented && is_stone_weapons_developed && is_claypot_made && is_agriculture_developed:
		prompts_label.text = "¡Has ganado!"		
		
func collect_pickable(var _pickable):
	for a_unit in all_units:
		if _pickable.type == "fruit_tree" or _pickable.type == "pine_tree" or _pickable.type == "plant" or _pickable.type == "quarry":
			if _pickable.touching && !_pickable.empty && a_unit.pickable_touching:
				var the_unit = all_units[all_units.find(a_unit,0)]
				if((abs(the_unit.position.x-_pickable.position.x)<50)&&
				(abs(the_unit.position.y-_pickable.position.y)<50)):
					if _pickable.type=="fruit_tree":
						if(the_unit.has_bag):
							if(_pickable.points>=4):
								food_points +=4
								_pickable.points-=4
							else:
								food_points += _pickable.points
								_pickable.points = 0
						else:					
							food_points +=1
							_pickable.points-=1
						#if _pickable.points <= 0:
						#_pickable.empty = true
					elif _pickable.type == "pine_tree":
						if(is_stone_weapons_developed):
							if(_pickable.points>=4):
								wood_points +=4
								_pickable.points-=4
							else:
								wood_points += _pickable.points
								_pickable.points = 0
						else:					
							wood_points +=1
							_pickable.points-=1
					elif _pickable.type == "plant":
						if(the_unit.has_bag):
							if(_pickable.points>=4):
								leaves_points +=4
								_pickable.points-=4
							else:
								leaves_points+=_pickable.points
								_pickable.points=0
						else:
							leaves_points+=1
							_pickable.points-=1
					elif _pickable.type == "quarry":
						if(is_stone_weapons_developed):
							if(_pickable.points>=4):
								stone_points+=4
								_pickable.points-=4
							else:
								stone_points+=_pickable.points
								_pickable.points=0
						else:
							stone_points+=1
							_pickable.points-=1
				if _pickable.points <= 0:
					_pickable.empty = true	
		else:
			if _pickable.touching && a_unit.pickable_touching:
				var the_unit = all_units[all_units.find(a_unit,0)]	
				var the_pickable = _pickable
				if the_pickable.touching:
					if the_pickable.type == "puddle" && the_unit.puddle_touching:
						clay_points+=4
					elif the_pickable.type == "lake" && the_unit.lake_touching:
						if is_claypot_made:
							water_points+=4
						else:
							prompts_label.text="Debes desarrollar el cuenco de barro \n para poder transportar agua."
				

				
func _get_damage():
	for a_unit in all_units:		
		for a_tiger in all_tigers:			
			if(a_unit.is_chased && a_unit.is_tiger_touching && !all_units.size()==0):
				var the_unit = all_units[all_units.find(a_unit,0)]
				if(the_unit.energy_points>0):
					if(!the_unit.is_dressed):
						the_unit.energy_points-=15
					else:
						the_unit.energy_points-=10
					#the_unit.get_child(4)._decrease_energy()
					the_unit.bar._set_energy_points(the_unit.energy_points)
					the_unit.bar._update_energy()
				else:
					the_unit._set_selected(false)			
					all_units.erase(the_unit)	
					the_unit._set_erased(true)
#								
					
			
	if(all_units.size()==0 && food_points<15):
		prompts_label.text = "Has sido derrotado."	
		
	
func _on_CreateCitizen_pressed():
	_create_unit()

func _on_food_timer_timeout():
	if(all_units.size()>-1):
		
		for a_tree in all_trees:
			collect_pickable(a_tree)
		
		for a_plant in all_plants:
			collect_pickable(a_plant)
		
		for a_quarry in all_quarries:
			collect_pickable(a_quarry)		
		
		for a_pine_tree in all_pine_trees:
			collect_pickable(a_pine_tree)
	
		collect_pickable(puddle)
		
		collect_pickable(lake)
		
		_check_victory()
		
	
	

func _tiger_attack():
	for i in range(all_tigers.size()):
		for j in range(all_units.size()):
			if !all_tigers[i].is_chasing && all_tigers[i].visible && !all_tigers[i].is_dead:
				var the_unit=all_units[j]
				var the_tiger=all_tigers[i]
				if !the_unit.is_chased && abs(the_unit.position.distance_to(the_tiger.position))<400:
					the_tiger.unit=the_unit
					the_unit.is_chased=true
					the_tiger.is_chasing=true
				

func _on_tiger_timer_timeout():
	for a_tiger in all_tigers:
		a_tiger.visible=true
		is_tiger=true

		
func deselect_all():
	while selected_units.size()>0:
		selected_units[0]._set_selected(false)
		
func was_pressed(obj):
	for unit in selected_units:
		if unit.name == obj.name:
			unit._set_selected(false)
			break
		
func get_units_in_area(area):
	var u=[]
	for unit in all_units:
		if unit.position.x>area[0].x and unit.position.x<area[1].x:
			if unit.position.y>area[0].y and unit.position.y<area[1].y:
				u.append(unit)
	return u
		
func area_selected(obj):
	var start=obj.start
	var end=obj.end
	var area=[]
	area.append(Vector2(min(start.x,end.x),min(start.y,end.y)))
	area.append(Vector2(max(start.x,end.x),max(start.y,end.y)))
	var ut = get_units_in_area(area)
	if not Input.is_key_pressed(KEY_SHIFT):
		deselect_all()
	for u in ut:
		u.selected = not u.selected
		

		
func start_move_selection(obj):
	for un in all_units:
		if un.selected:
			un.move_unit(obj.move_to_point)
		





func _on_damage_timer_timeout():
	_get_damage()

	

func _on_DevelopStoneWeapons_pressed():
	if stone_points>=70 && wood_points>=70 && leaves_points >=50:
		stone_points-=70
		wood_points-=70
		leaves_points-=50
		is_stone_weapons_developed=true	
		develop_stone_weapons.visible = false	
		
		


func _on_InventWheel_pressed():
	if stone_points >=70 && wood_points>=40:
		stone_points-=70
		wood_points-=40
		is_wheel_invented=true
		invent_wheel.visible = false

func _on_DiscoverFire_pressed():
	if wood_points >=60 && stone_points>=40:
		wood_points-=60
		stone_points-=40
		is_fire_discovered=true
		discover_fire.visible = false


func _on_Game2_is_arrow():
	Input.set_custom_mouse_cursor(arrow)
	arrow_mode=true
	basket_mode=false
	mattock_mode=false
	sword_mode=false
	claypot_mode=false
	hand_mode=false
	axe_mode=false


func _on_Game2_is_basket():
	Input.set_custom_mouse_cursor(basket)
	basket_mode=true
	arrow_mode=false
	mattock_mode=false
	sword_mode=false
	claypot_mode=false
	hand_mode=false
	axe_mode=false
	
func _on_Game2_is_pick_mattock():
	Input.set_custom_mouse_cursor(pick_mattock)
	mattock_mode=true
	basket_mode=false
	arrow_mode=false
	sword_mode=false
	claypot_mode=false
	hand_mode=false
	axe_mode=false


func _on_Game2_is_sword():
	Input.set_custom_mouse_cursor(sword)
	sword_mode=true
	mattock_mode=false
	basket_mode=false
	arrow_mode=false
	claypot_mode=false
	hand_mode=false
	axe_mode=false
	


func _on_Game2_is_hand():
	Input.set_custom_mouse_cursor(hand)
	hand_mode=true
	mattock_mode=false
	basket_mode=false
	arrow_mode=false
	sword_mode=false
	claypot_mode=false
	axe_mode=false
	


func _on_Game2_is_claypot():
	Input.set_custom_mouse_cursor(claypot)
	claypot_mode=true
	arrow_mode=false
	basket_mode=false
	mattock_mode=false
	sword_mode=false
	hand_mode=false
	axe_mode=false


func _on_Game2_is_axe():
	Input.set_custom_mouse_cursor(axe)
	axe_mode=true
	arrow_mode=false
	basket_mode=false
	mattock_mode=false
	sword_mode=false
	claypot_mode=false
	hand_mode=false


func _on_MakeClaypot_pressed():
	if clay_points>=85:
		clay_points-=85
		is_claypot_made=true
		make_claypot.visible=false


func _on_DevelopAgriculture_pressed():
	if food_points>=70 && leaves_points>=70 && water_points>=70:
		food_points-=70
		leaves_points-=70
		water_points-=70
		is_agriculture_developed=true
		develop_agriculture.visible=false
	
