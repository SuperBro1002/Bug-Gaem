extends Camera2D

var animationSpeed = 4
var isZooming = false

func _ready():
	SignalBus.connect("adjustZoom", zoom_me)
	SignalBus.connect("moveCamera", move_me)

func zoom_me(factor):
	print("Camera: ", self)
	
	if (factor < 0 and get_zoom().x <= 0.9) or (factor > 0 and get_zoom().x >= 4.5):
		return
	
	var zoomAmount = get_zoom() + Vector2(factor,factor)
	
	if !isZooming:
		isZooming = true
		var tween = create_tween()
		tween.tween_property(self, "zoom", zoomAmount, 1.0 / animationSpeed).set_trans(Tween.TRANS_SINE)
		await tween.finished
		isZooming = false

func move_me():
	var tween = create_tween()
	tween.tween_property(self, "position", get_parent().get_global_mouse_position(), 1.0 / animationSpeed).set_trans(Tween.TRANS_SINE)
	await tween.finished
