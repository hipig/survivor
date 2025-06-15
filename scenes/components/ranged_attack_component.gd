extends Node2D
class_name RangedAttackComponent

@export var projectile: PackedScene
@export var projectile_speed: float = 50.0
@export var cooldown: float = 1.0

@onready var timer: Timer = $Timer

var can_shoot: bool = true

func _ready() -> void:
	timer.wait_time = cooldown
	timer.timeout.connect(_on_timeout)

func shoot(direction: Vector2) -> void:
	if not can_shoot:
		return
	var owner_node2d: Node2D = owner as Node2D
	if owner_node2d == null:
		return

	can_shoot = false
	timer.start()
	
	var foreground_layer: Node = Groups.foreground_layer
	var projectile_instance: EnemyProjectile = projectile.instantiate()
	projectile_instance.global_position = owner_node2d.global_position
	projectile_instance.direction = direction
	projectile_instance.speed = projectile_speed
	foreground_layer.add_child(projectile_instance)

func _on_timeout() -> void:
	can_shoot = true
	
