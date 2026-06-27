class_name RewardController
extends Node

var rewards: Array[ItemObject] = []

func generateRewards(location: LocationObject) -> void:
	rewards.clear()
	for i in range(3):
		rewards.append(_createItemForLocation(location.type))

func _createItemForLocation(locationType: LocationObject.LocationType) -> ItemObject:
	var symbol := _randomSymbol()
	var pool: Array[Callable] = _poolForLocation(locationType, symbol)
	var creator: Callable = pool[randi() % pool.size()]
	return creator.call()

func _randomSymbol() -> SlotObject.SlotType:
	var allSymbols: Array = SlotObject.SlotType.values()
	return allSymbols[randi() % allSymbols.size()]

func _poolForLocation(locationType: LocationObject.LocationType, symbol: SlotObject.SlotType) -> Array[Callable]:
	match locationType:
		LocationObject.LocationType.DUNGEON:
			return [
				func() -> ItemObject: return SimpleHandWeapon.create(),
				func() -> ItemObject: return SymbolArmor.create(symbol),
			]
		LocationObject.LocationType.LOST_TEMPLE:
			return [
				func() -> ItemObject: return SimpleHandWeapon.create(),
				func() -> ItemObject: return SymbolArmor.create(symbol),
				func() -> ItemObject: return SymbolHelmet.create(symbol),
			]
		LocationObject.LocationType.ASCENTION:
			return [
				func() -> ItemObject: return SimpleHandWeapon.create(),
				func() -> ItemObject: return SymbolArmor.create(symbol),
				func() -> ItemObject: return SymbolHelmet.create(symbol),
				func() -> ItemObject: return SymbolLegs.create(symbol),
			]
		_:
			return [
				func() -> ItemObject: return SimpleHandWeapon.create(),
				func() -> ItemObject: return SymbolArmor.create(symbol),
				func() -> ItemObject: return SymbolHelmet.create(symbol),
				func() -> ItemObject: return SymbolLegs.create(symbol),
			]
