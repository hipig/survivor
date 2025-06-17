extends CanvasLayer
class_name InventoryUI

const INVENTORY_SLOT = preload("res://scenes/ui/hud/inventory/inventory_slot.tscn")

@onready var grid_container: GridContainer = $MarginContainer/GridContainer

func _ready() -> void:
	Events.ability_controller_added.connect(_on_ability_controller_added)
	
func _on_ability_controller_added(ability_controller: AbilityController):
	var inventory_slot: InventorySlot = INVENTORY_SLOT.instantiate()
	inventory_slot.icon = ability_controller.icon
	grid_container.add_child(inventory_slot)
