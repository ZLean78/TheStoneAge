extends Node2D

#var basket=load("res://Scenes/MouseIcons/basket.png")
#var arrow=load("res://Scenes/MouseIcons/arrow.png")
#var pick_mattock=load("res://Scenes/MouseIcons/pick_mattock.png")
#var sword=load("res://Scenes/MouseIcons/sword.png")
#var claypot=load("res://Scenes/MouseIcons/claypot.png")
#var hand=load("res://Scenes/MouseIcons/hand.png")
#var axe=load("res://Scenes/MouseIcons/axe.png")

#Contador de unidades.
var unit_count = 1

#var food_points = 0
#var leaves_points = 0
#var stone_points = 0
#var wood_points = 0
#var clay_points = 0
#var water_points = 0

#Hitos anteriores ya cumplidos
var group_dressed = false
var group_has_bag = false

#Variables de hitos
var is_fire_discovered = false
var is_wheel_invented = false
var is_stone_weapons_developed = false
var is_claypot_made = false
var is_agriculture_developed = false


onready var tree = Globals.current_scene
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
onready var lake = tree.get_node("Lake")
onready var puddle = tree.get_node("Puddle")
onready var quarries = $Quarries
onready var units=$Units
onready var spawn_position=tree.get_node("SpawnPosition")
onready var tiger_spawn=tree.get_node("TigerSpawn")
onready var tiger_target=tree.get_node("TigerTarget")
onready var tigers=$Tigers
onready var tiger = preload("res://Scenes/Tiger/Tiger.tscn")
onready var fruit_trees=$FruitTrees
onready var pine_trees=$PineTrees
onready var plants=$Plants
onready var next_scene_confirmation=$UI/Base/NextSceneConfirmation
onready var exit_confirmation=$UI/Base/ExitConfirmation
onready var replay_confirmation=$UI/Base/ReplayConfirmation

#Nodo que dibuja el rectángulo de selección de la cámara.
onready var select_draw=$SelectDraw

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

var start_string = """Recoge lodo, agua, alimentos, madera, piedra y hojas
para cumplir con cada uno de los hitos
marcados al seleccionar la
entrada de la cueva. Escapa de los tigres dientes de sable
o arrójales piedras haciendo
clic derecho sobre ellos estandoa gran distancia."""

#Si el cursor está en forma de espada tocando un tigre, lo guardamos en esta variable.
var touching_enemy

func _ready():
	
	all_units=units.get_children()
	all_plants=plants.get_children()
	all_trees=fruit_trees.get_children()
	all_pine_trees=pine_trees.get_children()
	all_quarries=quarries.get_children()
	
	#tile_map=tree.find_node("TileMap")
	cave=get_node("Cave")
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
	
	
	#all_tigers.append(tree.find_node("Tiger1"))
	#all_tigers.append(tree.find_node("Tiger2"))
	#all_tigers.append(tree.find_node("Tiger3"))

#	all_quarries.append(quarry1)
#	all_quarries.append(quarry2)

	$UI.add_child(Globals.settings)
	
	_create_unit();
	
		
	
	
	
	
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
	var valid_counter=0
	for a_tiger in all_tigers:
		if is_instance_valid(a_tiger):
			valid_counter+=1
			
	if valid_counter==0:
		timer_label.text = "POSIBLE PELIGRO EN: " + str(int(tiger_timer.time_left))
	else:
		timer_label.text = "¡CUIDADO, HAY TIGRES!"
	
	
	food_label.text = str(int(Globals.food_points))
	leaves_label.text = str(int(Globals.leaves_points))	
	stone_label.text = str(int(Globals.stone_points))	
	clay_label.text = str(int(Globals.clay_points))
	wood_label.text = str(int(Globals.wood_points))
	water_label.text = str(int(Globals.water_points))
	
	_check_units()	
	_check_victory()
			
		
	if !is_tiger:
		if !is_tiger_coundown:
			tiger_timer.start()
			is_tiger_coundown=true	
	
	
			
		
func _select_unit(unit):
	if not selected_units.has(unit):
		selected_units.append(unit)
	#print("selected %s" % unit.name)
	#create_buttons()

func _deselect_unit(unit):
	if selected_units.has(unit):
		selected_units.erase(unit)			

		
func _deselect_all():
	while selected_units.size()>0:
		selected_units[0]._set_selected(false)
		
func _select_last():
	for unit in selected_units:
		if selected_units[selected_units.size()-1] == unit:
			unit._set_selected(true)
		else:
			unit._set_selected(false)
		
func _unhandled_input(event):
	if event.is_action_pressed("RightClick"):
		for i in range(0,selected_units.size()):			
			if i==0:
				selected_units[i].target_position=get_global_mouse_position()
			else:
				if i%4==0:
					selected_units[i].target_position=Vector2(selected_units[0].target_position.x,selected_units[i-1].target_position.y+20)
				else:
					selected_units[i].target_position=Vector2(selected_units[i-1].target_position.x+20,selected_units[i-1].target_position.y)
	if event.is_action_pressed("EscapeKey"):
		#Si el cursor está en modo flecha.
		if arrow_mode:
			if(all_units.size()==0 && Globals.food_points<15):
				replay_confirmation.visible=true
			else:
				exit_confirmation.popup()
				exit_confirmation.get_ok().text="Aceptar"
				exit_confirmation.get_cancel().text="cancelar"
		else:
			_on_Game2_is_arrow()
	if event.is_action_pressed("Settings"):
		Globals.settings.visible=!Globals.settings.visible
			
	
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
	Globals.food_points -= cost
	new_Unit.position = spawn_position.position
	for unit in units.get_children():
		if new_Unit.position==unit.position:
			new_Unit.position+=Vector2(20,20)
	units.add_child(new_Unit)
	all_units.append(new_Unit)
		

			
func _check_victory():
	if is_fire_discovered && is_wheel_invented && is_stone_weapons_developed && is_claypot_made && is_agriculture_developed:
		prompts_label.text = "¡Has ganado!"
		next_scene_confirmation.visible=true
			
		
	elif(all_units.size()==0 && Globals.food_points<15):
		prompts_label.text = "Has sido derrotado."	
		replay_confirmation.visible=true
		
		
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
	if Globals.food_points>=15:
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
	var valid_counter=0
	for a_tiger in all_tigers:
		if is_instance_valid(a_tiger):
			valid_counter+=1
	
	
	if valid_counter==0:	
		for tiger_counter in range(0,2):
			var new_tiger = tiger.instance()
			if tiger_counter==0:
				new_tiger.tiger_number=1
			if tiger_counter==1:
				new_tiger.tiger_number=2
			if tiger_counter==2:
				new_tiger.tiger_number=3
			new_tiger.position = tiger_spawn.position
			tigers.add_child(new_tiger)
			all_tigers.append(new_tiger)
			
	else:
		tiger_timer.start()
		
		
		
	for a_tiger in all_tigers:
		if is_instance_valid(a_tiger):
			a_tiger.visible=true
			is_tiger=true
			var random_num=randi()
			if random_num%2==0:
				a_tiger.target_position=spawn_position.position
			else:
				a_tiger.target_position=tiger_spawn.position

		

		
func get_units_in_area(area):
	var u=[]
	for unit in all_units:
		if unit.position.x>area[0].x and unit.position.x<area[1].x:
			if unit.position.y>area[0].y and unit.position.y<area[1].y:
				u.append(unit)
	return u

func _area_selected(obj):
	var start=obj.start
	var end=obj.end
	var area=[]
	area.append(Vector2(min(start.x,end.x),min(start.y,end.y)))
	area.append(Vector2(max(start.x,end.x),max(start.y,end.y)))
	var ut = get_units_in_area(area)
	if not Input.is_key_pressed(KEY_SHIFT):
		_deselect_all()
	for u in ut:
		u.selected = not u.selected
		

		
func start_move_selection(obj):
	for un in all_units:
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



#func _on_damage_timer_timeout():
#	_get_damage()

	

func _on_DevelopStoneWeapons_pressed():
	if Globals.stone_points>=70 && Globals.wood_points>=70 && Globals.leaves_points >=50:
		Globals.stone_points-=70
		Globals.wood_points-=70
		Globals.leaves_points-=50
		is_stone_weapons_developed=true	
		develop_stone_weapons.visible = false	
		
		


func _on_InventWheel_pressed():
	if Globals.stone_points >=70 && Globals.wood_points>=40:
		Globals.stone_points-=70
		Globals.wood_points-=40
		is_wheel_invented=true
		invent_wheel.visible = false

func _on_DiscoverFire_pressed():
	if Globals.wood_points >=60 && Globals.stone_points>=40:
		Globals.wood_points-=60
		Globals.stone_points-=40
		is_fire_discovered=true
		discover_fire.visible = false
		
func _on_MakeClaypot_pressed():
	if Globals.clay_points>=85:
		Globals.clay_points-=85
		is_claypot_made=true
		make_claypot.visible=false


func _on_DevelopAgriculture_pressed():
	if Globals.food_points>=70 && Globals.leaves_points>=70 && Globals.water_points>=70:
		Globals.food_points-=70
		Globals.leaves_points-=70
		Globals.water_points-=70
		is_agriculture_developed=true
		develop_agriculture.visible=false


func _on_Game2_is_arrow():
	Input.set_custom_mouse_cursor(Globals.arrow)
	arrow_mode=true
	basket_mode=false
	mattock_mode=false
	sword_mode=false
	claypot_mode=false
	hand_mode=false
	axe_mode=false


func _on_Game2_is_basket():
	Input.set_custom_mouse_cursor(Globals.basket)
	basket_mode=true
	arrow_mode=false
	mattock_mode=false
	sword_mode=false
	claypot_mode=false
	hand_mode=false
	axe_mode=false
	
func _on_Game2_is_pick_mattock():
	Input.set_custom_mouse_cursor(Globals.pick_mattock)
	mattock_mode=true
	basket_mode=false
	arrow_mode=false
	sword_mode=false
	claypot_mode=false
	hand_mode=false
	axe_mode=false


func _on_Game2_is_sword():
	Input.set_custom_mouse_cursor(Globals.sword)
	sword_mode=true
	mattock_mode=false
	basket_mode=false
	arrow_mode=false
	claypot_mode=false
	hand_mode=false
	axe_mode=false
	


func _on_Game2_is_hand():
	Input.set_custom_mouse_cursor(Globals.hand)
	hand_mode=true
	mattock_mode=false
	basket_mode=false
	arrow_mode=false
	sword_mode=false
	claypot_mode=false
	axe_mode=false
	


func _on_Game2_is_claypot():
	Input.set_custom_mouse_cursor(Globals.claypot)
	claypot_mode=true
	arrow_mode=false
	basket_mode=false
	mattock_mode=false
	sword_mode=false
	hand_mode=false
	axe_mode=false


func _on_Game2_is_axe():
	Input.set_custom_mouse_cursor(Globals.axe)
	axe_mode=true
	arrow_mode=false
	basket_mode=false
	mattock_mode=false
	sword_mode=false
	claypot_mode=false
	hand_mode=false



func _check_units():
	for a_unit in all_units:
		if a_unit.is_deleted:
			var the_unit=all_units[all_units.find(a_unit,0)]
			all_units.remove(all_units.find(a_unit,0))
			the_unit._die()
	
	



func _on_ExitConfirmation_confirmed():
	$UI.remove_child(Globals.settings)
	Globals.go_to_scene("res://Scenes/Menu/Menu.tscn")



func _on_ReplayOk_pressed():
	$UI.remove_child(Globals.settings)
	get_tree().reload_current_scene()


func _on_ReplayCancel_pressed():
	exit_confirmation.popup()
	exit_confirmation.get_ok().text="Aceptar"
	exit_confirmation.get_cancel().text="Cancelar"


func _on_NextSceneOk_pressed():
	$UI.remove_child(Globals.settings)
	Globals.go_to_scene("res://Scenes/Game3/Game3.tscn")
