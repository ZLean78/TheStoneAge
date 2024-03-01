extends Node2D

var basket=load("res://Scenes/MouseIcons/basket.png")
var arrow=load("res://Scenes/MouseIcons/arrow.png")
var pick_mattock=load("res://Scenes/MouseIcons/pick_mattock.png")
var sword=load("res://Scenes/MouseIcons/sword.png")
var claypot=load("res://Scenes/MouseIcons/claypot.png")
var hand=load("res://Scenes/MouseIcons/hand.png")
var axe=load("res://Scenes/MouseIcons/axe.png")

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
onready var create_shack = tree.get_node("UI/Base/Rectangle/CreateShack")
onready var give_attack_order = tree.get_node("UI/Base/Rectangle/GiveAttackOrder")
onready var create_warrior_unit = tree.get_node("UI/Base/Rectangle/CreateWarriorUnit")
onready var make_warchief = tree.get_node("UI/Base/Rectangle/MakeWarchief")
#onready var make_claypot = tree.get_node("UI/Base/Rectangle/MakeClaypot")
onready var develop_agriculture = tree.get_node("UI/Base/Rectangle/DevelopAgriculture")
onready var camera = tree.get_node("Camera")
onready var tiger_timer = tree.get_node("tiger_timer")
onready var tile_map = tree.get_node("TileMap")
onready var puddle = tree.get_node("TileMap/Puddle")
onready var quarry1 = tree.get_node("TileMap/Quarry1")
onready var quarry2 = tree.get_node("TileMap/Quarry2")
onready var lake = tree.get_node("TileMap/Lake")


############################################
#CLASSES NODES
############################################

onready var units_node=tree.get_node("Units")



###############################################

var cave

export (PackedScene) var Unit3

var selected_units=[]

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

var start_string="Convierte a una de las unidades en jefe de grupo."

#Si el cursor está en forma de espada tocando un tigre, lo guardamos en esta variable.
var touching_tiger

func _ready():
	
	
	
	
	tile_map=tree.find_node("TileMap")
	cave=tile_map.get_node("Cave")
	
	
	for i in range(0,11):
		_create_unit();
		
	
	for i in range(0,12):
		if i==0:
			units_node.get_child(i).position = Vector2(camera.position.x+50,camera.position.y+50)
			#all_units[i].position = Vector2(camera.get_viewport().size.x/6,camera.get_viewport().size.y/4)
		else:
			if i<4:
				units_node.get_child(i).position =	Vector2(units_node.get_child(i-1).position.x+20,units_node.get_child(i-1).position.y)
			elif i>=4 && i<8:
				if i==4:
					units_node.get_child(i).position =	Vector2(units_node.get_child(0).position.x,units_node.get_child(0).position.y+20)
				else:
					units_node.get_child(i).position = Vector2(units_node.get_child(i-1).position.x+20,units_node.get_child(i-1).position.y)
			elif i>=8:
				if i==8:
					units_node.get_child(i).position = Vector2(units_node.get_child(0).position.x,units_node.get_child(0).position.y+40)
				else:
					units_node.get_child(i).position = Vector2(units_node.get_child(i-1).position.x+20,units_node.get_child(i-1).position.y)
	
	
	
	
	
#	

	emit_signal("is_arrow")
	arrow_mode=true
	basket_mode=false
	mattock_mode=false
	sword_mode=false
	claypot_mode=false
	hand_mode=false
	axe_mode=false
	
	prompts_label.text=start_string
	create_warrior_unit.visible = false

func _process(_delta):
	
	timer_label.text = "ATAQUE ENEMIGO: " + str(int(tiger_timer.time_left))
	food_label.text = str(int(food_points))
	leaves_label.text = str(int(leaves_points))	
	stone_label.text = str(int(stone_points))	
	clay_label.text = str(int(clay_points))
	wood_label.text = str(int(wood_points))
	water_label.text = str(int(water_points))
	
	_check_units()
	_check_victory()
	#for a_unit in all_units:

		
		
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
	


func _create_unit(cost = 0):
	var new_Unit = Unit3.instance()
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
	units_node.add_child(new_Unit)
	
		
func _create_warrior_unit(cost = 0):
	var new_Unit = Unit3.instance()
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
	tile_map.add_child(new_Unit)
	
			
func _check_victory():
	if is_fire_discovered && is_wheel_invented && is_stone_weapons_developed && is_claypot_made && is_agriculture_developed:
		prompts_label.text = "¡Has ganado!"	
	elif(units_node.get_child_count()==0 && food_points<15):
		prompts_label.text = "Has sido derrotado."
	else:
		for a_unit in units_node.get_children():
			if a_unit.is_warchief && a_unit.is_deleted:
				prompts_label.text = "Has sido derrotado. Tu jefe ha muerto."	
		

		
	
func _on_CreateCitizen_pressed():
	if food_points>=15:
		_create_unit(15)
		





func _tiger_attack():
	for i in range(all_tigers.size()):
		for j in range(units_node.get_child_count()):
			if !all_tigers[i].is_chasing && all_tigers[i].visible && !all_tigers[i].is_dead:
				var the_unit=units_node.get_child(j)
				var the_tiger=all_tigers[i]
				if the_unit!=null && !the_unit.is_chased && abs(the_unit.position.distance_to(the_tiger.position))<400:
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
		
func select_last():
	for unit in selected_units:
		if selected_units[selected_units.size()-1] == unit:
			unit._set_selected(true)
		else:
			unit._set_selected(false)
		
func get_units_in_area(area):
	var u=[]
	for unit in units_node.get_children():
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
	for un in units_node.get_children():
		if un.selected:
			un.move_unit(obj.move_to_point)
		


func move_group():
	var pos_minus_one=0
	for i in range (0,selected_units.size()):
		if i==0:
			selected_units[i].target_position = get_global_mouse_position()	
		else:
			if i%4==0:
				selected_units[i].target_position =	Vector2(get_global_mouse_position().x,pos_minus_one.y+20)
			else:
				selected_units[i].target_position =	Vector2(pos_minus_one.x+20,pos_minus_one.y)
		pos_minus_one=selected_units[i].target_position

	

func _on_DevelopStoneWeapons_pressed():
	if stone_points>=70 && wood_points>=70 && leaves_points >=50:
		stone_points-=70
		wood_points-=70
		leaves_points-=50
		is_stone_weapons_developed=true	
		#develop_stone_weapons.visible = false	
		
		


func _on_InventWheel_pressed():
	if stone_points >=70 && wood_points>=40:
		stone_points-=70
		wood_points-=40
		is_wheel_invented=true
		#invent_wheel.visible = false

func _on_DiscoverFire_pressed():
	if wood_points >=60 && stone_points>=40:
		wood_points-=60
		stone_points-=40
		is_fire_discovered=true
		#discover_fire.visible = false
		
func _on_MakeClaypot_pressed():
	if clay_points>=85:
		clay_points-=85
		is_claypot_made=true
		#make_claypot.visible=false


func _on_DevelopAgriculture_pressed():
	if food_points>=70 && leaves_points>=70 && water_points>=70:
		food_points-=70
		leaves_points-=70
		water_points-=70
		is_agriculture_developed=true
		develop_agriculture.visible=false


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


func _check_units():
	for a_unit in units_node.get_children():
		if a_unit.is_deleted:
			if !a_unit.is_warchief:
				var the_unit=a_unit
				for a_tiger in all_tigers:
					if a_tiger.unit == the_unit:
						a_tiger.unit = null
						the_unit._die()
						the_unit.queue_free()
	
	





func _on_MakeWarchief_pressed():
	if selected_units.size()==1:
		selected_units[0].is_warchief=true
		prompts_label.text = "¡Ya tienes a tu jefe! Úsalo para entrenar unidades 'cazador'.\nNecesitas crear al menos 6."
		create_warrior_unit.visible = true	
	elif selected_units.size()>1:
		prompts_label.text = "Debes seleccionar una sola unidad."
	elif selected_units.size()==0:
		prompts_label.text = "Selecciona una sola unidad."


func _on_CreateWarriorUnit_pressed():
	pass # Replace with function body.


func _on_CreateShack_pressed():
	pass # Replace with function body.





func _on_GiveAttackOrder_pressed():
	pass # Replace with function body.
