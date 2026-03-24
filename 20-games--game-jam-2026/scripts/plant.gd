extends Area2D

signal plantDestroyed

func remove():
	emit_signal("plantDestroyed")
	pass
