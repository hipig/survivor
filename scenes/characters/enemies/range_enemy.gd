extends Enemy
class_name RangeEnemy

@export var attack_range: float = 200.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var drop_component: DropComponent = $DropComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurt_box_component: HurtBoxComponent = $HurtBoxComponent
@onready var ranged_attack_component: RangedAttackComponent = $RangedAttackComponent

func _ready() -> void:
	hurt_box_component.hurted.connect(_on_hurted)
	health_component.died.connect(_on_died)

func _process(_delta: float) -> void:
	var target_direction: Vector2 = get_target_direction_in_range()
	if target_direction == Vector2.ZERO:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()
		attack(target_direction)
	
	velocity_component.move(self)
	
	update_animate_dirction()
	if velocity_component.direction.length() > 0:
		animated_sprite.play("move_" + animate_dirction)
	else:
		animated_sprite.play("idle_" + animate_dirction)

func get_target_direction_in_range() -> Vector2:
	var player: Player = Groups.player
	if player == null or player.is_dead: 
		return Vector2.ZERO

	if player.global_position.distance_squared_to(global_position) < attack_range * attack_range:
		return global_position.direction_to(player.global_position)
	return Vector2.ZERO
	
func attack(direction: Vector2) -> void:
	ranged_attack_component.shoot(direction)

func _on_hurted(damage: float) -> void:
	health_component.damage(damage)
	
	set_process(false)
	animated_sprite.play("hit_" + animate_dirction)
	await animated_sprite.animation_finished
	set_process(true)

func _on_died() -> void:
	Events.emit_enemy_died(self)
	set_process(false)
	animated_sprite.play("die_" + animate_dirction)
	await animated_sprite.animation_finished
	drop_component.drop()
	queue_free()
