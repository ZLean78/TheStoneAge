extends Node2D

#Variables de íconos del mouse.
#var basket=load("res://Scenes/MouseIcons/basket.png")
#var arrow=load("res://Scenes/MouseIcons/arrow.png")

#Conteo de unidades ciudadanos.
var unit_count = 1


#Condiciones que afectan a toda la comunidad
var its_raining = false
#var group_dressed = false
#var group_has_bag = false

#Variables de referencia a cada uno de los nodos del árbol con los que vamos
#a trabajar en este script.

#Nodos de escenario.
onready var tree = Globals.current_scene
onready var food_timer = $food_timer
onready var camera = $Camera
onready var rain_timer = $Rain_Timer
onready var tile_map = $TileMap
onready var cave = $TileMap/Cave

#Nodos de interfaz UI
onready var timer_label = $UI/Base/TimerLabel
onready var food_label = $UI/Base/Rectangle/FoodLabel
onready var prompts_label = $UI/Base/Rectangle/PromptsLabel
onready var leaves_label = $UI/Base/Rectangle/LeavesLabel

onready var rectangle = $UI/Base/Rectangle
onready var add_clothes = $UI/Base/Rectangle/AddClothes
onready var add_bag = $UI/Base/Rectangle/AddBag
onready var next_scene_confirmation = $UI/Base/NextSceneConfirmation
onready var exit_confirmation = $UI/Base/ExitConfirmation
onready var replay_confirmation = $UI/Base/ReplayConfirmation

#Nodo que dibuja el rectángulo de selección de la cámara.
onready var select_draw=$SelectDraw

#Variable unidad ciudadano original a partir de la cual se crean todas las demás.
export (PackedScene) var Unit

#Arreglos para las unidades en general, para las seleccionadas
#y las que están a resguardo de la lluvia.
var all_units=[]
var selected_units=[]
var sheltered=[]

#Arreglos para los tipos de objetos "pickable", que son aquellos
#de los que se pueden recolectar recursos.
var all_plants=[]
var all_trees=[]

#Variables a eliminar del sistema de selección anterior del programa
#var dragging = false
#var selected = []
#var drag_start = Vector2.ZERO
#var select_rectangle = RectangleShape2D.new()




#Variable booleana para conocer si el objeto en función está invertido en x o y (?).
var is_flipped = false

#Variable que controla el tamaño de la pantalla.
var screensize = Vector2(ProjectSettings.get("display/window/size/width"),ProjectSettings.get("display/window/size/height"))

#Señales para cambiar el aspecto del puntero según el destino o fuente
#de recursos que esté tocando.
signal is_basket
signal is_arrow
var arrow_mode=false
var basket_mode=false

#/////////////////////////////////////////
#FUNCIONES PRINCIPALES MAIN

#Función _ready()
func _ready():
	
	
	
	#Asignamos los arboles frutales.
	all_trees.append($FruitTrees/fruit_tree)
	all_trees.append($FruitTrees/fruit_tree2)
	all_trees.append($FruitTrees/fruit_tree3)
	all_trees.append($FruitTrees/fruit_tree4)
	all_trees.append($FruitTrees/fruit_tree5)
	all_trees.append($FruitTrees/fruit_tree6)
	
	#Asignamos las plantas
	all_plants.append($Plants/Plant)
	all_plants.append($Plants/Plant2)
		
	all_units = get_tree().get_nodes_in_group("units")
	
	#Creamos la segunda unidad (una mujer), aparte de la original (que es hombre).
	_create_unit();
	
	#Lugar donde va a aparecer la nueva unidad
	all_units[all_units.size()-1].position = Vector2(camera.position.x+rand_range(50,100),camera.position.y+rand_range(50,100))
	
	#Configuración por defecto del cursor del mouse a aspecto de flecha.
	emit_signal("is_arrow")
	arrow_mode=true
	basket_mode=false

#Función _process(_delta)
func _process(_delta):
	
	if(!its_raining):
		timer_label.text = "PELIGRO EN: " + str(int(rain_timer.time_left))
	else:
		timer_label.text = "LA LLUVIA CESARÁ EN: " + str(int(rain_timer.time_left))
	food_label.text = str(int(Globals.food_points))
	leaves_label.text = str(int(Globals.leaves_points))	
	camera._set_its_raining(its_raining)
			
	for a_unit in all_units:
		
		#a_unit.position.x = clamp(a_unit.position.x,-1028,screensize.x)
		#a_unit.position.y = clamp(a_unit.position.y,-608,screensize.y)
	
	
		a_unit._set_its_raining(its_raining)
		
		#a_unit.move_unit(a_unit.target_position)
		

		
#UNHANDLED INPUT
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
		if arrow_mode:
			if(all_units.size()==0 && Globals.food_points<15):
				replay_confirmation.visible=true
			else:
				exit_confirmation.popup()
				exit_confirmation.get_ok().text="Aceptar"
				exit_confirmation.get_cancel().text="cancelar"
	if event.is_action_pressed("PrintScreen"):
		var image = get_viewport().get_texture().get_data()
		image.flip_y()
		image.save_png("res://captures/image.png")
#///////////////////////////////////////////////////////////////////////////
#FUNCIONES DE CREACIÓN Y CONFIGURACIÓN DE UNIDADES

#Crear unidad.
func _create_unit():
	if Globals.food_points >=15:
		var new_Unit = Unit.instance()
		new_Unit.position = Vector2(-800,-500)
		unit_count+=1		
		if(unit_count%2==0):
			new_Unit.is_girl=true
		else:
			new_Unit.is_girl=false
		if(Globals.group_dressed):
			new_Unit.is_dressed=true	
		
		tile_map.add_child(new_Unit)	
		
		if(Globals.group_has_bag):
			new_Unit.has_bag=true	
			new_Unit.bag_sprite.visible = true	
		
		Globals.food_points-=15	
		all_units.append(new_Unit)

#Vestir las unidades.		
func _dress_units():
	for a_unit in all_units:
		if(!a_unit.is_dressed):
			a_unit.is_dressed = true
			
#Agregar bolso de hojas para recolección a las unidades.			
func _add_bag():
	for a_unit in all_units:
		if(!a_unit.has_bag):
			a_unit.has_bag = true	
			a_unit.bag_sprite.visible=true	
			



#FUNCIÓN QUE DESSELECCIONA TODAS LAS UNIDADES.	
#(Utiliza el arreglo 'selected units').	
func _deselect_all():
	while selected_units.size()>0:
		selected_units[0]._set_selected(false)
		
#FUNCIÓN PARA SELECCIONAR Y DESSELECCIONAR UNA UNIDAD CON UN CLICK.
#(Debe ser mejorada, ya que selecciona o desselecciona todas las unidades superpuestas).
func was_pressed(obj):
	for unit in selected_units:
		if unit.name == obj.name:
			unit._set_selected(false)
			break
		

		

			
#IDENTIFICAR LAS UNIDADES EN EL ÁREA DE SELECCIÓN DEL RECTÁNGULO.	
func get_units_in_area(area):
	var u=[]
	for unit in all_units:
		if unit.position.x>area[0].x and unit.position.x<area[1].x:
			if unit.position.y>area[0].y and unit.position.y<area[1].y:
				u.append(unit)
	return u
		
#MARCAR LAS UNIDADES SELECCIONADAS.
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
		

		

#FUNCIONES DE SELECCIONAR Y DESELECCIONAR UNIDADES.
#(Son necesarias para no añadir nuestras nuevas unidades 
#seleccionadas a las que ya estaban seleccionadas,
#sino desseleccionar las seleccionadas y seleccionar las que 
#estamos seleccionadndo).
#func select_unit(unit):
#	if not selected_units.has(unit):
#		selected_units.append(unit)
#	#print("selected %s" % unit.name)
#
#
#func deselect_unit(unit):
#	if selected_units.has(unit):
#		selected_units.erase(unit)
##	#print("deselected %s" % unit.name)


		
func _select_unit(unit):
	if not selected_units.has(unit):
		selected_units.append(unit)
	#print("selected %s" % unit.name)
	#create_buttons()

func _deselect_unit(unit):
	if selected_units.has(unit):
		selected_units.erase(unit)
		
func _select_last():
	for unit in selected_units:
		if selected_units[selected_units.size()-1] == unit:
			unit._set_selected(true)
		else:
			unit._set_selected(false)


##MOVER LA SELECCIÓN DE UNIDADES.
func start_move_selection(obj):
	for un in all_units:
		if un.selected:
			un.move_unit(obj.move_to_point)
			
	
#FUNCIÓN 'RAIN POUR'. LLAMA A LA LLUVIA CUANDO SE CUMPLE EL TIEMPO DEL TEMPORIZADOR
#'RAIN TIMER'. SI NO ESTÁ LLOVIENDO, HACE QUE LLUEVA Y VICEVERSA.
func _rain_pour():
	if(!its_raining):
		its_raining=true
	else:
		its_raining=false
			

#SEÑAL DE TIEMPO TRANSCURRIDO PARA TEMPORIZADOR 'RAIN TIMER',
#EL CUAL ESPERA 100 SEGUNDOS CUANDO NO LLUEVE Y TREINTA CUANDO ESTÄ LLOVIENDO.
func _on_Rain_Timer_timeout():	
	_rain_pour()
	if(its_raining):
		rain_timer.wait_time = 100
	else:
		rain_timer.wait_time = 30

#Señal de que el botón de agregar ropa ha sido presionado.
func _on_AddClothes_pressed():
	if Globals.leaves_points >=70:
		Globals.leaves_points-=70
		_dress_units()
		Globals.group_dressed = true
		add_clothes.visible = false
	

#Señal de que el botón de agregar bolso de hojas ha sido presionado.
func _on_AddBag_pressed():
	if Globals.leaves_points >=50:
		Globals.leaves_points-=50
		_add_bag()
		Globals.group_has_bag = true
		add_bag.visible = false


#SEÑALES PARA CAMBIAR EL ASPECTO DEL CURSOR DEL MOUSE.
#A canasta...
func _on_Game_is_basket():
	Input.set_custom_mouse_cursor(Globals.basket)
	basket_mode=true
	arrow_mode=false

#A flecha...
func _on_Game_is_arrow():
	Input.set_custom_mouse_cursor(Globals.arrow)
	arrow_mode=true
	basket_mode=false
	
#///////////////////////////////////////////////////////////////////
#SEÑAL DE BOTÓN DE 'CREAR CIUDADANO' PRESIONADO.
func _on_CreateCitizen_pressed():
	_create_unit()

#///////////////////////////////////////////////////////////////////
#SEÑAL DE TIEMPO TRANSCURRIDO DE TEMPORIZADOR 'FOOD TIMER', LLAMADO ASÍ POR
#ESTAR PENSADO PARA TEMPORIZAR LA RECOLECCIÖN DE COMIDA PERO USADO LUEGO
#GENERALMENTE PARA LLAMAR A OTRAS FUNCIONES DE LAS QUE SÓLO QUEDA 'CHECK VICTORY'.
func _on_food_timer_timeout():
	if(all_units.size()>-1):
		_check_victory()
		
#////////////////////////////////////////////////////////////////////////////////////
#FUNCIÓN 'CHECK VICTORY' para evaluar condiciones de derrota o victoria.
func _check_victory():
	if(all_units.size()==0 && Globals.food_points<15):
		prompts_label.text = "Has sido derrotado."	
		replay_confirmation.visible=true
	if(cave.sheltered_units>=12):
		prompts_label.text = "Has ganado."
		next_scene_confirmation.visible=true
		
		



func _on_ExitConfirmation_confirmed():
	Globals.go_to_scene("res://Scenes/Menu/Menu.tscn")
	

func _on_ReplayOk_pressed():
	Globals.reload_current_scene()


func _on_ReplayCancel_pressed():
	exit_confirmation.popup()
	exit_confirmation.get_ok().text="Aceptar"
	exit_confirmation.get_cancel().text="Cancelar"


func _on_NextSceneOk_pressed():
	Globals.go_to_scene("res://Scenes/Game2/Game2.tscn")
