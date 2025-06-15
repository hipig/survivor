extends ProjectileAbility
class_name BoomerangAbility

@onready var sprite: Sprite2D = $Sprite
@onready var hit_effect: AnimatedSprite2D = $HitEffect
@onready var hit_box_component: HitBoxComponent = $HitBoxComponent

var direction: Vector2 = Vector2.ZERO
var speed: float = 200.0
var rotate_speed: float = 50.0

func _ready() -> void:
	hit_box_component.area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	position += direction * speed * delta
	rotate(direction.angle() * rotate_speed * delta)
	
func _on_area_entered(_area: Area2D) -> void:
	set_process(false)
	sprite.hide()
	hit_effect.show()
	hit_effect.play()
	await hit_effect.animation_finished
	queue_free()
