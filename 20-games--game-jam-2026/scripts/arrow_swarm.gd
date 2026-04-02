extends Node2D

@export var arrow_scene : PackedScene
@export var shadow_scene : PackedScene
@export var swarm_size : int = 5
@export var arc_height : float = -60.0 # Peak of the arc

var unit_positions : Array = []
var arrows : Array = []
var shadows : Array = []

var elapsed_time : float = 0.0
var current_travel_time : float = 1.0

func _ready():
	# Spawn arrows together
	for i in swarm_size:
		var arrow = arrow_scene.instantiate()
		add_child(arrow)
		var rx = randi_range(-10,10)
		var ry = randi_range(-15,15)
		unit_positions.append(Vector2(rx,ry))
		arrow.position = Vector2(rx,ry)
		arrows.append(arrow)
		
		var shadow = shadow_scene.instantiate()
		add_child(shadow)
		shadow.position = Vector2(rx,ry+6)
		shadows.append(shadow)
		
func _physics_process(delta):
	elapsed_time += delta
	
	# Calculate progress
	var _total_estimated = elapsed_time + current_travel_time
	var progress = clamp(elapsed_time / current_travel_time, 0.0, 1.0)
	
	# Math for fake height
	var arc_y = 4 * arc_height * progress * (1.0-progress)
	
	for i in range(arrows.size()):
		var arrow = arrows[i]
		var shadow = shadows[i]
		var base_pos = unit_positions[i]
		
		arrow.position.y = base_pos.y + arc_y
			
			# Rotate to face trajectory
		arrow.rotation = lerp(-0.8,0.8, progress)
		
		# Shadow
		shadow.position.y = base_pos.y
		shadow.rotation = arrow.rotation
		
		var s = lerp(1.0, 0.7, abs(arc_y) / abs(arc_height))
		shadow.scale = Vector2(s, s)
			
	if progress >= 1.0:
		finish_and_cleanup()
		
func finish_and_cleanup():
	# Stop moving
	set_physics_process(false)
	endSwarm()
	
	get_parent().queue_free()
			
func endSwarm():
	var children = get_children()
	y_sort_enabled = true
	
	for victim in children:
		# Unparent and leave behind
		var g_pos = victim.global_position
		remove_child(victim)
		get_tree().current_scene.add_child(victim)
		victim.global_position = g_pos
		
		# Animation
		if victim is AnimatedSprite2D:
			victim.z_index = -1
			
		# Clean up after a delay
		var t = victim.create_tween()
		t.tween_property(victim, "modulate:a", 0, 1.0).set_delay(2.0)
		t.finished.connect(victim.queue_free)
