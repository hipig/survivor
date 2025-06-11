extends AbilityController
class_name DaggerController

const DAGGER_ABILITY = preload("res://scenes/abilities/projectiles/dagger/dagger_ability.tscn")

const MAX_RANGE = 150

@onready var release_timer: Timer = $ReleaseTimer

var base_damage: float = 10.0
var damage: float
var additional_damage_percent: float = 1
var release_interval: float = 1.0

func _ready() -> void:
	damage = base_damage
	release_timer.wait_time = release_interval
	release_timer.timeout.connect(_on_release_timeout)

func _on_release_timeout() -> void:
	var player: Player = Groups.player
	if player == null or player.is_dead:
		return
	
	var foreground: Node2D = Groups.foreground_layer as Node2D
	if foreground == null:
		return
	
	var targetables: Array[Node] = Groups.targetables
	targetables = targetables.filter(func(targetable: Node2D) -> bool: 
		return targetable.global_position.distance_squared_to(player.global_position) < MAX_RANGE * MAX_RANGE
	)
	
	if targetables.size() == 0:
		return	
	
	targetables.sort_custom(func(a : Node2D, b:Node2D) -> bool:
		var a_distance: float = a.global_position.distance_squared_to(player.global_position)
		var b_distance: float = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)	
		
	var dagger_instance := DAGGER_ABILITY.instantiate() as DaggerAbility
	dagger_instance.global_position = player.global_position
	dagger_instance.direction = dagger_instance.global_position.direction_to(targetables[0].global_position)
	foreground.add_child(dagger_instance)
	dagger_instance.hit_box_component.damage = damage * additional_damage_percent
	
