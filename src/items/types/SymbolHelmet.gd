class_name SymbolHelmet

static func create(targetType: SlotObject.SlotType) -> ItemObject:
	var item := ItemObject.new()
	var typeName: String = SlotObject.SlotType.keys()[int(targetType)].capitalize()
	item.itemName = typeName + " Crown"
	item.itemDescription = "Each combination increases damage from all " + typeName.to_lower() + "s"
	item.slotType = InventorySlot.InventorySlotType.HEAD
	item.cooldown = 2
	item.effects.append(SymbolBonusEffect.new(targetType))

	var allTypes: Array = SlotObject.SlotType.values()
	for i in range(3):
		var column := SlotMachineColumn.new()
		for j in range(3):
			for slotType in allTypes:
				var slot := SlotObject.new()
				slot.type = slotType
				column.possibleSlots.append(slot)
		item.columns.append(column)
		column.possibleSlots.shuffle()

	return item
