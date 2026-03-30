extends Node2D

@export var anim_scene : PackedScene
@export var swarm_size : int = 50
@export var bob_strength = 2.0
@export var bob_speed = 1.0
@export var stateSwitchTime : float = 1.5
@export var halfDefend : bool = false

var unit_positions : Array = []
var current_center_x = 0.0

signal endPileIn

func _ready():
	if "resume_moving" in get_parent():
		endPileIn.connect(get_parent().resume_moving)
	
	for i in swarm_size:
		var anim = anim_scene.instantiate()
		add_child(anim)
		
		var rx = (randf() + randf() - 1.0) * 25
		var ry = (randf() + randf() - 1.0) * 25
		
		unit_positions.append(Vector2(rx,ry))
		
		anim.position = Vector2(rx, ry)
		
func _process(_delta):
	var time = Time.get_ticks_msec() / 1000.0
	var children = get_children()
	
	var i = 0
	for child in children:
		if child is AnimatedSprite2D:
			var speed_mod = bob_speed + (i * 0.1)
			var strength_mod = bob_strength + (i % 3)
			
			var bob = Vector2(sin(time * speed_mod + i), cos(time * (speed_mod * 0.8) + i)) * strength_mod
			
			# Lerp towards current_center_x so movement is smooth
			var target_x = current_center_x + unit_positions[i].x
			child.position.x = lerp(child.position.x, target_x, 0.1)
			child.position.y = lerp(child.position.y, unit_positions[i].y + bob.y, 0.1)
			i += 1

func pile_in(pos):
	# Tween target_center_x over to the edge
	var tween = create_tween()
	tween.tween_property(self, "current_center_x", pos, stateSwitchTime).set_trans(Tween.TRANS_SINE)
	
	for child in get_children():
		if child is AnimatedSprite2D:
			### animation here ###
			child.play("attack")
			pass
			
func end_pile_in():
	var tween = create_tween()
	tween.tween_property(self,"current_center_x", 0.0, stateSwitchTime).set_trans(Tween.TRANS_SINE)
	
	for child in get_children():
		if child is AnimatedSprite2D:
			### animation here ###
			child.play("walk")
			pass
			
	endPileIn.emit()
			
func sync_swarm_to_health(current_hp : float, max_hp : float):
	# Calculate percentage of remaining health, and how many units that correspoinds to
	var health_percent = clamp(current_hp / max_hp, 0.0, 1.0)
	var target_unit_count = int(swarm_size * health_percent)
	
	var units_to_kill = get_child_count() - target_unit_count
	
	# Kill an amount of units to get the amount correct
	for i in range(units_to_kill):
		_kill_one_random_unit()
		
func _kill_one_random_unit():
	var children = get_children()
	if children.size() == 0:
		return
		
	# Pick a random victim
	var victim_index = randi() % children.size()
	var victim = children[victim_index]
	
	# Sync positions array
	unit_positions.remove_at(victim_index)
	
	# Unparent and leave behind
	var g_pos = victim.global_position
	remove_child(victim)
	get_tree().current_scene.add_child(victim)
	victim.global_position = g_pos
	
	# Animation
	if victim is AnimatedSprite2D:
		victim.z_index = -1
		victim.play("die")
		
	# Clean up after a delay
	var t = victim.create_tween()
	t.tween_property(victim, "modulate:a", 0, 1.0).set_delay(2.0)
	t.finished.connect(victim.queue_free)
