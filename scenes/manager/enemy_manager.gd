extends Node2D
class_name EnemyManager

const SPAWN_RADIUS = 300

@export_file("*.json") var spawn_config: String

@onready var timer: Timer = $Timer

var all_enemies: Dictionary = {}

var spawn_interval: float = 1.0
var spawn_count: int = 0
var spawn_difficulty_count: int = 1
var spawn_table: Array[WeightTable] = []

var should_spawn: bool = true
var current_difficulty: int = 0

func _ready() -> void:
	load_all_enemies()
	prepare_spawn_table()
	timer.wait_time = spawn_interval
	timer.timeout.connect(_on_timeout)
	Events.enemy_died.connect(_on_enemy_died)
	Events.arena_difficulty_increased.connect(_on_arena_difficulty_increased)

func prepare_spawn_table() -> void:
	var spawn_pool = JSON.parse_string(FileAccess.get_file_as_string(spawn_config)) as Array[Dictionary]
	for pool in spawn_pool:
		var weight_table: WeightTable = WeightTable.new()
		for enemy in pool.keys():
			var enemy_scene: PackedScene = get_enemy_scene(enemy)
			if enemy_scene:
				weight_table.add_item(enemy_scene, pool[enemy])
		spawn_table.append(weight_table)

func load_all_enemies() -> void:
	all_enemies = FileLoader.load_directory_to_dict("scenes/characters/enemies", ["tscn"])
	
func get_enemy_scene(enemy: String) -> PackedScene:
	var enemy_key: String = enemy + "_enemy"
	if all_enemies.has(enemy_key):
		return all_enemies.get(enemy_key)
	return
	
func get_spawn_position() -> Vector2:
	var player: Player = Groups.player
	if player == null:
		return Vector2.ZERO
	
	var spawn_position: Vector2 = Vector2.ZERO
	
	var random_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var sector_count: int = 18
	var sector_size: float = TAU / sector_count
	for i in sector_count:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		var additional_check_offset: Vector2 = random_direction * 30
		
		var space_state = get_world_2d().direct_space_state
		var query_parameters := PhysicsRayQueryParameters2D.create(player.global_position,spawn_position + additional_check_offset, 1)
		var results := space_state.intersect_ray(query_parameters)
	
		if results.is_empty():
			return spawn_position
		else:
			random_direction = random_direction.rotated(deg_to_rad(sector_size))

	return Vector2.ZERO
	
func pick_random_enemy(difficulty: int) -> PackedScene:
	if difficulty >= spawn_table.size():
		difficulty = -1
	return spawn_table[difficulty].pick_item()	
	
func increase_difficulty(arena_difficulty: int) -> void:
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
			var spawn_position: Vector2 = get_spawn_position()
			if spawn_position != Vector2.ZERO:
				enemy.global_position = spawn_position
				var entities_layer: Node2D = Groups.entities_layer
				entities_layer.add_child(enemy)
				spawn_count += 1

func _on_enemy_died(_enemy: Enemy) -> void:
	spawn_count -= 1

func _on_arena_difficulty_increased(difficulty: int) -> void:
	increase_difficulty(difficulty)
