extends Node2D

@onready var anim = $Sprite2D

signal gridSnap

signal placePlant

func _physics_process(_delta):
	emit_signal("gridSnap", self, get_global_mouse_position())
	
func _input(event):
	if event is InputEventMouseButton:
		emit_signal("gridSnap", self, get_global_mouse_position())
		_tryPlacePlant(global_position)
	
func _tryPlacePlant(pos):
	emit_signal("placePlant", pos)

func changeAnim(id : int, reset : bool = false, _button : TextureButton = null):
	print(id)
	if reset:
		anim.animation = "default"
	else:
		anim.animation = str(id)
