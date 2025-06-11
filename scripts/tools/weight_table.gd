extends Node
class_name WeightTable

var items: Array[Dictionary] = []
var weight_sum: int = 0

func add_item(item: Variant, weight: int) -> void:
	items.append({
		"item": item,
		"weight": weight
	})
	weight_sum += weight

func remove_item(removed_item: Variant) -> void:
	items = items.filter(func (item: Variant) -> bool: return item["item"] != removed_item)
	weight_sum = 0
	for item in items:
		weight_sum += item["weight"]

func random_item(exclude: Array = []) -> Variant:
	var adjusted_items: Array[Dictionary] = items
	var adjusted_weight_sum: int = weight_sum
	if exclude.size() > 0:
		adjusted_items = []
		adjusted_weight_sum = 0
		for item in items:
			if item["item"] in exclude:
				continue
			adjusted_items.append(item)
			adjusted_weight_sum += item["weight"]
	
	var chosen_weight: int = randi_range(1, adjusted_weight_sum)
	var iteration_sum: int = 0
	for item in adjusted_items:
		iteration_sum += item["weight"]
		if chosen_weight <= iteration_sum:
			return item["item"]
	return null
	
func change_weight(changed_item: Variant, weight: int) -> void:
	remove_item(changed_item)
	add_item(changed_item, weight)
