extends Node2D
class_name EnemyManager

const SPAWN_RADIUS = 375

@export_file("*.json") var spawn_config: String

@onready var timer: Timer = $Timer

var spawn_interval: float = 1.0
var spawn_count: int = 0
var spawn_difficulty_count: int = 1
var spawn_table: Array[WeightTable] = []

var should_spawn: bool = true
var current_difficulty: int = 0

func _ready() -> void:
	prepare_spawn_table()
	timer.wait_time = spawn_interval
	timer.timeout.connect(_on_timeout)

func prepare_spawn_table() -> void:
	print(FileAccess.get_file_as_string(spawn_config))
	var spawn_pool = JSON.parse_string(FileAccess.get_file_as_string(spawn_config)) as Array[Dictionary]
	for pool in spawn_pool:
		var weight_table: WeightTable = WeightTable.new()
		for enemy in pool.keys():
			var enemy_scene: PackedScene = get_enemy_scene(enemy)
			weight_table.add_item(enemy_scene, pool[enemy])
		spawn_table.append(weight_table)

func get_enemy_scene(enemy: String) -> PackedScene:
	return load("res://scenes/characters/enemies/%s/%s_enemy.tscn" % [enemy, enemy])
	
func get_spawn_position() -> Vector2:
	var player: Player = Groups.player
	if player == null:
		return Vector2.ZERO
	
	var spawn_position: Vector2 = Vector2.ZERO
	
	var random_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in 18:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		var additional_check_offset: Vector2 = random_direction * 30
		
		var query_parameters := PhysicsRayQueryParameters2D.create(player.global_position,spawn_position + additional_check_offset, 1)
		var result := get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
	
		if result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(20))

	return spawn_position
	
func pick_random_enemy(difficulty: int) -> PackedScene:
	if difficulty >= spawn_table.size():
		difficulty = -1
	return spawn_table[difficulty].random_item()	
	
func difficulty_increased(arena_difficulty: int) -> void:
	current_difficulty = arena_difficulty
	var time_off: float = (0.1 / 12) * arena_difficulty
	time_off = min(time_off, 0.75)
	timer.wait_time = spawn_interval - time_off
	spawn_difficulty_count += 1	
	
func _on_timeout() -> void:
	timer.start()
	
	if spawn_count > 200:
		return

	var player: Player = Groups.player
	if player == null:
		return

	if not should_spawn:
		return
	
	for i in spawn_difficulty_count:
		var spawn_item: PackedScene = pick_random_enemy(current_difficulty)
		if spawn_item:
			var enemy: Node2D = spawn_item.instantiate() as Node2D
			enemy.global_position = get_spawn_position()
			var entities_layer: Node2D = Groups.entities_layer
			entities_layer.add_child(enemy)
			spawn_count += 1
