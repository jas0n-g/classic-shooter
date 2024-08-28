extends Area2D

# TODO - fix dmg
@export var dmg: int = 100

func burst(pos: Vector2, inpDmg: int) -> void:
	position = pos
	dmg = inpDmg

	$AnimationPlayer.play("grow")
	await $AnimationPlayer.animation_finished
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		area.explode()
