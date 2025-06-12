extends Area2D
class_name MagnetComponent

@export var magnet_strength: float = 300.0   # 磁力强度
@export var magnet_radius: float = 150.0      # 磁力作用半径
@export var collection_distance: float = 30.0 # 收集距离

var target_items: Array[Node2D] = []

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
func _process(_delta: float) -> void:
	if target_items.size() == 0:
		return
	
	for item in target_items:
		var distance = global_position.distance_to(item.global_position)
		if distance <= collection_distance:
			collect_item(item)
			
func collect_item(item: Node2D) -> void:
	var owner_node2d: Node2D = owner as Node2D
	if owner_node2d == null:
		return
	
	if item.has_method("start_collect"):
		item.start_collect(owner_node2d)
	
	target_items.erase(item)
	
func _on_area_entered(area: Area2D) -> void:
	if not target_items.has(area):
		target_items.append(area)

func _on_area_exited(area: Area2D) -> void:
	if target_items.has(area):
		target_items.erase(area)
