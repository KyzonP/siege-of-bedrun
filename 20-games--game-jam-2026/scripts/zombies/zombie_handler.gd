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
signal plantEaten
signal zombieHurt

enum States {MOVING, EATING}

func _ready():
	add_to_group("Zombie")
	event_bus.emit_signal("zombieSpawned")
	
	area_entered.connect(collision)
	
	get_parent().zombieHandler = self
	
	hp = maxHp
	
	if "destroy" in get_parent():
		destroy.connect(get_parent().destroy)
	if "plantCollision" in get_parent():
		plantCollision.connect(get_parent().plantCollision)
	if "plantEaten" in get_parent():
		plantEaten.connect(get_parent().plantEaten)
	if "zombieHurt" in get_parent():
		zombieHurt.connect(get_parent().zombieHurt)

func _physics_process(delta):
	if state == States.MOVING:
		get_parent().position.x -= speed * delta
	elif state == States.EATING:
		attackTimer += delta
		if attackTimer >= attackTimerMax:
			attackTimer = 0
			if target != null:
				target.hurtPlant(damage)
			else:
				collisionEnd()
	
func hurt(enemyDamage):
	hp = hp - enemyDamage
	emit_signal("zombieHurt", hp, maxHp)
	if hp <= 0:
		hp = 0
		if target != null:
			target.endCollide()
		emit_signal("destroy")

func collision(body):
	emit_signal("plantCollision", body, self)
	
func collisionEnd(_body : Area2D = null):
	emit_signal("plantEaten", target, self)
