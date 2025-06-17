extends PanelContainer
class_name InventorySlot

@export var icon: Texture2D

@onready var texture_rect: TextureRect = $TextureRect

func _ready() -> void:
	texture_rect.texture = icon
