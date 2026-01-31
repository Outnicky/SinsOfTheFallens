class_name  EnemyHitbox extends Area2D

@onready var s = $".."

func take_damage(amount):
	print("OUCH")
	s.health -= amount
	if s.health <= 0:
		s.queue_free()

func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		body.take_damage(s)
	pass
