extends ProjectileAbility
class_name BoomerangAbility

@onready var sprite: Sprite2D = $Sprite
@onready var hit_effect: AnimatedSprite2D = $HitEffect
@onready var hit_box_component: HitBoxComponent = $HitBoxComponent
@onready var timer: Timer = $Timer

var max_range: float = 100.0
var direction: Vector2 = Vector2.ZERO
var speed: float = 200.0
var rotate_speed: float = 50.0

var rebound_count: int = 3
var enterd_list: Array[int]

func _ready() -> void:
	change_direction()
	hit_box_component.area_entered.connect(_on_area_entered)
	timer.timeout.connect(_on_timeout)

func _process(delta: float) -> void:
	position += direction * speed * delta
	rotate(direction.angle() * rotate_speed * delta)

func change_direction() -> void:
	var nearest_targetable = find_nearest_targetable(global_position, max_range)
	if nearest_targetable:
		direction = global_position.direction_to(nearest_targetable.global_position)

func find_nearest_targetable(center: Vector2, max_range: float) -> Node2D:
	var targetables: Array[Node] = Groups.targetables
	targetables = targetables.filter(func(targetable: Node2D) -> bool: 
		return targetable.global_position.distance_squared_to(center) < max_range * max_range and not enterd_list.has(targetable.get_instance_id())
	)
	
	if targetables.size() == 0:
		return
	
	targetables.sort_custom(func(a : Node2D, b:Node2D) -> bool:
		var a_distance: float = a.global_position.distance_squared_to(center)
		var b_distance: float = b.global_position.distance_squared_to(center)
		return a_distance < b_distance
	)
	
	return targetables[0]

func destroy() -> void:
	set_process(false)
	sprite.hide()
	hit_effect.show()
	hit_effect.play()
	await hit_effect.animation_finished
	queue_free()
	
func _on_area_entered(area: Area2D) -> void:
	enterd_list.append(area.get_instance_id())
	var nearest_targetable = find_nearest_targetable(global_position, 150.0)
	if enterd_list.size() < rebound_count and nearest_targetable:
		var nearest_direction = global_position.direction_to(nearest_targetable.global_position)
		direction = nearest_direction
	else:
		destroy()

func _on_timeout() -> void:
	destroy()
