extends Node2D

### Have a node/signal for accessing MapHelper ###
@onready var mapHelper : Node2D = $MapHelper
@onready var tileSelector : Node2D = $TileSelector
@onready var plantButtons : VBoxContainer = $UI/PlantButtons

# Packed scenes
@export var sunScene : PackedScene

# Dictionary of occupied tiles #
var placed_plants : Dictionary = {}

# Variables
@export var sunValue = 50
var sunTimerMax : float = 10.0
var sunTimer : float = 0.0

func _ready():
	# Connect signals #
	tileSelector.gridSnap.connect(gridSnap)
	tileSelector.placePlant.connect(place_plant)
	
	plantButtons.plantSelected.connect(tileSelector.changeAnim)

func _input(_event):
	# Deselect plant on a right click
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		deselectPlant(true)
		
func _physics_process(delta):
	sunTimer += delta
	if sunTimer >= sunTimerMax:
		sunTimer = 0
		_spawnSun()

### TILE/GRID LOGIC ###
func gridSnap(body, pos):
	mapHelper.snap_to_grid(body, pos)
	
func tileValid(pos):
	return not mapHelper.is_tile_occupied(pos)
	
func tileOccupied(grid_coords : Vector2i) -> bool:
	return placed_plants.has(grid_coords)
	
### PLANT PLACING LOGIC ###
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
			if plantButtons.sunCost <= sunValue:
				# Deduct sun cost
				sunValue -= plantButtons.sunCost
				
				updateUI()
				
				# Place the plant!
				var plantInst = plantButtons.currentPlant.instantiate()
				add_child(plantInst)
				plantInst.global_position = pos
				
				# And add it to some kind of array (for checking if something is placed)
				var grid_pos = mapHelper.grid.local_to_map(pos)
				placed_plants[grid_pos] = plantInst
				
				# Connect its destruction signal
				plantInst.plantDestroyed.connect(_on_plant_Destroyed.bind(grid_pos))
				
				# De-select the plants
				deselectPlant()
			else:
				print("Not enough mana!")
				
func deselectPlant(cancel : bool = false):
	# De-select the plants
	plantButtons.plantPlaced(cancel)
	tileSelector.changeAnim(0, true)
				
func _on_plant_Destroyed(grid_pos):
	placed_plants.erase(grid_pos)

### SUN LOGIC ###
func _spawnSun():
	# Place the plant!
	var sunInst = sunScene.instantiate()
	add_child(sunInst)
	
	var random_x = randf() * get_viewport_rect().size.x
	sunInst.global_position = Vector2(random_x, 10)
	sunInst.fall = true
	sunInst.clicked.connect(sunIncrease)
	
func sunIncrease(value):
	print("click")
	sunValue = sunValue + value
	updateUI()
	
func updateUI():
	$SunAmount.text = "[center]Mana: " + str(sunValue)
