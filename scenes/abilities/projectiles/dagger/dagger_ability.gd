extends ProjectileAbility
class_name DaggerAbility

@onready var sprite: Sprite2D = $Sprite
@onready var hit_effect: AnimatedSprite2D = $HitEffect
@onready var hit_box_component: HitBoxComponent = $HitBoxComponent

var direction: Vector2 = Vector2.ZERO
var speed: float = 150.0

func _ready() -> void:
	hit_box_component.area_entered.connect(_on_area_entered)
	
func set_direction(new_direction: Vector2) -> void:
	direction = new_direction
	rotation = direction.angle()

func _process(delta: float) -> void:
	position += direction * speed * delta
	
func _on_area_entered(_area: Area2D) -> void:
	set_process(false)
	sprite.hide()
	hit_effect.show()
	hit_effect.play()
	await hit_effect.animation_finished
	queue_free()
