extends Camera2D

func _ready():
	SignalBus.connect("adjustZoom", zoom_me)

func zoom_me(factor):
	print("Camera: ", self)
	#position = get_viewport().get_mouse_position()
	
	if (factor < 0 and get_zoom().x <= 0.8) or (factor > 0 and get_zoom().x >= 4.5):
		return
	
	set_zoom(get_zoom() + Vector2(factor,factor))
	
	#print(get_zoom())
