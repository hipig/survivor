extends Node2D
class_name HealthComponent

signal died
signal health_changed
signal health_decreased

@export var max_health: float = 10

var current_health: float
var is_dead: bool = false

func _ready() -> void:
	current_health = max_health
	
func damage(damage_amount: float) -> void:
	current_health = clamp(current_health - damage_amount, 0, max_health)
	health_changed.emit()
	if damage_amount > 0:
		health_decreased.emit()
	
	Callable(check_death).call_deferred()

func heal(heal_amount: float) -> void:
	damage(-heal_amount)	

func set_max_health(new_max_health: float, update_current_health: bool) -> void:
	max_health = new_max_health
	if update_current_health:
		current_health = max_health
		
func get_health_percent() -> float:
	if max_health <= 0:
		return 0
	return min(current_health / max_health,1)

func check_death() -> void:
	if current_health == 0 and not is_dead:
		died.emit()
		is_dead = true		
