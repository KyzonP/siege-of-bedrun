extends TextureButton

@export var plant : PackedScene
@export var rechargeTimeMax : float = 7.5
@export var plantName : String
@export var cost : int
@export var id : int

var rechargeTime = 0

signal plantSelected

func _ready():
	# Connect signals
	pressed.connect(on_pressed)
	
	$Name.text = "[center]" + plantName
	$Cost.text = "[center]" + str(cost)
	
func on_pressed():
	emit_signal("plantSelected", plant, cost, id, self)
	disabled = true

func recharge(cancel : bool = false):
	if !cancel:
		await get_tree().create_timer(rechargeTimeMax).timeout
	
	disabled = false
