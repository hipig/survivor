extends Area2D
class_name DropItem

@export var icon: Texture2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var collect_already_in_progress: bool = false

func collect(_collector: Node2D) -> void:
	pass

func start_collect(collector: Node2D) -> void:
	if collect_already_in_progress:
		return
	collect_already_in_progress = true
	
	Callable(disable_collision).call_deferred()
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(self, "scale", Vector2(0.1, 0.1), 0.2)
	tween.chain()
	tween.tween_callback(collect.bind(collector))
	tween.tween_callback(queue_free)
	
func disable_collision() -> void:
	collision_shape_2d.disabled = true	
