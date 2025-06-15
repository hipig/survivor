extends ProjectileAbility
class_name SpearAbility

@onready var sprite: Sprite2D = $Sprite
@onready var hit_effect: AnimatedSprite2D = $HitEffect
@onready var hit_box_component: HitBoxComponent = $HitBoxComponent
@onready var timer: Timer = $Timer

var direction: Vector2 = Vector2.ZERO
var speed: float = 120.0

var max_pierce_count: int = 5
var pierced_count: int = 0

func _ready() -> void:
	hit_box_component.area_entered.connect(_on_area_entered)
	timer.timeout.connect(_on_timeout)
	
func set_direction(new_direction: Vector2) -> void:
	direction = new_direction
	rotation = direction.angle()

func _process(delta: float) -> void:
	position += direction * speed * delta

func destroy() -> void:
	set_process(false)
	sprite.hide()
	hit_effect.show()
	hit_effect.play()
	await hit_effect.animation_finished
	queue_free()
	
func _on_area_entered(_area: Area2D) -> void:
	pierced_count += 1
	
	if pierced_count >= max_pierce_count:
		destroy()

func _on_timeout() -> void:
	destroy()
