extends CanvasLayer



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var miniMapPath = get_node("MiniMap/SubViewportContainer/SubViewport")
	miniMapPath._ready()
