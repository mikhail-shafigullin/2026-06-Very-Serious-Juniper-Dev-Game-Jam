class_name SymbolLegs

static func create(targetType: SlotObject.SlotType) -> ItemObject:
	var item := ItemObject.new()
	var typeName: String = SlotObject.SlotType.keys()[int(targetType)].capitalize()
	item.itemName = typeName + " Boots"
	item.itemDescription = "Adds " + typeName.to_lower() + "s to weapons. Each combination adds more"
	item.slotType = InventorySlot.InventorySlotType.LEGS
	item.cooldown = 2
	item.effects.append(SymbolColumnFillEffect.new(targetType))

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
