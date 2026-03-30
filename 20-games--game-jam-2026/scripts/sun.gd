extends Area2D

signal clicked

var fall : bool = false
var speed : int = 50
var value : int = 25

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		sunClicked()
		
func _physics_process(delta):
	if fall:
		position.y += delta * speed

func sunClicked():
	emit_signal("clicked", value)
	destroy()
	
func destroy():
	self.queue_free()
