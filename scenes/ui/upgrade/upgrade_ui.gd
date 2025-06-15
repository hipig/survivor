extends CanvasLayer
class_name UpgradeUI

const UPGRADE_CARD = preload("res://scenes/ui/upgrade/upgrade_card.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var card_container: HBoxContainer = $MarginContainer/CardContainer

func _ready() -> void:
	hide()
	Events.upgrades_generated.connect(_on_upgrades_generated)

func open() -> void:
	get_tree().paused = true
	show()
	animation_player.play("in")
	

func close() -> void:
	get_tree().paused = false
	hide()
	animation_player.play("out")
	
func set_ability_upgrades(upgrades : Array[Upgrade], equipped_upgrades: Dictionary) -> void:
	for child in card_container.get_children():
		child.queue_free()
	
	for upgrade in upgrades:
		var upgrade_card: UpgradeCard = UPGRADE_CARD.instantiate()
		card_container.add_child(upgrade_card)
		upgrade_card.set_ability_upgrade(upgrade, equipped_upgrades.get(upgrade.id, {}))
		upgrade_card.play_in()
		upgrade_card.selected.connect(on_upgrade_selected.bind(upgrade))

func _on_upgrades_generated(upgrades : Array[Upgrade], equipped_upgrades: Dictionary):
	if upgrades.size() == 0:
		return
	
	set_ability_upgrades(upgrades, equipped_upgrades)
	open()

func on_upgrade_selected(upgrade: Upgrade) -> void:
	Events.emit_upgrade_selected(upgrade)
	close()
