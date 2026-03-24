extends Node2D

### Have a node/signal for accessing MapHelper ###
@onready var mapHelper : Node2D = $MapHelper
@onready var tileSelector : Node2D = $TileSelector
@onready var plantButtons : VBoxContainer = $UI/PlantButtons

# Dictionary of occupied tiles #
var placed_plants : Dictionary = {}

var sun = 1000

func _ready():
	# Connect signals #
	tileSelector.gridSnap.connect(gridSnap)
	tileSelector.placePlant.connect(place_plant)
	
	plantButtons.plantSelected.connect(tileSelector.changeAnim)

func gridSnap(body, pos):
	mapHelper.snap_to_grid(body, pos)
	
func tileValid(pos):
	return not mapHelper.is_tile_occupied(pos)
	
func tileOccupied(grid_coords : Vector2i) -> bool:
	return placed_plants.has(grid_coords)
	
func place_plant(pos):
	# First check if a plant is selected
	if not plantButtons.currentPlant == null:
		# Check if it's on the actual grid
		if not tileValid(pos):
			# Check if something is placed on the tile #
			if tileOccupied(mapHelper.grid.local_to_map(pos)):
				print("Space taken")
				return
			
			# Check if the current plant's cost is less than the current sun value
			if plantButtons.sunCost < sun:
				# Deduct sun cost
				sun -= plantButtons.sunCost
				
				# Place the plant!
				var plantInst = plantButtons.currentPlant.instantiate()
				add_child(plantInst)
				plantInst.global_position = pos
				
				# And add it to some kind of array (for checking if something is placed)
				placed_plants[mapHelper.grid.local_to_map(pos)] = plantInst
				
				# De-select the plants
				plantButtons.plantPlaced()
				tileSelector.changeAnim(0, true)
				
