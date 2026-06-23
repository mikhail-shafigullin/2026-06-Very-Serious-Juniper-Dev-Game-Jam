class_name InventorySlot
extends Node

enum InventorySlotType {HEAD, BODY, HAND, LEGS}

var type: InventorySlotType
var item: ItemObject = null
var currentCooldown: int = 0

func _init(_type: InventorySlotType) -> void:
	type = _type

func isOnCooldown() -> bool:
	return currentCooldown > 0

func applyCooldown() -> void:
	if item != null:
		currentCooldown = item.cooldown

func tickCooldown() -> void:
	if currentCooldown > 0:
		currentCooldown -= 1