extends Area2D
class_name EnemyProjectile

@onready var timer: Timer = $Timer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var speed: float = 50.0
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	rotate(direction.angle())
	timer.timeout.connect(_on_timeout)
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	
func destroy() -> void:
	queue_free()

func _on_timeout() -> void:
	destroy()

func _on_area_entered(_area: Area2D) -> void:
	destroy()
