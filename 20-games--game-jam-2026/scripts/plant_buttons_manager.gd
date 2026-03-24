extends VBoxContainer

var currentPlant : PackedScene
var sunCost : int
var plantId : int

signal plantSelected()

func _ready():
	connectChildSignals()
	
func connectChildSignals():
	for i in get_children():
		i.plantSelected.connect(_set_plant)
		
func enableButtons():
	for i in get_children():
		i.disabled = false
	
func _set_plant(plant, cost, id):
	currentPlant = plant
	sunCost = cost
	plantId = id
	
	# Emit plant selected signal
	emit_signal("plantSelected", plantId)
	
func check_Sun():
	return sunCost
	
func get_Plant():
	return currentPlant
	
func plantPlaced():
	currentPlant = null
	sunCost = 0
	enableButtons()
