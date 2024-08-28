extends Area2D

var can_shoot = true
var bullet_scene = preload("res://enemy_bullet.tscn")
@export var health: int = 0
var attackType
var player
var mainScene
var chasing: bool = false
var speed: int = 50

func _ready():
	randomize()
	if randi_range(1, 3) == 3: attackType = "chase"
	else: attackType = "shoot"
	print(attackType)

var velocity = Vector2(0, 0)
func _process(delta):
	if randi_range(0, 1000) == 50:
		if attackType == "chase": chasing = true

		if attackType == "shoot": shoot()

	if chasing == true:
		if player.position.x > position.x: velocity.x = delta * speed
		elif player.position.x < position.x: velocity.x = delta * -speed
		else: velocity.x = 0
		if player.position.y > position.y: velocity.y = delta * speed
		elif player.position.y < position.y: velocity.y = delta * -speed
		else: velocity.y = 0

	position += velocity

func create(enemy_type: String, mod: int, inpPlayer, inpMainScene):
	$EnemySprite.play(enemy_type)
	match enemy_type:
		"alan": health = 2 * mod
		"bonbon": health = 1 * mod
		"lip": health = 4 * mod
	player = inpPlayer
	mainScene = inpMainScene

func damage(dmg: int):
	health -= dmg
	if health <= 0: self.explode()

func explode():
	mainScene.kills += 1
	remove_from_group("enemy")
	$ExplosionSprite.play("explode")
	$EnemySprite.visible = false
	$CollisionShape2D.visible = false
	await $ExplosionSprite.animation_finished
	queue_free()


func shoot():
	var blt = bullet_scene.instantiate()
	get_tree().root.add_child(blt)
	blt.create(position + Vector2(0, -2), 1)
