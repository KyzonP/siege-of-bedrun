extends VBoxContainer

var currentPlant : PackedScene
var sunCost : int
var plantId : int

var plantButton : TextureButton = null

signal plantSelected()

func _ready():
	connectChildSignals()
	
func connectChildSignals():
	for i in get_children():
		i.plantSelected.connect(_set_plant)
		
func enableButtons():
	for i in get_children():
		i.disabled = false
	
func _set_plant(plant, cost, id, button):
	currentPlant = plant
	sunCost = cost
	plantId = id
	
	plantButton = button
	
	# Emit plant selected signal
	emit_signal("plantSelected", plantId, button)
	
func check_Sun():
	return sunCost
	
func get_Plant():
	return currentPlant
	
func plantPlaced():
	currentPlant = null
	sunCost = 0
	
	# Start plant button recharge
	if not plantButton == null:
		plantButton.recharge()
		plantButton = null
					
				
