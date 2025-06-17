extends Ability
class_name ProjectileAbility

@export var damage: float = 10.0
@export var speed: float = 50.0
@export var life_duration: float = 10.0

@onready var sprite: Sprite2D = $Sprite
@onready var hit_effect: AnimatedSprite2D = $HitEffect
@onready var hit_box_component: HitBoxComponent = $HitBoxComponent
@onready var timer: Timer = $Timer

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	rotation = direction.angle()
	hit_box_component.damage = damage
	hit_box_component.area_entered.connect(_on_area_entered)
	timer.wait_time = life_duration
	timer.timeout.connect(_on_timeout)
	
func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_area_entered(_area: Area2D) -> void:
	pass

func _on_timeout() -> void:
	destroy()

func destroy() -> void:
	set_process(false)
	sprite.hide()
	hit_effect.show()
	hit_effect.play()
	await hit_effect.animation_finished
	queue_free()

func effect() -> void:
	hit_effect.show()
	hit_effect.play()
	await hit_effect.animation_finished
	hit_effect.hide()
