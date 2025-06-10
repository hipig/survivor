extends Area2D
class_name HitBoxComponent

enum DamageType {
	Dagger
}

@export var damage_type: DamageType

var damage: float = 0.0
