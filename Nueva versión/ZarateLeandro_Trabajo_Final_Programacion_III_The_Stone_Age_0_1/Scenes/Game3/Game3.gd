extends Node2D

var basket=load("res://Scenes/MouseIcons/basket.png")
var arrow=load("res://Scenes/MouseIcons/arrow.png")
var pick_mattock=load("res://Scenes/MouseIcons/pick_mattock.png")
var sword=load("res://Scenes/MouseIcons/sword.png")
var claypot=load("res://Scenes/MouseIcons/claypot.png")
var hand=load("res://Scenes/MouseIcons/hand.png")
var axe=load("res://Scenes/MouseIcons/axe.png")
var house=load("res://Scenes/MouseIcons/house.png")
var townhall=load("res://Scenes/MouseIcons/townHall.png")

var unit_count = 1
var food_points = 0
var leaves_points = 0
var stone_points = 0
var wood_points = 0
var clay_points = 0
var water_points = 0

#Hitos anteriores ya cumplidos
var group_dressed = false
var group_has_bag = false
var is_fire_discovered = true
var is_wheel_invented = true
var is_stone_weapons_developed = true
var is_claypot_made = true
var is_agriculture_developed = true

#Variables de hitos
onready var mammoths=$Mammoths
var is_townhall_created = false


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
#onready var create_shack = tree.get_node("UI/Base/Rectangle/CreateHouse")
onready var give_attack_order = tree.get_node("UI/Base/Rectangle/GiveAttackOrder")
onready var make_warchief = tree.get_node("UI/Base/Rectangle/MakeWarchief")
onready var create_house = tree.get_node("UI/Base/Rectangle/CreateHouse")
onready var create_townhall = tree.get_node("UI/Base/Rectangle/CreateTownHall")
onready var create_warrior = tree.get_node("UI/Base/Rectangle/CreateWarriorUnit")
onready var next_scene_button = tree.get_node("UI/Base/NextSceneButton")
onready var camera = tree.get_node("Camera")
onready var tiger_timer = tree.get_node("tiger_timer")
onready var tile_map = tree.get_node("TileMap")
onready var puddle = tree.get_node("TileMap/Puddle")
onready var quarry1 = tree.get_node("TileMap/Quarry1")
onready var quarry2 = tree.get_node("TileMap/Quarry2")
onready var lake = tree.get_node("TileMap/Lake")
onready var spawn_position = $SpawnPosition
onready var tiger_spawn = $TigerSpawn
onready var tiger_target = $TigerTarget
onready var units = $Units
onready var warriors = $Warriors
onready var houses = $Houses

var cave

export (PackedScene) var Unit2
export (PackedScene) var Warrior
export (PackedScene) var House
export (PackedScene) var TownHall

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
#var select_rectangle = RectangleShape2D.new()


onready var draw_rect = get_tree().root.find_node("draw_rect")

var is_flipped = false

var screensize = Vector2(ProjectSettings.get("display/window/size/width"),ProjectSettings.get("display/window/size/height"))

var is_tiger=false
var is_tiger_countdown=false


signal is_arrow
signal is_basket
signal is_pick_mattock
signal is_sword
signal is_claypot
signal is_hand
signal is_axe
signal is_house
var arrow_mode=false
var basket_mode=false
var mattock_mode=false
var sword_mode=false
var claypot_mode=false
var hand_mode=false
var axe_mode=false
var house_mode=false
var townhall_mode=false

var start_string = """Selecciona una unidad de tu grupo y haz clic en el botón
"convertir en jefe guerrero" para que pase a ser el jefe de tu tribu."""

#Si el cursor está en forma de espada tocando un tigre, lo guardamos en esta variable.
var touching_enemy

var row=0
var column=0

func _ready():
	
	prompts_label.text = start_string
	
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
	
	all_tigers[0].position=Vector2(tiger_spawn.position.x,tiger_spawn.position.y-100)
	all_tigers[0].tiger_number=1
	all_tigers[1].position=Vector2(tiger_spawn.position.x,tiger_spawn.position.y-200)
	all_tigers[1].tiger_number=2
	all_tigers[2].position=Vector2(tiger_spawn.position.x,tiger_spawn.position.y-300)
	all_tigers[2].tiger_number=3

	all_quarries.append(quarry1)
	all_quarries.append(quarry2)
	
	for i in range(0,11):
		_create_unit();
	
	for i in range(0,12):
		if i==0:
			all_units[i].position = Vector2(camera.position.x+50,camera.position.y+50)
			#all_units[i].position = Vector2(camera.get_viewport().size.x/6,camera.get_viewport().size.y/4)
		else:
			if i<4:
				all_units[i].position =	Vector2(all_units[i-1].position.x+20,all_units[i-1].position.y)
			elif i>=4 && i<8:
				if i==4:
					all_units[i].position =	Vector2(all_units[0].position.x,all_units[0].position.y+20)
				else:
					all_units[i].position = Vector2(all_units[i-1].position.x+20,all_units[i-1].position.y)
			elif i>=8:
				if i==8:
					all_units[i].position = Vector2(all_units[0].position.x,all_units[0].position.y+40)
				else:
					all_units[i].position = Vector2(all_units[i-1].position.x+20,all_units[i-1].position.y)
	
	
	
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
	
	_check_units()
	_check_mammoths()
	_check_houses()
	_check_victory()
	

		
		
	if !is_tiger:
		if !is_tiger_countdown:
			tiger_timer.start()
			is_tiger_countdown=true	
	
	

		
func select_unit(unit):
	if not selected_units.has(unit):
		selected_units.append(unit)
	#print("selected %s" % unit.name)
	#create_buttons()

func deselect_unit(unit):
	if selected_units.has(unit):
		selected_units.erase(unit)
	
func _unhandled_input(event):
	if event is InputEventMouseButton && event.is_action_pressed("ui_right_mouse_button"):
		if !house_mode:
			for i in range(0,selected_units.size()):
				if i==0:
					selected_units[i].target_position=get_global_mouse_position()
				else:
					if i%4==0:
						selected_units[i].target_position=Vector2(selected_units[0].target_position.x,selected_units[i-1].target_position.y+20)
					else:
						selected_units[i].target_position=Vector2(selected_units[i-1].target_position.x+20,selected_units[i-1].target_position.y)
		if house_mode:
			_create_house()
		if townhall_mode:
			_create_townhall()

func _create_townhall():
	var citizens=units.get_children()
	
	for citizen in citizens:
		if citizen.selected:
			if wood_points>=80 && leaves_points>=90 && clay_points>=100:					
				var new_townhall=TownHall.instance()
				#the_citizen.agent.set_target_location(get_global_mouse_position())
				new_townhall.position = get_global_mouse_position()
				tile_map.add_child(new_townhall)
				citizen.target_position=new_townhall.position
				wood_points-=80
				leaves_points-=90
				clay_points-=100
									
				
func _create_house():
	var citizens=units.get_children()
	var dwells=houses.get_children()
	var dwell_count=0
	var the_citizen=null
		
	for citizen in citizens:
		if (citizens.size()/4)>dwells.size():			
			if citizen.selected:
				the_citizen=citizen
				break
				
	if the_citizen!=null:
		if wood_points>=20 && clay_points>=40:					
			var new_house=House.instance()
			#the_citizen.agent.set_target_location(get_global_mouse_position())
			new_house.position = get_global_mouse_position()
			houses.add_child(new_house)
			the_citizen.target_position=new_house.position
			wood_points-=20
			clay_points-=40
			print("Se construyó la casa.")
		
	

func _check_houses():
	var dwells=houses.get_children()
	var dwell_count=0	
	
	for dwell in dwells:
		dwell_count+=1
	
	if dwell_count>=4:
		create_townhall.visible=true	
	
func _create_unit(cost = 0):
	var new_Unit = Unit2.instance()
	unit_count+=1
	if(unit_count%2==0):
		new_Unit.is_girl=true
	else:
		new_Unit.is_girl=false
	if(group_dressed):
		new_Unit.is_dressed=true	
	if(group_has_bag):
		new_Unit.has_bag=true	
		new_Unit.get_child(3).visible = true
	food_points -= cost
	new_Unit.position = spawn_position.position
	for unit in units.get_children():
		if new_Unit.position==unit.position:
			new_Unit.position+=Vector2(20,20)		
	units.add_child(new_Unit)
	all_units.append(new_Unit)
		
func _create_warrior_unit(cost = 0):
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
	food_points -= cost
	units.add_child(new_Unit)
	all_units.append(new_Unit)
			
func _check_victory():
	for child in tile_map.get_children():
		if "TownHall" in child.name:
			if child.condition==80:
				is_townhall_created=true
	
	
	if is_townhall_created:
		prompts_label.text = "¡Has ganado!"	
		next_scene_button.visible = true
	elif(all_units.size()==0 && food_points<15):
		prompts_label.text = "Has sido derrotado."
	else:
		for a_unit in all_units:
			if "Unit" in a_unit.name && a_unit.is_warchief && a_unit.is_deleted:
				prompts_label.text = "Has sido derrotado. Tu jefe ha muerto."	
		
#func collect_pickable(var _pickable):
#	for a_unit in all_units:
#		if _pickable.type == "fruit_tree" or _pickable.type == "pine_tree" or _pickable.type == "plant" or _pickable.type == "quarry":
#			if _pickable.touching && !_pickable.empty && a_unit.pickable_touching:
#				var the_unit = all_units[all_units.find(a_unit,0)]
#				if((abs(the_unit.position.x-_pickable.position.x)<50)&&
#				(abs(the_unit.position.y-_pickable.position.y)<50)):
#					if _pickable.type=="fruit_tree":
#						if(the_unit.has_bag):
#							if(_pickable.points>=4):
#								food_points +=4
#								_pickable.points-=4
#							else:
#								food_points += _pickable.points
#								_pickable.points = 0
#						else:					
#							food_points +=1
#							_pickable.points-=1
#						#if _pickable.points <= 0:
#						#_pickable.empty = true
#					elif _pickable.type == "pine_tree":
#						if(is_stone_weapons_developed):
#							if(_pickable.points>=4):
#								wood_points +=4
#								_pickable.points-=4
#							else:
#								wood_points += _pickable.points
#								_pickable.points = 0
#						else:					
#							wood_points +=1
#							_pickable.points-=1
#					elif _pickable.type == "plant":
#						if(the_unit.has_bag):
#							if(_pickable.points>=4):
#								leaves_points +=4
#								_pickable.points-=4
#							else:
#								leaves_points+=_pickable.points
#								_pickable.points=0
#						else:
#							leaves_points+=1
#							_pickable.points-=1
#					elif _pickable.type == "quarry":
#						if(is_stone_weapons_developed):
#							if(_pickable.points>=4):
#								stone_points+=4
#								_pickable.points-=4
#							else:
#								stone_points+=_pickable.points
#								_pickable.points=0
#						else:
#							stone_points+=1
#							_pickable.points-=1
#				if _pickable.points <= 0:
#					_pickable.empty = true	
#		else:
#			if _pickable.touching && a_unit.pickable_touching:
#				var the_unit = all_units[all_units.find(a_unit,0)]	
#				var the_pickable = _pickable
#				if the_pickable.touching:
#					if the_pickable.type == "puddle" && the_unit.puddle_touching:
#						clay_points+=4
#					elif the_pickable.type == "lake" && the_unit.lake_touching:
#						if is_claypot_made:
#							water_points+=4
#						else:
#							prompts_label.text="Debes desarrollar el cuenco de barro \n para poder transportar agua."
#

#
#func _get_damage():
#	for a_unit in all_units:		
#		for a_tiger in all_tigers:			
#			if(a_unit.is_chased && a_unit.is_tiger_touching && !all_units.size()==0):
#				var the_unit = all_units[all_units.find(a_unit,0)]
#				var the_tiger = all_tigers[all_tigers.find(a_tiger,0)]
#				if(the_unit.energy_points>0):
#					if(!the_unit.is_dressed):
#						the_unit.energy_points-=15
#					else:
#						the_unit.energy_points-=10
#					#the_unit.get_child(4)._decrease_energy()
#					the_unit.bar._set_energy_points(the_unit.energy_points)
#					the_unit.bar._update_energy()
#				else:
#					the_tiger.unit = null
#					the_unit._set_selected(false)			
#					all_units.erase(the_unit)	
#					the_unit.queue_free()
##								
#
#
#	if(all_units.size()==0 && food_points<15):
#		prompts_label.text = "Has sido derrotado."	
		
	
func _on_CreateCitizen_pressed():
	if food_points>=15:
		_create_unit(15)
		


		
#		for a_tree in all_trees:
#			collect_pickable(a_tree)
#
#		for a_plant in all_plants:
#			collect_pickable(a_plant)
#
#		for a_quarry in all_quarries:
#			collect_pickable(a_quarry)		
#
#		for a_pine_tree in all_pine_trees:
#			collect_pickable(a_pine_tree)
#
#		collect_pickable(puddle)
#
#		collect_pickable(lake)
		
		
		
	
	

#func _tiger_attack():
#	for i in range(all_tigers.size()):
#		for j in range(all_units.size()):
#			if all_tigers[i].is_chasing && all_tigers[i].visible && !all_tigers[i].is_dead:
#					var the_unit=all_units[j]
#					var the_tiger=all_tigers[i]
#					if !the_unit.is_chased && abs(the_unit.position.distance_to(the_tiger.position))<400:
#						the_tiger.unit=the_unit
#						the_unit.is_chased=true
#						the_tiger.is_chasing=true
#			elif all_tigers[i].is_dead:
#				var the_tiger=all_tigers[i]
#				all_tigers.remove(the_tiger)
#				the_tiger.queue_free()


					
					
				

func _on_tiger_timer_timeout():
	for a_tiger in all_tigers:
		if is_instance_valid(a_tiger):
			a_tiger.visible=true
			a_tiger.state=1

		
func deselect_all():
	while selected_units.size()>0:
		selected_units[0]._set_selected(false)
		
func select_last():
	for unit in selected_units:
		if selected_units[selected_units.size()-1] == unit:
			unit._set_selected(true)
		else:
			unit._set_selected(false)
		
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
		


"""func move_group():
	var pos_minus_one=0
	for i in range (0,selected_units.size()):
		if i==0:
			selected_units[i].target_position = get_global_mouse_position()	
		else:
			if i%4==0:
				selected_units[i].target_position =	Vector2(get_global_mouse_position().x,pos_minus_one.y+20)
			else:
				selected_units[i].target_position =	Vector2(pos_minus_one.x+20,pos_minus_one.y)
		pos_minus_one=selected_units[i].target_position"""

	



func _on_Game3_is_arrow():
	Input.set_custom_mouse_cursor(arrow)
	arrow_mode=true
	basket_mode=false
	mattock_mode=false
	sword_mode=false
	claypot_mode=false
	hand_mode=false
	axe_mode=false
	house_mode=false
	townhall_mode=false


func _on_Game3_is_basket():
	Input.set_custom_mouse_cursor(basket)
	basket_mode=true
	arrow_mode=false
	mattock_mode=false
	sword_mode=false
	claypot_mode=false
	hand_mode=false
	axe_mode=false
	house_mode=false
	townhall_mode=false
	
func _on_Game3_is_pick_mattock():
	Input.set_custom_mouse_cursor(pick_mattock)
	mattock_mode=true
	basket_mode=false
	arrow_mode=false
	sword_mode=false
	claypot_mode=false
	hand_mode=false
	axe_mode=false
	house_mode=false
	townhall_mode=false

func _on_Game3_is_sword():
	Input.set_custom_mouse_cursor(sword)
	sword_mode=true
	mattock_mode=false
	basket_mode=false
	arrow_mode=false
	claypot_mode=false
	hand_mode=false
	axe_mode=false
	house_mode=false
	townhall_mode=false

func _on_Game3_is_hand():
	Input.set_custom_mouse_cursor(hand)
	hand_mode=true
	mattock_mode=false
	basket_mode=false
	arrow_mode=false
	sword_mode=false
	claypot_mode=false
	axe_mode=false
	house_mode=false
	townhall_mode=false


func _on_Game3_is_claypot():
	Input.set_custom_mouse_cursor(claypot)
	claypot_mode=true
	arrow_mode=false
	basket_mode=false
	mattock_mode=false
	sword_mode=false
	hand_mode=false
	axe_mode=false
	house_mode=false
	townhall_mode=false

func _on_Game3_is_axe():
	Input.set_custom_mouse_cursor(axe)
	axe_mode=true
	arrow_mode=false
	basket_mode=false
	mattock_mode=false
	sword_mode=false
	claypot_mode=false
	hand_mode=false
	house_mode=false
	townhall_mode=false
	
func _on_Game3_is_house():
	Input.set_custom_mouse_cursor(house)
	house_mode=true
	arrow_mode=false
	basket_mode=false
	mattock_mode=false
	sword_mode=false
	claypot_mode=false
	hand_mode=false
	axe_mode=false
	townhall_mode=false
				
	
func _on_Game3_is_townhall():
	Input.set_custom_mouse_cursor(townhall)	
	townhall_mode=true
	arrow_mode=false
	basket_mode=false
	mattock_mode=false
	sword_mode=false
	claypot_mode=false
	hand_mode=false
	axe_mode=false
	house_mode=false
	
				

func _check_units():
	for a_unit in all_units:
		if a_unit.is_deleted && is_instance_valid(a_unit):
			if "Unit" in a_unit.name:
				if !a_unit.is_warchief:
					var the_unit=all_units[all_units.find(a_unit,0)]
					all_units.remove(all_units.find(a_unit,0))
#					for a_tiger in all_tigers:
#						if is_instance_valid(a_tiger):
#							if a_tiger.unit == the_unit:
#								a_tiger.unit = null
					the_unit._die()
			if "Warrior" in a_unit.name:
				var the_unit=all_units[all_units.find(a_unit,0)]
				all_units.remove(all_units.find(a_unit,0))
				the_unit._die()
	





func _on_MakeWarchief_pressed():
	if selected_units.size()==1:
		selected_units[0].is_warchief=true
		selected_units[0].warchief_mark.visible=true
		create_warrior.visible=true
		make_warchief.visible=false
		prompts_label.text = "¡Ya tienes a tu jefe! Utilízalo para entrenar unidades militares\ncon el botón de crear unidad militar."
	elif selected_units.size()>1:
		prompts_label.text = "Debes seleccionar una sola unidad."
	elif selected_units.size()==0:
		prompts_label.text = "Selecciona una unidad."


func _on_CreateWarriorUnit_pressed():
	var warriors_count=0
	if food_points>=30 && wood_points>=20 && stone_points>=10:
		var new_warrior = Warrior.instance()
		new_warrior.position = spawn_position.position
		for warrior in warriors.get_children():
			warriors_count+=1				
			if new_warrior.position == warrior.position:
				column+=1
			#if new_warrior.position.x>cave.position.x:
			if column==10:
				column=0
				row+=1
			new_warrior.position=spawn_position.position+Vector2(20*column,20*row)
		
		warriors.add_child(new_warrior)
		all_units.append(new_warrior)
		food_points-=30
		wood_points-=20
		stone_points-=10
	
	if warriors_count>=3:
		prompts_label.text="Cuando consideres que tienes suficientes guerreros,\nenvíalos a pelear contra los mamuts,\nal noroeste del lago."

func _check_mammoths():
	var mammoths_count=0
	
	for mammoth in mammoths.get_children():
		mammoths_count+=1
	
	if mammoths_count==0:
		prompts_label.text="""Regresa cerca de la cueva y haz que tus ciudadanos
		construyan cuatro casas en la zona. Obtén los recursos necesarios
		y haz clic en un ciudadano para llevar a cabo la tarea. Debes construir 
		una	casa cada cuatro civiles."""	
		create_house.visible=true

func _on_CreateHouse_pressed():
	if !house_mode:
		_on_Game3_is_house()
	else:
		_on_Game3_is_arrow()


func _on_GiveAttackOrder_pressed():
	pass # Replace with function body.


func _on_CreateTownHall_pressed():
	if !townhall_mode:
		_on_Game3_is_townhall()
	else:
		_on_Game3_is_arrow()


func _on_NextSceneButton_pressed():
	get_tree().change_scene("res://Scenes/Menu/Menu.tscn")
