extends Node2D

@onready var animation_handler : Node2D = $animationHandler

var zombieHandler : Area2D

func _ready():
	pass
	
func destroy():
	self.queue_free()

func plantCollision(body, handler):
	handler.target = body
	handler.state = handler.States.EATING
	animation_handler.pile_in(-28)
	
	if "collide" in body:
		body.collide()
	
func plantEaten(_body, handler):
	handler.target = null
	animation_handler.end_pile_in()
	
func resume_moving():
	zombieHandler.state = zombieHandler.States.MOVING
	
func zombieHurt(hp, max_hp):
	animation_handler.sync_swarm_to_health(hp, max_hp)
