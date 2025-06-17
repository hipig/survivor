extends ProjectileAbility
class_name ArrowAbility

var split_count: int = 3
var split_angle: float =  PI/3
var split_level: int = 1
var is_split: bool = false

var invincible_duration: float = 0.2
var monitoring_disabled: bool = false

@onready var collision_shape_2d: CollisionShape2D = $HitBoxComponent/CollisionShape2D

func _ready() -> void:
	if is_split:
		monitoring_disabled = true
		collision_shape_2d.disabled = true
	super._ready()

func _process(delta: float) -> void:
	super._process(delta)
	
	if monitoring_disabled:
		invincible_duration -= delta
		if invincible_duration <= 0:
			monitoring_disabled = false
			collision_shape_2d.disabled = false

func _on_area_entered(_area: Area2D) -> void:
	if monitoring_disabled:
		return
	
	split_arrow()
	destroy()

func split_arrow() -> void:
	if split_level == 0 or split_count == 0:
		return
		
	var foreground: Node2D = Groups.foreground_layer as Node2D
	if foreground == null:
		return
	
	var base_angle = direction.angle()
	var angle_step = split_angle / (split_count - 1)
	var new_level = split_level - 1
	
	for i in range(split_count):
		var angle = base_angle - split_angle/2 + i * angle_step
		var new_direction = Vector2(cos(angle), sin(angle))
		var new_arrow: ArrowAbility = duplicate(DUPLICATE_USE_INSTANTIATION)
		new_arrow.direction = new_direction
		new_arrow.damage = damage * 0.8
		new_arrow.scale = scale * 0.9
		new_arrow.split_level = new_level
		new_arrow.is_split = true
		foreground.call_deferred("add_child", new_arrow)
	
