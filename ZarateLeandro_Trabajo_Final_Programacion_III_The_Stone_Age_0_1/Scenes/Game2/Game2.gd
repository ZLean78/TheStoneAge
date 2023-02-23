extends Node2D

var unit_count = 1
var food_points = 15
var leaves_points = 0;
var is_tiger = false
var group_dressed = false
var group_has_bag = false



onready var tree = get_tree().root.get_child(0)
onready var food_timer = tree.get_node("food_timer")
onready var timer_label = tree.get_node("UI/Base/TimerLabel")
onready var food_label = tree.get_node("UI/Base/Rectangle/FoodLabel")
onready var prompts_label = tree.get_node("UI/Base/Rectangle/PromptsLabel")
onready var leaves_label = tree.get_node("UI/Base/Rectangle/LeavesLabel")
#onready var developments_label = tree.get_node("UI/Base/Rectangle/DevelopmentsLabel")
onready var rectangle = tree.get_node("UI/Base/Rectangle")
onready var add_clothes = tree.get_node("UI/Base/Rectangle/AddClothes")
onready var add_bag = tree.get_node("UI/Base/Rectangle/AddBag")
onready var camera = tree.get_node("Camera")
onready var tiger_timer = tree.get_node("tiger_timer")
onready var tile_map

var cave

export (PackedScene) var Unit2

var selected_units=[]
var all_units=[]
var all_plants=[]
var all_trees=[]
var sheltered=[]
var all_tigers=[]


var dragging = false
var selected = []
var drag_start = Vector2.ZERO
var select_rectangle = RectangleShape2D.new()


onready var draw_rect = get_tree().root.find_node("draw_rect")

var is_flipped = false

var screensize = Vector2(ProjectSettings.get("display/window/size/width"),ProjectSettings.get("display/window/size/height"))



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
	
	
	all_tigers.append(tree.find_node("Tiger1"))
	all_tigers.append(tree.find_node("Tiger2"))
	all_tigers.append(tree.find_node("Tiger3"))

	
	_create_unit();
	for a_tiger in all_tigers:
		#a_tiger.position=a_tiger.start_position
		a_tiger.visible=false
		#a_tiger.is_dead=true
		
	
	
	all_units[all_units.size()-1].position = Vector2(camera.get_viewport().size.x/6,camera.get_viewport().size.y/4)
	
	for a_tiger in all_tigers:
		for a_unit in all_units:
			a_tiger.units.append(a_unit)

func _process(_delta):
	
	timer_label.text = "ATAQUE ENEMIGO: " + str(int(tiger_timer.time_left))
	food_label.text = "COMIDA: " + str(int(food_points))
	leaves_label.text = "HOJAS: " + str(int(leaves_points))	
	#camera._set_its_raining(its_raining)

	for a_unit in all_units:

		a_unit.position.x = clamp(a_unit.position.x,-1028,screensize.x)
		a_unit.position.y = clamp(a_unit.position.y,-608,screensize.y)
		
		
		
	for a_tiger in all_tigers:
		for a_unit in all_units:
			if(a_tiger.position.distance_to(a_unit.position)<20):
				a_tiger.path_to_unit=a_unit
				
	_get_damage()
	
#func _physics_process(delta):
	
	#for a_tiger in all_tigers:
		#if a_tiger.is_dead:
			#a_tiger.visible=false
		#a_unit._set_its_raining(its_raining)
		
		#a_unit.move_unit(a_unit.target_position)
		
func select_unit(unit):
	if not selected_units.has(unit):
		selected_units.append(unit)
	#print("selected %s" % unit.name)
	#create_buttons()

func deselect_unit(unit):
	if selected_units.has(unit):
		selected_units.erase(unit)
	#print("deselected %s" % unit.name)
	#create_buttons()


func _create_unit():
	if food_points >=15:
		var new_Unit = Unit2.instance()
		unit_count+=1
		new_Unit.position = Vector2(camera.get_viewport().size.x/2,camera.get_viewport().size.y/2)
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
		
func _dress_units():
	for a_unit in all_units:
		if(!a_unit.is_dressed):
			a_unit.is_dressed = true
			
			
func _add_bag():
	for a_unit in all_units:
		if(!a_unit.has_bag):
			a_unit.has_bag = true	
			a_unit.get_child(3).visible=true	

func _collect_food():
	for a_unit in all_units:		
		for a_tree in all_trees:
			if a_tree.is_touching && !a_tree.is_empty && a_unit.fruit_tree_touching:
				var the_tree = all_trees[all_trees.find(a_tree,0)]
				var the_unit = all_units[all_units.find(a_unit,0)]
				if((abs(the_unit.position.x-the_tree.position.x)<5)&&
				(abs(the_unit.position.y-the_tree.position.y)<5)):
					if(the_unit.has_bag):
						if(the_tree.points>=4):
							food_points +=4
							the_tree.points-=4
						else:
							food_points += the_tree.points
							the_tree.points = 0
					else:					
						food_points +=1
						the_tree.points-=1
					if the_tree.points <= 0:
						the_tree.is_empty = true
						
func _collect_leaves():
	for a_unit in all_units:		
		for a_plant in all_plants:
			if a_plant.is_touching && !a_plant.is_empty && a_unit.plant_touching:
				var the_plant = all_plants[all_plants.find(a_plant,0)]
				var the_unit = all_units[all_units.find(a_unit,0)]
				if((abs(the_unit.position.x-the_plant.position.x)<5)&&
				(abs(the_unit.position.y-the_plant.position.y)<5)):	
					if(the_unit.has_bag):
						if(the_plant.points>=4):
							leaves_points+=4
							the_plant.points-=4
						else:
							leaves_points += the_plant.points
							the_plant.points = 0
					else:				
						leaves_points +=1
						the_plant.points-=1
					if the_plant.points <= 0:
						the_plant.is_empty = true
						
				
func _get_damage():
	for a_unit in all_units:		
		for a_tiger in all_tigers:			
			if(a_unit.is_tiger_touching && !all_units.size()==0):
				var the_unit = all_units[all_units.find(a_unit,0)]
				if(the_unit.energy_points>0):
					if(!the_unit.is_dressed):
						the_unit.energy_points-=3
					else:
						the_unit.energy_points-=1
					#the_unit.get_child(4)._decrease_energy()
					the_unit.get_child(5)._set_energy_points(the_unit.energy_points)
					the_unit.get_child(5)._update_energy()
				else:
					the_unit._set_selected(false)			
					all_units.erase(the_unit)	
					the_unit._set_erased(true)
#					else:
#						the_unit.visible = false
#						if(all_units.size()<=1 && food_points<15):
#							$The_Canvas._set_phrase("Has sido derrotado.")				
					
			
	if(all_units.size()==0 && food_points<15):
		prompts_label.text = "Has sido derrotado."	
		
	
func _on_CreateCitizen_pressed():
	_create_unit()

func _on_food_timer_timeout():
	if(all_units.size()>-1):
		_collect_food()
		_collect_leaves()
	
	

func _tiger_attack():
	for a_tiger in all_tigers:
		for a_unit in all_units:
			if a_tiger.position.distance_to(a_unit.position)<20:
				var the_unit=a_unit
				a_tiger.move_tiger(the_unit.position)
				#emit_signal("start_move_tigers")
			else:
				a_tiger.move_tiger(cave.position)
			
				
	



func _on_tiger_timer_timeout():
	is_tiger=true
	for a_tiger in all_tigers:
		#a_tiger.is_dead=false
		a_tiger.visible=true
		#a_tiger.position=a_tiger.start_position	
		
			


func _on_AddClothes_pressed():
	if leaves_points >=70:
		leaves_points-=70
		_dress_units()
		group_dressed = true
		add_clothes.visible = false
	


func _on_AddBag_pressed():
	if leaves_points >=50:
		leaves_points-=50
		_add_bag()
		group_has_bag = true
		add_bag.visible = false
		
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
		




