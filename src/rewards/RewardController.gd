class_name RewardController
extends Node

var rewards: Array[ItemObject] = []

func generateRewards(location: LocationObject) -> void:
	rewards.clear()
	for i in range(3):
		rewards.append(_createItemForLocation(location.type))

func _createItemForLocation(locationType: LocationObject.LocationType) -> ItemObject:
	var symbol := _randomSymbol()
	var rarity := _randomRarity(locationType)
	match _randomSlotType():
		InventorySlot.InventorySlotType.HAND:
			return SimpleHandWeapon.create(rarity)
		InventorySlot.InventorySlotType.BODY:
			return SymbolArmor.create(symbol, rarity)
		InventorySlot.InventorySlotType.HEAD:
			return SymbolHelmet.create(symbol, rarity)
		_:
			return SymbolLegs.create(symbol, rarity)

func _randomSlotType() -> InventorySlot.InventorySlotType:
	var roll := randi() % 100
	if roll < 20:
		return InventorySlot.InventorySlotType.HAND
	elif roll < 50:
		return InventorySlot.InventorySlotType.BODY
	elif roll < 80:
		return InventorySlot.InventorySlotType.HEAD
	else:
		return InventorySlot.InventorySlotType.LEGS

func _randomRarity(locationType: LocationObject.LocationType) -> ItemObject.ItemRarity:
	var roll := randi() % 100
	match locationType:
		LocationObject.LocationType.DUNGEON:
			return ItemObject.ItemRarity.RARE if roll < 20 else ItemObject.ItemRarity.COMMON
		LocationObject.LocationType.LOST_TEMPLE:
			if roll < 30:
				return ItemObject.ItemRarity.COMMON
			elif roll < 80:
				return ItemObject.ItemRarity.RARE
			else:
				return ItemObject.ItemRarity.EPIC
		_:
			if roll < 10:
				return ItemObject.ItemRarity.COMMON
			elif roll < 40:
				return ItemObject.ItemRarity.RARE
			else:
				return ItemObject.ItemRarity.EPIC

func _randomSymbol() -> SlotObject.SlotType:
	var validSymbols: Array[SlotObject.SlotType] = [
		SlotObject.SlotType.STAR,
		SlotObject.SlotType.SEVEN,
		SlotObject.SlotType.STRAWBERRY,
		SlotObject.SlotType.CHEST,
		SlotObject.SlotType.CHERRY,
	]
	return validSymbols[randi() % validSymbols.size()]
