extends Area2D

var speed : float = 50.0
var damage : int = 1
var maxRange : int = 8
var startPosX: float = 0.0
var is_dying : bool = false

### ANIMATION ###
var intercept_x : float
var travel_time : float
var target

func _ready():
	area_entered.connect(collision)
	event_bus.zombieSpawned.connect(new_target_check)
	
	new_target_check()

func _physics_process(delta):
	position.x += speed * delta

	if position.x > (startPosX + (maxRange * 64)):
		_start_impact_sequence()

func collision(body):
	if is_dying: return
	if "damage" in body:
		body.hurt(damage)
		_start_impact_sequence()
	
func _start_impact_sequence():
	is_dying = true
	
	# Disable collisions
	$CollisionShape2D.set_deferred("disabled", true)
	
### ANIMATION BASED FUNCTIONS ###
func new_target_check():
	calculate_intercept(find_target_zombie())

func find_target_zombie() -> Node2D:
	var nearest_zombie = null
	var min_dist = INF
	
	var all_zombies = get_tree().get_nodes_in_group("Zombie")
	
	for zombie in all_zombies:
		# Check if same y position (with a slight margin)
		if abs(zombie.global_position.y - global_position.y) < 10:
			# Check if they're ahead of the projectile
			if zombie.global_position.x > global_position.x:
				# Find zombie with smallest distance
				var dist = global_position.distance_squared_to(zombie.global_position)
				if dist < min_dist:
					min_dist = dist
					nearest_zombie = zombie
	return nearest_zombie
	
func calculate_intercept(target_zombie):
	if target_zombie != null:
		var distance = abs(target_zombie.global_position.x - global_position.x)
		var relative_speed = speed + target_zombie.speed
		
		travel_time = distance / relative_speed
		
		#Place they will meet
		intercept_x = global_position.x + (speed * travel_time)
		
	else:
		var default_distance = 512.0
		travel_time = default_distance / speed
		intercept_x = global_position.x + default_distance
		print("No target")
		
	if target_zombie != target:
		var distance_to_target = abs(intercept_x - global_position.x)
		# Clamping height so close up shots dont get ridiculously high
		var dynamic_height = clamp(-distance_to_target * 0.2, -150.0, -20.0)
			
		$ArrowSwarm.current_travel_time = travel_time
		$ArrowSwarm.arc_height = dynamic_height
		
		target = target_zombie
		
	
