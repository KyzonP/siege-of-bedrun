extends Node2D

signal plantDestroyed

# Packed scenes
@export var sunScene : PackedScene

func action():
	# Place the plant!
	var sunInst = sunScene.instantiate()
	get_parent().add_child(sunInst)
	
	sunInst.global_position = global_position
	sunInst.clicked.connect(get_parent().sunIncrease)
	
func destroy():
	emit_signal("plantDestroyed")
	self.queue_free()

func collide():
	$animationHandler.pile_in(28)

func endCollide():
	$animationHandler.end_pile_in()
	
func plantHurt(hp, maxHp):
	$animationHandler.sync_swarm_to_health(hp, maxHp)
