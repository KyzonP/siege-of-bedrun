extends Area2D

# Max of variables
@export var actionTimeMax : float = 1.5
@export var maxHp = 6
# Current of variables
@export var actionTimer = 17.0
var hp : int = 100

###  Signals ###
#If the plant is destroyed
signal plantDestroyed
# When enough time elapses for the plants action to occur
signal action
# If collided with
signal collision
# If collision ended
signal endCollision
# Plant gets hurt
signal plantHurt

func _ready():
	hp = maxHp
	
	if "action" in get_parent():
		action.connect(get_parent().action)
	if "destroy" in get_parent():
		plantDestroyed.connect(get_parent().destroy)
	if "collide" in get_parent():
		collision.connect(get_parent().collide)
	if "endCollide" in get_parent():
		endCollision.connect(get_parent().endCollide)
	if "plantHurt" in get_parent():
		plantHurt.connect(get_parent().plantHurt)

func remove():
	emit_signal("plantDestroyed")
	get_parent().queue_free()
	
func _physics_process(delta):
	if actionTimeMax != 0:
		actionTimer += delta
		if actionTimer >= actionTimeMax:
			actionTimer = 0
			emit_signal("action")
		
func hurtPlant(damage):
	hp = hp - damage
	emit_signal("plantHurt", hp, maxHp)
	if hp <= 0:
		hp = 0
		remove()
		
func collide():
	emit_signal("collision")

func endCollide():
	emit_signal("endCollision")
