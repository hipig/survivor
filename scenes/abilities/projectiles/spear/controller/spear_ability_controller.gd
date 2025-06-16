extends AbilityController

const SPEAR_ABILITY = preload("res://scenes/abilities/projectiles/spear/spear_ability.tscn")

const MAX_RANGE: float = 200.0

@onready var timer: Timer = $Timer

var max_pierce: int = 3
var base_damage: float = 15.0
var damage: float = base_damage
var release_interval: float = 1.2

var count: int = 1

func _ready() -> void:
	timer.wait_time = release_interval
	timer.timeout.connect(_on_timeout)
	Events.upgrade_added.connect(_on_upgrade_added)

func _on_timeout() -> void:
	var player: Player = Groups.player
	if player == null or player.is_dead:
		return
	
	var foreground: Node2D = Groups.foreground_layer as Node2D
	if foreground == null:
		return
	
	var best_direction: Vector2 = find_best_direction(player)
	if best_direction == Vector2.ZERO:
		return
	
	for i in range(count):
		var spear_instance: SpearAbility = SPEAR_ABILITY.instantiate()
		spear_instance.global_position = player.global_position
		spear_instance.max_pierce_count = max_pierce
		spear_instance.set_direction(best_direction)
		foreground.add_child(spear_instance)
		spear_instance.hit_box_component.damage = damage

func find_best_direction(player: Player) -> Vector2:
	var targetables: Array[Node] = Groups.targetables
	targetables = targetables.filter(func(targetable: Node2D) -> bool: 
		return targetable.global_position.distance_squared_to(player.global_position) < MAX_RANGE * MAX_RANGE
	)
	
	if targetables.size() == 0:
		return Vector2.ZERO
	
	var sector_count: int = 32
	var sector_size: float = TAU / sector_count
	var sector_counts: Array = []
	sector_counts.resize(sector_count)
	sector_counts.fill(0)
	for targetable: Node2D in targetables:
		var direction = player.global_position.direction_to(targetable.global_position)
		var angle = atan2(direction.y, direction.x)
		if angle < 0:
			angle += TAU

		var sector_index: int = int(floor(angle / sector_size)) % sector_count
		sector_counts[sector_index] += 1
		
	var max_count = 0
	var best_sector = 0
	for i in range(sector_count):
		if sector_counts[i] > max_count:
			max_count = sector_counts[i]
			best_sector = i
			
	var best_angle = best_sector * sector_size + sector_size / 2.0
	return Vector2(cos(best_angle), sin(best_angle))

func _on_upgrade_added(upgrade: Upgrade, _current_upgrades: Dictionary) -> void:
	match upgrade.id:
		"spear_pierce":
			max_pierce += 1
