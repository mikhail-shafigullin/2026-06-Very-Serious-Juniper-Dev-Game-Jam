class_name StrawberryHelmet

static func create() -> ItemObject:
	var item := ItemObject.new()
	item.itemName = "Berry Crown"
	item.itemDescription = "Each combination increases damage from all strawberries"
	item.slotType = InventorySlot.InventorySlotType.HEAD
	item.cooldown = 2
	item.effects.append(StrawberryBonusEffect.new())

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
