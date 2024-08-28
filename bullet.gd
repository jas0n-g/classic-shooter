extends Area2D

@export var velocity: float = -250
@export var dmg: int = 1

func _process(delta: float) -> void: position.y += velocity * delta
func create(pos: Vector2, inpDmg: int):
	position = pos
	dmg = inpDmg

func _on_visible_on_screen_notifier_2d_screen_exited() -> void: queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		area.damage(dmg)
		queue_free()
