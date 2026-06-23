class_name InventorySlot
extends Node

enum InventorySlotType {HEAD, BODY, HAND}

var type: InventorySlotType
var item: ItemObject = null

func _init(_type: InventorySlotType) -> void:
	type = _type;