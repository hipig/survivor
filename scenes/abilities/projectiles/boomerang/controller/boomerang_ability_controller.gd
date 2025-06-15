extends AbilityController
class_name BoomerangAbilityController

const MAX_RANGE = 150

const BOOMERANG_ABILITY = preload("res://scenes/abilities/projectiles/boomerang/boomerang_ability.tscn")

@onready var timer: Timer = $Timer

var base_damage: float = 5.0
var damage: float = base_damage
var release_interval: float = 0.8

var count: int = 1

func _ready() -> void:
	timer.wait_time = release_interval
	timer.timeout.connect(_on_timeout)
	
func _on_timeout() -> void:
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
	
	var emit_count: int = min(count, targetables.size())
	for i in range(emit_count):
		var boomerang_instance: BoomerangAbility = BOOMERANG_ABILITY.instantiate()
		boomerang_instance.global_position = player.global_position
		boomerang_instance.direction = boomerang_instance.global_position.direction_to(targetables[i].global_position)
		foreground.add_child(boomerang_instance)
		boomerang_instance.hit_box_component.damage = damage
