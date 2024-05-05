extends Node2D

#Íconos que indican los diferentes modos del mouse para llevar
#a cabo distintas acciones.
var basket=load("res://Scenes/MouseIcons/basket.png")
var arrow=load("res://Scenes/MouseIcons/arrow.png")
var pick_mattock=load("res://Scenes/MouseIcons/pick_mattock.png")
var sword=load("res://Scenes/MouseIcons/sword.png")
var claypot=load("res://Scenes/MouseIcons/claypot.png")
var hand=load("res://Scenes/MouseIcons/hand.png")
var axe=load("res://Scenes/MouseIcons/axe.png")
var house=load("res://Scenes/MouseIcons/house.png")
var house_b=load("res://Scenes/MouseIcons/house_b.png")
var townhall=load("res://Scenes/MouseIcons/townHall.png")
var townhall_b=load("res://Scenes/MouseIcons/townHall_b.png")
var fort=load("res://Scenes/MouseIcons/fort_s.png")
var fort_b=load("res://Scenes/MouseIcons/fort_sb.png")
var barn=load("res://Scenes/MouseIcons/barn_s.png")
var barn_b=load("res://Scenes/MouseIcons/barn_sb.png")
var tower=load("res://Scenes/MouseIcons/tower_s.png")
var tower_b=load("res://Scenes/MouseIcons/tower_sb.png")

#Contador de unidades civiles.
var unit_count = 1

#Puntos de cada uno de los recursos naturales a recolectar.
var food_points = 200
var leaves_points = 0
var stone_points = 0
var copper_points = 0
var wood_points = 200
var clay_points = 200
var water_points = 0

#Hitos anteriores ya cumplidos
var group_dressed = false
var group_has_bag = false
var is_fire_discovered = true
var is_wheel_invented = true
var is_stone_weapons_developed = true
var is_claypot_made = true
var is_agriculture_developed = true
var is_townhall_created = false

#El jefe ha muerto.
var is_warchief_dead = false

#Variables de hitos
var is_pottery_developed=false
var is_carpentry_developed=false
var is_mining_developed=false
var is_metals_developed=false
var is_first_tower_built=false
var is_barn_built=false
var is_fort_built=false



onready var tree = get_tree().root.get_child(0)
onready var food_timer = tree.get_node("food_timer")
onready var enemy_timer = tree.get_node("enemy_timer")
onready var timer_label = tree.get_node("UI/Base/TimerLabel")
onready var food_label = tree.get_node("UI/Base/Rectangle/FoodLabel")
onready var prompts_label = tree.get_node("UI/Base/Rectangle/PromptsLabel")
onready var leaves_label = tree.get_node("UI/Base/Rectangle/LeavesLabel")
onready var stone_label = tree.get_node("UI/Base/Rectangle/StoneLabel")
onready var copper_label = tree.get_node("UI/Base/Rectangle/CopperLabel")
onready var clay_label = tree.get_node("UI/Base/Rectangle/ClayLabel")
onready var wood_label = tree.get_node("UI/Base/Rectangle/WoodLabel")
onready var water_label = tree.get_node("UI/Base/Rectangle/WaterLabel")
#onready var developments_label = tree.get_node("UI/Base/Rectangle/DevelopmentsLabel")
onready var rectangle = tree.get_node("UI/Base/Rectangle")
onready var develop_pottery = tree.get_node("UI/Base/Rectangle/DevelopPottery")
onready var develop_carpentry = tree.get_node("UI/Base/Rectangle/DevelopCarpentry")
onready var develop_mining = tree.get_node("UI/Base/Rectangle/DevelopMining")
onready var develop_metals = tree.get_node("UI/Base/Rectangle/DevelopMetals")
onready var create_house = tree.get_node("UI/Base/Rectangle/CreateHouse")
#onready var create_townhall = tree.get_node("UI/Base/Rectangle/CreateTownHall")
onready var create_warrior = tree.get_node("UI/Base/Rectangle/CreateWarriorUnit")
onready var next_scene_button = tree.get_node("UI/Base/NextSceneButton")
onready var camera = tree.get_node("Camera")
#onready var tiger_timer = tree.get_node("tiger_timer")
onready var tile_map = tree.get_node("TileMap")
onready var puddle = tree.get_node("Puddle")
onready var quarry1 = tree.get_node("Quarries/Quarry1")
onready var quarry2 = tree.get_node("Quarries/Quarry2")
onready var quarry3 = tree.get_node("Quarries/Quarry3")
onready var quarry4 = tree.get_node("Quarries/Quarry4")
onready var copper1 = tree.get_node("Coppers/Copper")
onready var copper2 = tree.get_node("Coppers/Copper2")
onready var lake = tree.get_node("Lake")
onready var spawn_position = $SpawnPosition
onready var tiger_spawn = $TigerSpawn
#onready var tiger_target = $TigerTarget
onready var units = $Units
onready var warriors = $Warriors
onready var houses = $Houses
onready var fort_node = $Fort
onready var tower_node = $Towers
onready var barn_node = $Barn
onready var nav2d=$nav
onready var townhall_node=$TownHall

var path=[]

#Escena cueva.
var cave

#Escenas a instanciar (ciudadano, guerrero y cazador, casa, centro cívico).
export (PackedScene) var Unit2
export (PackedScene) var Warrior
export (PackedScene) var House
export (PackedScene) var TownHall
export (PackedScene) var Fort
export (PackedScene) var Tower
export (PackedScene) var Barn


#Arreglos para controlar los distintos grupos de entidades.
#Unidades seleccionadas (civiles y militares).
var selected_units=[]
#Todas las unidades.
var all_units=[]
#Todas las plantas.
var all_plants=[]
#Todos los árboles frutales.
var all_trees=[]
#Todos los pinos.
var all_pine_trees=[]
#Todas las canteras.
var all_quarries=[]
#Todas las minas de cobre.
var all_coppers=[]
#Todos los recursos para recolectar.
var all_pickables=[]
#Unidades refugiadas (en la cueva o bajo los árboles frutales).
var sheltered=[]

#Arreglo que va a incluir todos los obstáculos creados dinámicamente que las
#unidades van a tener que esquivar.
var obstacles=[]


#Indica si el cursor está siendo arrastrado para dibujar
#el rectángulo de selección.
var dragging = false
#Unidades seleccionadas dentro del rectángulo.
var selected = []
#Coordenadas de inicio del rectángulo.
var drag_start = Vector2.ZERO
#var select_rectangle = RectangleShape2D.new()

#Nodo con sprite de rectángulo azul que se redimensiona para
#dibujar el rectángulo de selección.
onready var draw_rect = get_tree().root.find_node("draw_rect")

#Indica si están invertidos o no los transform de las unidades.
var is_flipped = false

#Tamaño de la ventana.
var screensize = Vector2(ProjectSettings.get("display/window/size/width"),ProjectSettings.get("display/window/size/height"))

#Variables para evitar crear una construcción encima de otra.
var is_mouse_entered=false
var is_too_close=false

#Señales para determinar los modos del mouse.
signal is_arrow
signal is_basket
signal is_pick_mattock
signal is_sword
signal is_claypot
signal is_hand
signal is_axe


#signal is_house
#signal is_fort

#Variables para indicar los modos del mouse.
var arrow_mode=false
var basket_mode=false
var mattock_mode=false
var sword_mode=false
var claypot_mode=false
var hand_mode=false
var axe_mode=false
var house_mode=false
var tower_mode=false
var barn_mode=false
var fort_mode=false


var previous_mouse_state=""

#Si el cursor está en forma de espada tocando un enemigo, lo guardamos en esta variable.
var touching_enemy

#Variables de fila y columna para formación de unidades (civiles y militares).
var row=0
var column=0

func _ready():
	
	#igualamos el arreglo all_units a los nodos del grupo
	#de unidades civiles con las que empezamos la fase.	
	#En este caso, tenemos una sola unidad civil,
	#luego crearemos las demás.
	all_units=get_tree().get_nodes_in_group("units")
	
	#Nodo del mapa de tejas.
	tile_map=tree.find_node("TileMap")
	
	#Nodo de la cueva.
	cave=tree.get_node("Cave")
	
	#Agregamos cada uno de los árboles frutales existentes 
	#en la escena principal al arreglo all_trees.
	all_trees.append(tree.find_node("fruit_tree"))
	all_trees.append(tree.find_node("fruit_tree2"))
	all_trees.append(tree.find_node("fruit_tree3"))
	all_trees.append(tree.find_node("fruit_tree4"))
	all_trees.append(tree.find_node("fruit_tree5"))
	all_trees.append(tree.find_node("fruit_tree6"))
	
	#Agregamos las dos plantas existentes 
	#en la escena principal al arreglo all_plants.
	all_plants.append(tree.find_node("Plant"));
	all_plants.append(tree.find_node("Plant2"));
	
	
	#Agregamos cada uno de los pinos existentes 
	#en la escena principal al arreglo all_pine_trees.
	all_pine_trees.append(tree.find_node("PineTree1"))
	all_pine_trees.append(tree.find_node("PineTree2"))
	all_pine_trees.append(tree.find_node("PineTree3"))
	all_pine_trees.append(tree.find_node("PineTree4"))
	all_pine_trees.append(tree.find_node("PineTree5"))
	all_pine_trees.append(tree.find_node("PineTree6"))
	all_pine_trees.append(tree.find_node("PineTree7"))
	all_pine_trees.append(tree.find_node("PineTree8"))	
	
	#Agregamos las cuatro canteras existentes 
	#en la escena principal al arreglo all_quarries.
	all_quarries.append(quarry1)
	all_quarries.append(quarry2)
	all_quarries.append(quarry3)
	all_quarries.append(quarry4)
	
	#Agregamos las dos minas de cobre existentes 
	#en la escena principal al arreglo all_coppers.
	all_coppers.append(copper1)
	all_coppers.append(copper2)
	
	#Creamos las 11 unidades restantes aparte de la que agregamos
	#en la línea 176. 
	for i in range(0,11):
		_create_unit();
	
	#Formación de las unidades.
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
	
	#Convertimos en jefe guerrero a la primera unidad
	#(no es el mismo de la fase anterior, ya que transcurrieron muchos años),
	#y le agregamos su marca de identificación color naranja.
	all_units[0].is_warchief=true
	all_units[0].warchief_mark.visible=true
	
	#Actualizamos el polígono de navegación para los edificios
	var dwells=houses.get_children()
	
	for house in dwells:
		all_units[0].selected=true
		_update_path(house)
	
	all_units[0].selected=true	
	_update_path(townhall_node.get_child(0))
	
	all_units[0].selected=false

	#Establecemos el cursor en modo flecha con la señal is_arrow,
	#el modo arrow_mode en true, y todos los demás modos en false.
	emit_signal("is_arrow")
	arrow_mode=true
	basket_mode=false
	mattock_mode=false
	sword_mode=false
	claypot_mode=false
	hand_mode=false
	axe_mode=false
	tower_mode=false
	barn_mode=false
	fort_mode=false
	


func _process(_delta):
	
	#Verificar que el jefe no esté muerto.
	if !is_warchief_dead:
	
		#Etiqueta de tiempo restante para la amenaza enemiga
		#y etiquetas de recursos recolectados.
		timer_label.text = "ATAQUE ENEMIGO: " + str(int(enemy_timer.time_left))
		food_label.text = str(int(food_points))
		leaves_label.text = str(int(leaves_points))	
		stone_label.text = str(int(stone_points))	
		copper_label.text = str(int(copper_points))
		clay_label.text = str(int(clay_points))
		wood_label.text = str(int(wood_points))
		water_label.text = str(int(water_points))
	
		#Comprobar las unidades existentes para ver si alguna está muerta.
		_check_units()
		
		#Comprobar si ha habido victoria.
		_check_victory()
	
		#Comprobar si todos los pinos han sido talados.
		_check_pine_trees()

		#Comprobar si todos los árboles de fruita han sido consumidos.
		_check_fruit_trees()
		
		#Comprobar si todas las canteras han sido agotadas.
		_check_quarries()
		
		#Comprobar si todas las minas de cobre han sido agotadas.
		_check_coppers()
		
		_check_mouse_modes()

#Seleccionar una unidad.
func select_unit(unit):
	if not selected_units.has(unit):
		selected_units.append(unit)
	#print("selected %s" % unit.name)
	#create_buttons()

#Deseleccionar una unidad.
func deselect_unit(unit):
	if selected_units.has(unit):
		selected_units.erase(unit)
		
		
#Para corregir
#	if event.is_action_pressed("RightClick"):
#		firstPoint = player.global_position
#		#line.points = []
#
#	if event.is_action_released("RightClick"):
#		secondPoint = get_global_mouse_position()
#		var arrPath: PoolVector2Array = nav2d.get_simple_path(firstPoint,secondPoint,true)
#		player.global_position = arrPath[0]
#		player.path = arrPath
#		player.index = 0
	
#Proceso de entrada unhandled input.
func _unhandled_input(event):
	#Si el jefe guerrero no está muerto.
	if !is_warchief_dead:
		
		if event is InputEventMouseMotion:
			if house_mode || tower_mode || barn_mode || fort_mode:
				
				for house in houses.get_children():
					if !house in obstacles:
						obstacles.append(house)
						
				for a_townhall in townhall_node.get_children():
					if !a_townhall in obstacles:
						obstacles.append(a_townhall)
						
				for a_tower in tower_node.get_children():
					if !a_tower in obstacles:
						obstacles.append(a_tower)
						
				for a_barn in barn_node.get_children():
					if !a_barn in obstacles:
						obstacles.append(a_barn)
						
				for a_fort in fort_node.get_children():
					if !a_fort in obstacles:
						obstacles.append(a_fort)
				
				for an_obstacle in obstacles:
					if an_obstacle.mouse_entered:
						is_mouse_entered=true
						break
					else:
						is_mouse_entered=false	


					if an_obstacle.position.distance_to(get_global_mouse_position())<130:
						is_too_close=true
						break
					else:
						is_too_close=false




		
		#Botón derecho del mouse, mueve a las unidades.
		if event.is_action_pressed("RightClick"):
			#Si el cursor no está en modo casa, fuerte, torre o granero.
			if !house_mode && !fort_mode && !tower_mode && !barn_mode:
				#Movemos a las unidades y las hacemos formar.
				for i in range(0,selected_units.size()):
					if i==0:
						selected_units[i].target_position=get_global_mouse_position()
					else:
						if i%4==0:
							selected_units[i].target_position=Vector2(selected_units[0].target_position.x,selected_units[i-1].target_position.y+20)
						else:
							selected_units[i].target_position=Vector2(selected_units[i-1].target_position.x+20,selected_units[i-1].target_position.y)
			#Si el cursor está en modo casa.
			if house_mode || fort_mode || tower_mode || barn_mode:
				#Ponemos el cursor en modo flecha para cancelar la construcción de una casa.
				_on_Game4_is_arrow()

		#Botón izquierdo del mouse. En este procedimiento se utiliza para
		#construir casas y otros edificios.
		if event.is_action_pressed("LeftClick"):
			#Si el cursor está en modo casa.
			if house_mode:
				#Construimos una casa.
				_create_house()
				#Enviar a los ciudadanos a construir la casa.
				for citizen in units.get_children():
					citizen.firstPoint=citizen.global_position
					citizen.secondPoint=citizen.target_position
					_on_Game4_is_arrow()
					var arrPath: PoolVector2Array = nav2d.get_simple_path(citizen.firstPoint,citizen.secondPoint,true)
					citizen.firstPoint = arrPath[0]
					citizen.path = arrPath
					citizen.index = 0
			if fort_mode:
				_create_fort()
			if tower_mode:
				_create_tower()
			if barn_mode:
				_create_barn()
		
			if house_mode || fort_mode || tower_mode || barn_mode:
				#Enviar a los ciudadanos a construir el edificio.
				for citizen in units.get_children():
					if citizen.selected:
						citizen.firstPoint=citizen.global_position
						citizen.secondPoint=citizen.target_position
						_on_Game4_is_arrow()
						var arrPath: PoolVector2Array = nav2d.get_simple_path(citizen.firstPoint,citizen.secondPoint,true)
						citizen.firstPoint = arrPath[0]
						citizen.path = arrPath
						citizen.index = 0
				
		
		#Tecla Escape. Se utiliza para poner el cursor en modo flecha,
		#cancelando así la construcción de una casa u otra acción.
		if event.is_action_pressed("EscapeKey"):
			#Si el cursor está en modo casa.
			if house_mode || fort_mode || tower_mode || barn_mode:
				#Ponemos el cursor en modo flecha para cancelar la construcción de una casa.
				_on_Game4_is_arrow()
				



func _create_fort():
	var citizens=units.get_children()
	var the_citizen=null
	var the_fort=null

	for citizen in citizens:
		if citizen.selected:
			the_citizen=citizen

	if the_citizen!=null:
		if wood_points>=300 && stone_points>=200 && leaves_points>=40 && !is_mouse_entered && !is_too_close:					
			var new_fort=Fort.instance()
			#the_citizen.agent.set_target_location(get_global_mouse_position())
			new_fort.position = get_global_mouse_position()
			fort_node.add_child(new_fort)
			#Actualizamos el mapa de navegación.
			_update_path(new_fort)
			the_citizen.target_position=new_fort.position
			#Le marcamos la posición del fuerte al ciudadano seleccionado
			#para que vaya a construirlo.
			#Posicionamos a la unidad según el lugar en que se encuentre el nuevo fuerte
			#para construirlo.
			if the_citizen.position.x < new_fort.position.x:
				#Si el nuevo fuerte está a la derecha.
				the_citizen.target_position=Vector2(new_fort.position.x-60,new_fort.position.y)
			else:
				#Si el nuevo fuerte está a la izquierda
				the_citizen.target_position=Vector2(new_fort.position.x+60,new_fort.position.y)
			the_fort=new_fort
			wood_points-=300
			stone_points-=200
			leaves_points-=40
			
			print("Se construyó un fuerte.")	

	if the_fort!=null:
		for citizen in citizens:
			if citizen.selected && citizen!=the_citizen:
				if citizen.position.x < the_fort.position.x:
					#Si el nuevo fuerte está a la derecha.
					citizen.target_position=Vector2(the_fort.position.x-60,the_fort.position.y)
				else:
					#Si el nuevo fuerte está a la izquierda.
					citizen.target_position=Vector2(the_fort.position.x+60,the_fort.position.y)
				
#Función crear torre de vigilancia
func _create_tower():
	#Obtenemos los ciudadanos hijos del nodo units.
	var citizens=units.get_children()
	#Obtenemos las torres hijas del nodo towers.
	var towers=tower_node.get_children()
	#Contador de torres.
	var tower_count=0
	#Identificador de un ciudadano seleccionado (si lo hay).
	#Será el que inicie la construcción de la torre.
	var the_citizen=null
	#La torre a construir.
	var the_tower=null
	
	#Identificamos al primer ciudadano seleccionado para 
	#construir la torre.
	for citizen in citizens:		
		if citizen.selected:
			the_citizen=citizen
			#Interrumpimos el loop para que no tome a los otros ciudadanos seleccionados.
			break
			
	#Si el ciudadano seleccionado para construir la torre no es nulo.		
	if the_citizen!=null:
		#Si tenemos al menos 100 puntos de piedra, 80 puntos de madera y 20 de hojas.
		if stone_points>=100 && wood_points>=80 && leaves_points>=20 && !is_mouse_entered && !is_too_close:					
			#Instanciamos la nueva torre.
			var new_tower=Tower.instance()
			#Máximo de puntos de la barra de constitución de una torre.
			
			#the_citizen.agent.set_target_location(get_global_mouse_position())
			
			#Ubicamos la nueva torre en la posición global del mouse.
			new_tower.position = get_global_mouse_position()
			#Agregamos la nueva torre al nodo torres.
			tower_node.add_child(new_tower)
			#Actualizamos el mapa de navegación.
			_update_path(new_tower)
			#Le marcamos la posición de la torre al ciudadano seleccionado
			#para que vaya a construirla.
			#Posicionamos a la unidad según el lugar en que se encuentre la nueva torre
			#para construirla.
			if the_citizen.position.x < new_tower.position.x:
				#Si la nueva torre está a la derecha.
				the_citizen.target_position=Vector2(new_tower.position.x-35,new_tower.position.y)
			else:
				#Si la nueva torre está a la izquierda
				the_citizen.target_position=Vector2(new_tower.position.x+35,new_tower.position.y)
			#Identificamos la nueva casa con la variable the_house.
			the_tower=new_tower
			#Restamos 100 puntos de piedra, 80 puntos de madera y veinte de hojas.
			stone_points-=100
			wood_points-=80
			leaves_points-=20
			#Mensaje de comprobación para la consola.
			print("Se construyó una torre.")
	
	#Si la nueva torre no es nula.
	if the_tower!=null:
		#Si hay otros ciudadanos seleccionados, 
		#también los mandamos a construir la torre.
		for citizen in citizens:
			if citizen.selected && citizen!=the_citizen:
				if citizen.position.x < the_tower.position.x:
					#Si la nueva torre está a la derecha.
					citizen.target_position=Vector2(the_tower.position.x-35,the_tower.position.y)
				else:
					#Si la nueva torre está a la izquierda.
					citizen.target_position=Vector2(the_tower.position.x+35,the_tower.position.y)	
				
#Función crear granero.
func _create_barn():
	#Obtenemos los ciudadanos hijos del nodo units.
	var citizens=units.get_children()
	#Obtenemos el granero hijo del node barn_node.
	var barns=barn_node.get_children()
	#Contador de graneros.
	var barns_count=0
	#Identificador de un ciudadano seleccionado (si lo hay).
	#Será el que inicie la construcción del granero.
	var the_citizen=null
	#El granero a construir.
	var the_barn=null
	
	#Identificamos al primer ciudadano seleccionado para 
	#construir el granero.
	for citizen in citizens:		
		if citizen.selected:
			the_citizen=citizen
			#Interrumpimos el loop para que no tome a los otros ciudadanos seleccionados.
			break
			
	#Si el ciudadano seleccionado para construir el granero no es nulo.		
	if the_citizen!=null:
		#Si tenemos al menos 300 puntos de arcilla, 200 puntos de madera y 80 de hojas.
		if clay_points>=300 && wood_points>=200 && leaves_points>=80 && !is_mouse_entered && !is_too_close:					
			#Instanciamos el nuevo granero.
			var new_barn=Barn.instance()
			
			
			#Ubicamos el nuevo granero en la posición global del mouse.
			new_barn.position = get_global_mouse_position()
			#Agregamos el nuevo granero al nodo barn_node.
			barn_node.add_child(new_barn)
			#Actualizamos el mapa de navegación.
			_update_path(new_barn)
			#Le marcamos la posición de la casa al ciudadano seleccionado
			#para que vaya a construirla.
			#Posicionamos a la unidad según el lugar en que se encuentre la el nuevo granero
			#para construirlo.
			if the_citizen.position.x < new_barn.position.x:
				#Si el nuevo granero está a la derecha.
				the_citizen.target_position=Vector2(new_barn.position.x-25,new_barn.position.y)
			else:
				#Si el nuevo granero está a la izquierda
				the_citizen.target_position=Vector2(new_barn.position.x+25,new_barn.position.y)
			#Identificamos el nuevo granero con la variable the_barn.
			the_barn=new_barn
			#Restamos 300 puntos de arcilla, 200 puntos de madera y 80 de hojas.
			clay_points-=300
			wood_points-=200
			leaves_points-=80
			#Mensaje de comprobación para la consola.
			print("Se construyó un granero.")
	
	#Si el nuevo granero no es nulo.
	if the_barn!=null:
		#Si hay otros ciudadanos seleccionados, 
		#también los mandamos a construir el granero.
		for citizen in citizens:
			if citizen.selected && citizen!=the_citizen:
				if citizen.position.x < the_barn.position.x:
					#Si el nuevo granero está a la derecha.
					citizen.target_position=Vector2(the_barn.position.x-25,the_barn.position.y)
				else:
					#Si el nuevo granero está a la izquierda.
					citizen.target_position=Vector2(the_barn.position.x+25,the_barn.position.y)	
					

#Función crear casa.				
func _create_house():
	#Obtenemos los ciudadanos hijos del nodo units.
	var citizens=units.get_children()
	#Obtenemos las casas hijas del nodo houses.
	var dwells=houses.get_children()
	#Contador de casas.
	var dwell_count=0
	#Identificador de un ciudadano seleccionado (si lo hay).
	#Será el que inicie la construcción de la casa.
	var the_citizen=null
	#La casa a construir.
	var the_house=null	
		
	#Comprobamos que no haya menos de cuatro ciudadanos por casa.
	for citizen in citizens:
		if (citizens.size()/4)>dwells.size():	
			#Identificamos al primer ciudadano seleccionado para 
			#construir la casa.		
			if citizen.selected:
				the_citizen=citizen
				#Interrumpimos el loop para que no tome a los otros ciudadanos seleccionados.
				break

	#Si el ciudadano seleccionado para construir la casa no es nulo.		
	if the_citizen!=null:
		#Si tenemos al menos 20 puntos de madera y 40 de arcilla.
		if wood_points>=20 && clay_points>=40 && !is_mouse_entered && !is_too_close:					
			#Instanciamos la nueva casa.
			var new_house=House.instance()
			#Máximo de puntos de la barra de constitución de una casa.
			new_house.condition_max=20
			#Ubicamos la nueva casa en la posición global del mouse.
			new_house.position = get_global_mouse_position()
			#Agregamos la nueva casa al nodo casas.
			houses.add_child(new_house)
			#Actualizamos el mapa de navegación con la nueva casa.
			_update_path(new_house)
			#Le marcamos la posición de la casa al ciudadano seleccionado
			#para que vaya a construirla.
			#Posicionamos a la unidad según el lugar en que se encuentre la nueva casa
			#para construirla.
			if the_citizen.position.x < new_house.position.x:
				#Si la nueva casa está a la derecha.
				the_citizen.target_position=Vector2(new_house.position.x-30,new_house.position.y)
			else:
				#Si la nueva casa está a la izquierda
				the_citizen.target_position=Vector2(new_house.position.x+30,new_house.position.y)
				
			#Identificamos la nueva casa con la variable the_house.
			the_house=new_house
			#Restamos 20 puntos de madera y cuarenta de arcilla.
			wood_points-=20
			clay_points-=40
			#Mensaje de comprobación para la consola.			
			print("Se construyó una casa.")

	#Si la nueva casa no es nula.
	if the_house!=null:
		#Si hay otros ciudadanos seleccionados, 
		#también los mandamos a construir la casa.
		for citizen in citizens:
			if citizen.selected && citizen!=the_citizen:
				#Les marcamos la posición de la casa a los ciudadanos seleccionados
				#para que vayan a construirla.
				#Posicionamos a las unidades según el lugar en que se encuentre la nueva casa
				#para construirla.
				if citizen.position.x < the_house.position.x:
					#Si la nueva casa está a la derecha.
					citizen.target_position=Vector2(the_house.position.x-30,the_house.position.y)
				else:
					#Si la nueva casa está a la izquierda.
					citizen.target_position=Vector2(the_house.position.x+30,the_house.position.y)		
				

	
#Función crear unidad ciudadano.	
func _create_unit(cost = 0):
	#Instanciamos la nueva unidad.
	var new_Unit = Unit2.instance()
	#Sumamos 1 al contador de unidades.
	unit_count+=1
	#Si el número es par, la unidad será mujer,
	#si es impar, será hombre.
	if(unit_count%2==0):
		new_Unit.is_girl=true
	else:
		new_Unit.is_girl=false
	#Si el grupo está vestido, la unidad estará vestida.
	if(group_dressed):
		new_Unit.is_dressed=true	
	#Si el grupo lleva la bolsa de recolección, la unidad también la tendrá.
	if(group_has_bag):
		new_Unit.has_bag=true	
		new_Unit.get_child(3).visible = true
	#Restamos el costo de la unidad a los puntos de comida.
	food_points -= cost
	#Creamos la unidad en la posición spawn_position.
	new_Unit.position = spawn_position.position
	#Pero si ya hay otra unidad en esa posición,
	#le sumamos a la posición de la unidad un Vector2 de 20x20.
	for unit in units.get_children():
		if new_Unit.position==unit.position:
			new_Unit.position+=Vector2(20,20)	
	#Agregamos la unidad al nodo units.	
	units.add_child(new_Unit)
	#Agregamos la unidad al arreglo all_units.
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
	if tower_node.get_child_count()>0:
		var first_tower = tower_node.get_child(0)
		if first_tower.condition==first_tower.condition_max:
			is_first_tower_built=true
			
	
	if barn_node.get_child_count()>0:
		var the_barn = barn_node.get_child(0)
		if the_barn.condition==the_barn.condition_max:
			is_barn_built=true
			
	if fort_node.get_child_count()>0:
		var the_fort = fort_node.get_child(0)
		if the_fort.condition==the_fort.condition_max:
			is_fort_built=true
	
	
	if (is_pottery_developed && is_carpentry_developed && is_mining_developed && 
	 is_metals_developed && is_first_tower_built && is_barn_built && is_fort_built):
		prompts_label.text = "¡Has ganado!"	
		next_scene_button.visible = true
	elif(all_units.size()==0 && food_points<15):
		prompts_label.text = "Has sido derrotado."
	else:
		for a_unit in all_units:
			if "Unit" in a_unit.name && a_unit.is_warchief && a_unit.is_deleted:
				is_warchief_dead=true
				prompts_label.text = "Has sido derrotado. Tu jefe ha muerto."	
		

		
#Botón de creación de unidad. 
#Llama al método create unit con un costo de 15 puntos.	
func _on_CreateCitizen_pressed():
	if food_points>=15:
		_create_unit(15)

	
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
		

		
#func start_move_selection(obj):
#	for un in all_units:
#		if un.selected:
#			un.move_unit(obj.move_to_point)
		

func _on_Game4_is_arrow():
	Input.set_custom_mouse_cursor(arrow)
	arrow_mode=true
	basket_mode=false
	mattock_mode=false
	sword_mode=false
	claypot_mode=false
	hand_mode=false
	axe_mode=false
	house_mode=false
	fort_mode=false
	tower_mode=false
	barn_mode=false
	


func _on_Game4_is_basket():
	if !house_mode && !fort_mode:
		Input.set_custom_mouse_cursor(basket)
		basket_mode=true
		arrow_mode=false
		mattock_mode=false
		sword_mode=false
		claypot_mode=false
		hand_mode=false
		axe_mode=false
		house_mode=false
		fort_mode=false
		tower_mode=false
		barn_mode=false
	
func _on_Game4_is_pick_mattock():
	if !house_mode && !fort_mode:
		Input.set_custom_mouse_cursor(pick_mattock)
		mattock_mode=true
		basket_mode=false
		arrow_mode=false
		sword_mode=false
		claypot_mode=false
		hand_mode=false
		axe_mode=false
		house_mode=false
		fort_mode=false
		tower_mode=false
		barn_mode=false

func _on_Game4_is_sword():
	if !house_mode && !fort_mode:
		Input.set_custom_mouse_cursor(sword)
		sword_mode=true
		mattock_mode=false
		basket_mode=false
		arrow_mode=false
		claypot_mode=false
		hand_mode=false
		axe_mode=false
		house_mode=false
		fort_mode=false
		tower_mode=false
		barn_mode=false

func _on_Game4_is_hand():
	if !house_mode && !fort_mode:
		Input.set_custom_mouse_cursor(hand)
		hand_mode=true
		mattock_mode=false
		basket_mode=false
		arrow_mode=false
		sword_mode=false
		claypot_mode=false
		axe_mode=false
		house_mode=false
		fort_mode=false
		tower_mode=false
		barn_mode=false


func _on_Game4_is_claypot():
	if !house_mode && !fort_mode:
		Input.set_custom_mouse_cursor(claypot)
		claypot_mode=true
		arrow_mode=false
		basket_mode=false
		mattock_mode=false
		sword_mode=false
		hand_mode=false
		axe_mode=false
		house_mode=false
		fort_mode=false
		tower_mode=false
		barn_mode=false

func _on_Game4_is_axe():
	if !house_mode && !fort_mode:
		Input.set_custom_mouse_cursor(axe)
		axe_mode=true
		arrow_mode=false
		basket_mode=false
		mattock_mode=false
		sword_mode=false
		claypot_mode=false
		hand_mode=false
		house_mode=false
		fort_mode=false
		tower_mode=false
		barn_mode=false
	
func _on_Game4_is_house():
	if is_mouse_entered || is_too_close:
		Input.set_custom_mouse_cursor(house_b)
	else:
		Input.set_custom_mouse_cursor(house)
	house_mode=true
	arrow_mode=false
	basket_mode=false
	mattock_mode=false
	sword_mode=false
	claypot_mode=false
	hand_mode=false
	axe_mode=false
	fort_mode=false
	tower_mode=false
	barn_mode=false
				
func _on_Game4_is_fort():
	if is_mouse_entered || is_too_close:
		Input.set_custom_mouse_cursor(fort_b)
	else:
		Input.set_custom_mouse_cursor(fort)
	fort_mode=true	
	arrow_mode=false
	basket_mode=false
	mattock_mode=false
	sword_mode=false
	claypot_mode=false
	hand_mode=false
	axe_mode=false
	house_mode=false
	tower_mode=false
	barn_mode=false

func _on_Game4_is_tower():
	if is_mouse_entered || is_too_close:
		Input.set_custom_mouse_cursor(tower_b)
	else:
		Input.set_custom_mouse_cursor(tower)
	tower_mode=true	
	arrow_mode=false
	basket_mode=false
	mattock_mode=false
	sword_mode=false
	claypot_mode=false
	hand_mode=false
	axe_mode=false
	house_mode=false
	fort_mode=false	
	barn_mode=false
	
func _on_Game4_is_barn():
	if is_mouse_entered || is_too_close:
		Input.set_custom_mouse_cursor(barn_b)
	else:
		Input.set_custom_mouse_cursor(barn)
	barn_mode=true
	arrow_mode=false
	basket_mode=false
	mattock_mode=false
	sword_mode=false
	claypot_mode=false
	hand_mode=false
	axe_mode=false
	house_mode=false
	fort_mode=false	
	tower_mode=false

	
				
#Función comprobar unidades.
func _check_units():
	#Para cada unidad en el arreglo all_units...
	for a_unit in all_units:
		#Si la unidad ha sido marcada para borrar y todavía es una instancia válida,
		#es decir, no ha sido eliminada con queue_free().
		if a_unit.is_deleted && is_instance_valid(a_unit):
			#Si el nombre incluye la palabra "Unit", es un ciudadano. 
			if "Unit" in a_unit.name:
				#Si la unidad no es el jefe guerrero.
				if !a_unit.is_warchief:
					#Buscamos la unidad en all_units y la removemos del arreglo.
					var the_unit=all_units[all_units.find(a_unit,0)]
					all_units.remove(all_units.find(a_unit,0))
#					for a_tiger in all_tigers:
#						if is_instance_valid(a_tiger):
#							if a_tiger.unit == the_unit:
#								a_tiger.unit = null
					#Llamamos a la función die de la unidad,
					#para que sea eliminada definitivamente.
					the_unit._die()
			#Si el nombre incluye la palabra "Warrior", es un guerrero.
			if "Warrior" in a_unit.name:
				#Buscamos la unidad en all_units y la removemos del arreglo.
				var the_unit=all_units[all_units.find(a_unit,0)]
				all_units.remove(all_units.find(a_unit,0))
				#Llamamos a la función die de la unidad,
				#para que sea eliminada definitivamente.
				the_unit._die()
	





func _on_MakeWarchief_pressed():
	#La unidad seleccionada se convierte en jefe si es que se selecciona sólo una.
	if selected_units.size()==1:
		selected_units[0].is_warchief=true
		selected_units[0].warchief_mark.visible=true
		create_warrior.visible=true
		
		prompts_label.text = "¡Ya tienes a tu jefe! Utilízalo para entrenar unidades militares\ncon el botón de crear unidad militar."
	#Mensaje que se muestra si se selecciona más de una.
	elif selected_units.size()>1:
		prompts_label.text = "Debes seleccionar una sola unidad."
	#Mensaje que se muestra si no se selecciona ninguna.
	elif selected_units.size()==0:
		prompts_label.text = "Selecciona una unidad."
		

func _check_pine_trees():
	var not_all_trees_empty=false
	
	for a_pine_tree in all_pine_trees:
		if !a_pine_tree.empty:
			not_all_trees_empty=true
			break
			
	if not_all_trees_empty==false:
		for a_pine_tree in all_pine_trees:
			a_pine_tree.points+=30
			a_pine_tree.empty=false
			
func _check_fruit_trees():
	var not_all_fruit_trees_empty=false
	
	for a_fruit_tree in all_trees:
		if !a_fruit_tree.empty:
			not_all_fruit_trees_empty=true
			break
	
	if not_all_fruit_trees_empty==false:
		for a_fruit_tree in all_trees:
			a_fruit_tree.points+=30
			a_fruit_tree.empty=false	
			
func _check_quarries():
	var not_all_quarries_empty=false
	
	for a_quarry in all_quarries:
		if !a_quarry.empty:
			not_all_quarries_empty=true
			break
	
	if not_all_quarries_empty==false:
		var quarry_number=randi()%4+1
		
		match quarry_number:
			1:
				quarry1.points+=150
				quarry1.empty=false
			2:
				quarry2.points+=150
				quarry2.empty=false
			3:
				quarry3.points+=150
				quarry3.empty=false
			4:
				quarry4.points+=150
				quarry4.empty=false
				
func _check_coppers():
	var not_all_coppers_empty=false
	
	for a_copper in all_coppers:
		if !a_copper.empty:
			not_all_coppers_empty=true
			break
	
	if not_all_coppers_empty==false:
		var copper_number=randi()%2+1
		
		if copper_number==1:
			copper1.points+=150
			copper1.empty=false
		else:
			copper2.points+=150
			copper2.empty=false

func _check_plants():
	var not_all_plants_empty=false
	
	for a_plant in all_plants:
		if !a_plant.empty:
			not_all_plants_empty=true
			
	if not_all_plants_empty==false:
		for a_plant in all_plants:
			a_plant.points+=60
			a_plant.empty=false	
			

		

#Botón para crear unidades militares guerrero y cazador.
func _on_CreateWarriorUnit_pressed():
	#Creamos un nuevo contador de guerreros.
	#var warriors_count=0
	#Si tenemos al menos 30 puntos de comida,
	#20 de madera y 10 de piedra.
	if food_points>=30 && wood_points>=20 && stone_points>=10:
		#Instanciamos el nuevo guerrero.
		var new_warrior = Warrior.instance()
		#Situamos el guerrero en la posición spawn_position.
		new_warrior.position = spawn_position.position
		#Ordenamos los guerreros en filas de 10 unidades (10 columnas),
		#en espacios de 20x20.
		for warrior in warriors.get_children():
			#warriors_count+=1				
			if new_warrior.position == warrior.position:
				column+=1
			#if new_warrior.position.x>cave.position.x:
			if column==10:
				column=0
				row+=1
			new_warrior.position=spawn_position.position+Vector2(20*column,20*row)
		
		#Agregamos el guerrero al nodo warriors.
		warriors.add_child(new_warrior)
		#Agregamos el guerrero al arreglo all_units.
		all_units.append(new_warrior)
		#Restamos los puntos del costo del guerrero.
		food_points-=30
		wood_points-=20
		stone_points-=10
	
	


#Botón para crear casa. Alterna el cursor
#entre modo flecha y modo casa.
func _on_CreateHouse_pressed():
	if !house_mode:
		_on_Game4_is_house()
	else:
		_on_Game4_is_arrow()


func _on_GiveAttackOrder_pressed():
	pass # Replace with function body.


func _update_path(new_obstacle):	
	var citizens=units.get_children()
	var the_citizen=null
	var new_polygon=PoolVector2Array()
	var col_polygon=new_obstacle.get_node("CollisionPolygon2D").get_polygon()
	
	for vector in col_polygon:
		new_polygon.append(vector + new_obstacle.position)		
	
	var navi_polygon=nav2d.get_node("polygon").get_navigation_polygon()
	navi_polygon.add_outline(new_polygon)
	navi_polygon.make_polygons_from_outlines()	
	
	for citizen in citizens:
		if citizen.selected:
			the_citizen=citizen
			break
	
	if the_citizen!=null:	
		var p = nav2d.get_simple_path(the_citizen.firstPoint,the_citizen.secondPoint,true)
		path = Array(p)
		path.invert()

#Botón para pasar a la siguiente escena.
#Se habilita cuando se consigue la victoria.
func _on_NextSceneButton_pressed():
	get_tree().change_scene("res://Scenes/Menu/Menu.tscn")



func _on_BuildFort_pressed():
	if !fort_mode:
		_on_Game4_is_fort()
	else:
		_on_Game4_is_arrow()


func _on_BuildSurveillanceTower_pressed():
	if !tower_mode:
		_on_Game4_is_tower()
	else:
		_on_Game4_is_arrow()


func _on_BuildBarn_pressed():
	if !barn_mode:
		_on_Game4_is_barn()
	else:
		_on_Game4_is_arrow()
		

func _check_mouse_modes():
	if house_mode:
		_on_Game4_is_house()
	if tower_mode:
		_on_Game4_is_tower()
	if barn_mode:
		_on_Game4_is_barn()
	if fort_mode:
		_on_Game4_is_fort()
	
		


func _on_DevelopPottery_pressed():
	if clay_points>=400 && wood_points>=150:
		clay_points-=400
		wood_points-=150
		is_pottery_developed=true
		develop_pottery.visible=false


func _on_DevelopCarpentry_pressed():
	if wood_points>=500:
		wood_points-=500
		is_carpentry_developed=true
		develop_carpentry.visible=false


func _on_DevelopMining_pressed():
	if stone_points>=300 && copper_points>=200:
		stone_points-=300
		copper_points-=200
		is_mining_developed=true
		develop_mining.visible=false


func _on_DevelopMetals_pressed():
	if stone_points>=250 && copper_points>=150:
		stone_points-=250
		copper_points-=150
		is_metals_developed=true
		develop_metals.visible=false
		
