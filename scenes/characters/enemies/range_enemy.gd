extends Enemy
class_name RangeEnemy

@export var attack_range: float = 200.0

@onready var ranged_attack_component: RangedAttackComponent = $RangedAttackComponent

func _ready() -> void:
	state_machine.start()
	hurt_box_component.hurted.connect(_on_hurted)
	health_component.died.connect(_on_died)

func _process(_delta: float) -> void:
	var target_direction: Vector2 = get_target_direction_in_range()
	if target_direction == Vector2.ZERO:
		velocity_component.accelerate_to_player()
	else:
		direction = target_direction
		velocity_component.decelerate()
		attack(target_direction)
	
	velocity_component.move(self)

func get_target_direction_in_range() -> Vector2:
	var player: Player = Groups.player
	if player == null or player.is_dead: 
		return Vector2.ZERO

	if player.global_position.distance_squared_to(global_position) < attack_range * attack_range:
		return global_position.direction_to(player.global_position)
	return Vector2.ZERO
	
func attack(target_direction: Vector2) -> void:
	ranged_attack_component.shoot(target_direction)

func _on_hurted(damage: float) -> void:
	health_component.damage(damage)
	state_machine.transition_to("Hit")

func _on_died() -> void:
	Events.emit_enemy_died(self)
	state_machine.transition_to("Die")
