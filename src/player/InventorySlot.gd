class_name InventorySlot
extends Node

enum InventorySlotType {HEAD, BODY, LEFT_HAND, RIGHT_HAND}

var type: InventorySlotType;

func _init(_type: InventorySlotType) -> void:
	type = _type;