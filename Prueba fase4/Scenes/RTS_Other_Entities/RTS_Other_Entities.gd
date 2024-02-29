extends Node2D


var faction_type=1 #1=player,2=enemy
var enity_name
var max_health
var health
var price
var is_selectable=true
var hit_by_bullet=false
var root = get_tree().root.get_child(0)


# Called when the node enters the scene tree for the first time.
func _ready():
	_set_color()

func _set_color():
	if faction_type==1:
		$Blue_Color.visible=true
		$Red_Color.visible=false
	else:
		$Red_Color.visible=true
		$Blue_Color.visible=false
	
func _check_bullets(bullet):
	if bullet.faction_type!=self.faction_type:
		hit_by_bullet=true
		health-=bullet.damage
		_check_health()
		bullet.queue_free()
		
func _check_health():
	if health > max_health:
		health = max_health
	
	if health <= 0:
		self.queue_free()
		
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
