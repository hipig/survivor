extends Node2D
class_name AbilityController

@export var id: String
@export var icon: Texture2D
@export var release_duration: float = 1.0
@export var max_range: float = 150.0
@export var base_damage: float = 10.0
@export var base_count: int = 1

@onready var timer: Timer = $Timer

var damage: float = base_damage
var count: int = base_count

func _ready() -> void:
	timer.wait_time = release_duration
	timer.timeout.connect(_on_timeout)
	Events.upgrade_added.connect(_on_upgrade_added)

func _on_timeout() -> void:
	var player: Player = Groups.player
	if player == null or player.is_dead:
		return
	
	var foreground: Node2D = Groups.foreground_layer as Node2D
	if foreground == null:
		return
		
	var targetables: Array[Node] = Groups.targetables
	targetables = targetables.filter(func(targetable: Node2D) -> bool: 
		return targetable.global_position.distance_squared_to(player.global_position) < max_range * max_range
	)
	
	if targetables.size() == 0:
		return
	
	release(player, foreground, targetables)
	
func _on_upgrade_added(upgrade: Upgrade, current_upgrades: Dictionary) -> void:
	upgrade_added(upgrade, current_upgrades)

func release(_player: Player, _foreground: Node2D, _targetables: Array[Node]) -> void:
	pass

func upgrade_added(_upgrade: Upgrade, _current_upgrades: Dictionary) -> void:
	pass
