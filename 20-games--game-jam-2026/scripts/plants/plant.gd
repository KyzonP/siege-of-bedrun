extends Area2D

# Max of variables
@export var actionTimeMax : float = 1.5
@export var maxHp = 6
# Current of variables
var actionTimer = 0.0
var hp : int = 100

###  Signals ###
#If the plant is destroyed
signal plantDestroyed
# When enough time elapses for the plants action to occur
signal action

func _ready():
	hp = maxHp
	
	if "action" in get_parent():
		action.connect(get_parent().action)
	if "destroy" in get_parent():
		plantDestroyed.connect(get_parent().destroy)

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
	if hp <= 0:
		hp = 0
		remove()
