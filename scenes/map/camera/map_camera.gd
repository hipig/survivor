extends Camera2D
class_name MapCamera

@export var random_strength: float = 9.0
@export var shake_fade: float = 5.0

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var target_position: Vector2 = Vector2.ZERO


func _ready() -> void:
	make_current()

func _process(delta : float) -> void:
	acquire_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 20))
	
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, 1.0 - exp(-delta * shake_fade))
		offset = random_offset()
		if offset.x < 0.1 and offset.y < 0.1:
			offset = Vector2.ZERO

func apply_shake() -> void:
	shake_strength = random_strength

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

func acquire_target() -> void:
	var player: Player = Groups.player
	if player:
		target_position = player.global_position
