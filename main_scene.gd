extends Node2D

var enemy = preload("res://enemy.tscn")
var kills = 0
const enemies = ["alan", "bonbon", "lips"]

var wave_points: int = 0
func spawn_enemies():
	for i in 9:
		for j in 3:
			var e = enemy.instantiate()
			var pos = Vector2(i * (16 + 8) + 24, 16 * 4 + j * 16)
			add_child(e)
			e.create(enemies[randi_range(0, 2)], randi_range(1, 3), $Player, self)
			e.position = pos

func _ready() -> void:
	randomize()
	$GameOverScreen.visible = false
	spawn_enemies()

func _process(_delta: float) -> void:
	if $Player.health <= 0: game_over()
	if kills >= 27:
		kills = 0
		spawn_enemies()

func game_over() -> void:
	$Background.z_index = 98
	$GameOverScreen.visible = true
	$Player.remove_from_group("player")

func _on_texture_button_pressed() -> void:
	if $GameOverScreen.visible == false: return
	get_tree().reload_current_scene()
