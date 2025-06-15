extends Node2D
class_name UpgradeManager

const MAX_BASE_ABILITIES: int = 6

var all_upgrades: Dictionary = {}
var upgrade_pool: WeightTable = WeightTable.new()
var current_upgrades: Dictionary = {}

var base_abilities : Array[AbilityUnlock] = []

func _ready() -> void:
	load_all_upgrades()
	initialize_upgrade_pool()
	Events.level_up.connect(_on_level_up)
	Events.upgrade_selected.connect(_on_upgrade_selected)
	
func load_all_upgrades() -> void:
	all_upgrades = FileLoader.load_directory_to_dict("resources/upgrades", ["tres"])
	
func initialize_upgrade_pool() -> void:
	for item in all_upgrades.values():
		if item is AbilityUnlock:
			upgrade_pool.add_item(item, item.weight)

func apply_upgrade(upgrade: Upgrade) -> void:
	var has_upgrade: bool = current_upgrades.has(upgrade.id)
	if not has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"level": 1
		}
	else:
		current_upgrades[upgrade.id]["level"] += 1
	
	if upgrade.max_level > 0:
		var current_level: int = current_upgrades[upgrade.id]["level"]
		if current_level >= upgrade.max_level:
			upgrade_pool.remove_item(upgrade)
	
	if upgrade is AbilityUnlock:
		base_abilities.append(upgrade)
	
	update_upgrade_pool(upgrade)
	Events.emit_upgrade_added(upgrade, current_upgrades)
	
func update_upgrade_pool(upgrade: Upgrade):
	for item in all_upgrades.values():
		if item is AbilityUpgrade and item.relation_id == upgrade.id:
			upgrade_pool.add_item(item, item.weight)

func pick_upgrades() -> Array[Upgrade]:
	var chosen_upgrades: Array[Upgrade] = []
	if base_abilities.size() == MAX_BASE_ABILITIES:
		remove_base_abilities()
	
	for i in 3:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		var chosen_upgrade: Upgrade = upgrade_pool.pick_item(chosen_upgrades)
		if  chosen_upgrade:
			chosen_upgrades.append(chosen_upgrade)
	
	return chosen_upgrades
	
func remove_base_abilities() -> void:
	var abilities_in_pool: Array
	
	for item in upgrade_pool.items:
		if item["item"] is Ability:
			abilities_in_pool.append(item["item"])
			
	for ability in abilities_in_pool:
		upgrade_pool.remove_item(ability)

func _on_level_up(_level: int) -> void:
	var chosen_upgrades = pick_upgrades()
	Events.emit_upgrades_generated(chosen_upgrades, current_upgrades)

func _on_upgrade_selected(upgrade: Upgrade) -> void:
	apply_upgrade(upgrade)
