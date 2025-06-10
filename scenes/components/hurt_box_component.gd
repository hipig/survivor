extends Area2D
class_name HurtBoxComponent

signal hurted(damage: float)

const FLOATING_TEXT = preload("res://scenes/ui/floating_text/floating_text.tscn")

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area: Area2D) -> void:
	if not area is HitBoxComponent:
		return
		
	var hitbox_component: HitBoxComponent = area as HitBoxComponent
	var damage: float = hitbox_component.damage
	var damage_type: HitBoxComponent.DamageType = hitbox_component.damage_type
	
	var floating_text: Node2D = FLOATING_TEXT.instantiate()
	Groups.foreground_layer.add_child(floating_text)
	
	floating_text.global_position = global_position + (Vector2.UP * 16)
	var format_string: String = "%0.1f"
	if round(damage) == damage:
		format_string = "%0.0f"
	floating_text.start(format_string % damage)
	
	hurted.emit(damage)
	Events.emit_enemy_damaged()
	
