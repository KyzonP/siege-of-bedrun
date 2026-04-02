extends Node2D

@export var level_config : LevelData
@export var level : int = 0
var current_wave_index : int = 0

func _ready():
	if level_config:
		start_level()

func start_level():
	#Wait 20 seconds to start level
	await get_tree().create_timer(2.0).timeout
	
	print("Starting: ", level_config.level_name)
	spawn_wave()
	
func spawn_wave():
	if current_wave_index >= level_config.waves.size():
		print("Level Complete!")
		return
		
		
	var wave = level_config.waves[current_wave_index]
	for sequence in wave.sequences:
		for i in range(sequence.amount):
			spawn_zombie(sequence.zombie_type)
			await get_tree().create_timer(sequence.delay).timeout
			
	# Wait for next wave
	await get_tree().create_timer(wave.time_between_waves).timeout
	
	current_wave_index += 1
	spawn_wave()
	
func spawn_zombie(type: PackedScene):
	var zombie = type.instantiate()
	# Randomly pick a lane (within the level range)
	var min_lane = 0
	var max_lane = 4
	
	if level == 1:
		min_lane = 2
		max_lane = 2
	elif level < 4:
			min_lane = 1
			max_lane = 3
	
	
	var lane = randi_range(min_lane,max_lane)
	zombie.global_position = Vector2(867, 160 + (lane * 64))
	#zombie.global_position = Vector2(767, 160 + (lane * 64))
	get_parent().add_child(zombie)
