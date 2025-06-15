extends Character
class_name Player

signal player_has_died
signal ability_controller_added(ability_controller: Node)

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var collision_area: Area2D = $CollisionArea2D
@onready var abilities: Node2D = $Abilities
@onready var damage_interval_timer: Timer = $DamageIntervalTimer
@onready var heal_interval_timer: Timer = $HealIntervalTimer
@onready var health_bar: ProgressBar = $HealthBar


var colliding_body_count: int = 0
var is_dead: bool = false

func  _ready() -> void:
	collision_area.body_entered.connect(_on_body_entered)
	collision_area.body_exited.connect(_on_body_exited)
	collision_area.area_entered.connect(_on_body_entered)
	collision_area.area_exited.connect(_on_body_exited)
	damage_interval_timer.timeout.connect(_on_damage_timeout)
	health_component.health_decreased.connect(on_health_decreased)
	health_component.health_changed.connect(on_health_changed)
	health_component.died.connect(on_died)
	Events.upgrade_added.connect(_on_upgrade_added)

func _process(_delta: float) -> void:
	var movement_vector: Vector2 = get_movement_vector()
	var direction: Vector2 = movement_vector.normalized()
	velocity_component.direction = direction
	velocity_component.accelerate_in_direction()
	velocity_component.move(self)
	
	update_animate_dirction()
	if direction.length() > 0:
		animated_sprite.play("walk_" + animate_dirction)
	else:
		animated_sprite.play("idle_" + animate_dirction)
	
func get_movement_vector() -> Vector2:
	var x: float = Input.get_axis("move_left", "move_right")
	var y: float = Input.get_axis("move_up", "move_down")
	return Vector2(x, y)
			
func check_deal_damage() -> void:
	if colliding_body_count == 0 or not damage_interval_timer.is_stopped():
		return
	health_component.damage(1)
	damage_interval_timer.start()

func update_health_display() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(health_bar, "value", health_component.get_health_percent(), 0.6)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
func _on_body_entered(body: Node2D) -> void:
	colliding_body_count += 1
	check_deal_damage()

func _on_body_exited(_body: Node2D) -> void:
	colliding_body_count = max(colliding_body_count - 1, 0)

func _on_damage_timeout() -> void:
	check_deal_damage()

func on_health_decreased() -> void:
	if is_dead:
		return
	Events.emit_player_damaged()
	update_health_display()

func on_health_changed() -> void:
	update_health_display()

func on_died() -> void:
	if is_dead:
		return
	player_has_died.emit()
	is_dead = true
	health_bar.visible = false
	abilities.set_process(false)
	set_process(false)
	animated_sprite.play("die_" + animate_dirction)
	await animated_sprite.animation_finished

func _on_upgrade_added(upgrade: Upgrade, current_upgrades: Dictionary) -> void:
	if upgrade is AbilityUnlock:
		upgrade = upgrade as AbilityUnlock
		var new_ability_controller: AbilityController = upgrade.ability_controller.instantiate()
		abilities.add_child(new_ability_controller)
		Events.emit_ability_controller_added(new_ability_controller)
