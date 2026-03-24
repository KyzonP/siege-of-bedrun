extends Area2D

@export var maxHp : int = 10
@export var speed : float = 50.0
@export var attackTimerMax : float = 0.5
@export var damage : int = 1

var hp = 100
var attackTimer = 0
var target : Area2D = null

var state : States = States.MOVING

signal destroy
signal plantCollision

enum States {MOVING, EATING}

func _ready():
	area_entered.connect(collision)
	
	hp = maxHp
	
	if "destroy" in get_parent():
		destroy.connect(get_parent().destroy)

func _physics_process(delta):
	if state == States.MOVING:
		position.x -= speed * delta
	elif state == States.EATING:
		attackTimer += delta
		if attackTimer >= attackTimerMax:
			attackTimer = 0
			if target != null:
				target.hurtPlant(damage)
			else:
				collisionEnd()
	
func hurt(damage):
	hp = hp - damage
	if hp <= 0:
		hp = 0
		emit_signal("destroy")
		queue_free()

func collision(body):
	target = body
	state = States.EATING
	emit_signal("plantCollision")
	
func collisionEnd(body : Area2D = null):
	target = null
	state = States.MOVING
	print("Done eating")
