extends Area2D

var speed : float = 50.0
var damage : int = 1
var maxRange : int = 8
var startPosX: float = 0.0

func _ready():
	area_entered.connect(collision)

func _physics_process(delta):
	position.x += speed * delta

	if position.x > (startPosX + (maxRange * 64)):
		_destroy()

func collision(body):
	if "damage" in body:
		body.hurt(damage)
		_destroy()
		
func _destroy():
	queue_free()
