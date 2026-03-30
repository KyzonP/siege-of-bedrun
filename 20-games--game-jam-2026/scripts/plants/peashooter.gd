extends Node2D
	
@onready var pea = preload("res://scenes/projectile.tscn")

@export var damage : int = 1
@export var speed : float = 50.0
@export var distance : int = 8

signal plantDestroyed
	
func action():
	var peaInst = pea.instantiate()
	peaInst.global_position = self.global_position
	peaInst.startPosX = self.global_position.x
	peaInst.damage = damage
	peaInst.speed = speed
	get_parent().add_child(peaInst)

func destroy():
	emit_signal("plantDestroyed")
	self.queue_free()

func collide():
	$animationHandler.pile_in(28)

func endCollide():
	$animationHandler.end_pile_in()
	
func plantHurt(hp, maxHp):
	$animationHandler.sync_swarm_to_health(hp, maxHp)
