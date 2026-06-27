class_name SimpleHandWeapon

static func create() -> ItemObject:
	var item := ItemObject.new()
	item.itemName = "Dagger"
	item.itemDescription = "Absolutely common dagger"
	item.slotType = InventorySlot.InventorySlotType.HAND
	item.cooldown = 1;

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
