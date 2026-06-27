class_name SymbolArmor

static func create(targetType: SlotObject.SlotType) -> ItemObject:
	var item := ItemObject.new()
	var typeName: String = SlotObject.SlotType.keys()[int(targetType)].capitalize()
	item.itemName = typeName + " Shield"
	item.itemDescription = typeName + "s generate armor. All combinations multiply it"
	item.slotType = InventorySlot.InventorySlotType.BODY
	item.cooldown = 1
	item.effects.append(SymbolArmorEffect.new(targetType))

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
