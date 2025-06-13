extends CanvasLayer
class_name UpgradeUI

signal upgrade_selected(upgrade: Upgrade)

const UPGRADE_CARD = preload("res://scenes/ui/upgrade/upgrade_card.tscn")

@onready var card_container: HBoxContainer = $MarginContainer/CardContainer

func _ready() -> void:
	hide()
	Events.level_up.connect(_on_level_up)
	Events.upgrades_generated.connect(_on_upgrades_generated)

func open() -> void:
	get_tree().paused = true
	show()
	

func close() -> void:
	get_tree().paused = false
	hide()
	
func set_ability_upgrades(upgrades : Array[Upgrade], equipped_upgrades: Dictionary) -> void:
	if upgrades.size() == 0:
		get_tree().paused = false
		return
		
	for child in card_container.get_children():
		child.queue_free()
	
	var delay: float = 0
	for upgrade in upgrades:
		var upgrade_card: Node = UPGRADE_CARD.instantiate()
		card_container.add_child(upgrade_card)
		upgrade_card.set_ability_upgrade(upgrade, equipped_upgrades.get(upgrade.id, {}))
		upgrade_card.selected.connect(on_upgrade_selected.bind(upgrade))
		delay += .2

func _on_level_up(_level: int) -> void:
	open()

func _on_upgrades_generated(upgrades : Array[Upgrade], equipped_upgrades: Dictionary):
	set_ability_upgrades(upgrades, equipped_upgrades)

func on_upgrade_selected(upgrade: Upgrade) -> void:
	upgrade_selected.emit(upgrade)
	close()
