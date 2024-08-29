extends Area2D


# controls
@export var speed: int = 150
@onready var screensize: Vector2 = get_viewport_rect().size

func _process(delta: float) -> void:
	var input = Input.get_vector("left", "right", "up", "down")

	if input.x > 0:
		$Sprite2D.frame = 2
		$AnimatedSprite2D.animation = "right"
	elif input.x < 0:
		$Sprite2D.frame = 0
		$AnimatedSprite2D.animation = "left"
	else:
		$Sprite2D.frame = 1
		$AnimatedSprite2D.animation = "forward"

	if Input.is_action_just_pressed("shoot"): shoot()

	if Input.is_action_just_pressed("burst"): burst()

	position += input * speed * delta
	position = position.clamp(Vector2.ZERO, screensize)

# bullets
var can_shoot: bool = true
var bullet_cooldown: float = 0.25
var bullet_scene = preload("res://bullet.tscn")
# burst
var can_burst: bool = true
var burst_cooldown: float = 4.0
var burst_scene = preload("res://burst.tscn")

func shoot():
	if not can_shoot: return
	can_shoot = false
	$BulletTimer.start()

	var blt1 = bullet_scene.instantiate()
	get_tree().root.add_child(blt1)
	blt1.create(position + Vector2(5, -8), 1)
	var blt2 = bullet_scene.instantiate()
	get_tree().root.add_child(blt2)
	blt2.create(position + Vector2(-5, -8), 1)

func burst():
	if not can_burst: return
	can_burst = false
	$BurstTimer.start()

	var brst = burst_scene.instantiate()
	get_tree().root.add_child(brst)
	brst.burst(position, 1)

func _on_bullet_timer_timeout() -> void: can_shoot = true
func _on_burst_timer_timeout() -> void: can_burst = true


# player receives damage
@export var health: int = 7
var can_take_dmg: bool = true

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy") and is_in_group("player"): damage(area.health)

func damage(dmg: int) -> void:
	if not can_take_dmg: return
	can_take_dmg = false
	$DamageTimer.start()

	health -= dmg
	$AnimationPlayer.play("rcvd_dmg")
	print(health)

func _on_damage_timer_timeout() -> void: can_take_dmg = true


# instantiation
func _ready() -> void:
	position.x = screensize.x / 2
	position.y = 3 * (screensize.y / 4)

	$BulletTimer.wait_time = bullet_cooldown
	$BurstTimer.wait_time = burst_cooldown
	$DamageTimer.wait_time = $AnimationPlayer.get_animation("rcvd_dmg").length
