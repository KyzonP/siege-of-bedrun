extends TextureButton

@export var plant : PackedScene
@export var cost : int
@export var id : int

signal plantSelected

func _ready():
	# Connect signals
	pressed.connect(on_pressed)
	
func on_pressed():
	emit_signal("plantSelected", plant, cost, id)
	disabled = true
