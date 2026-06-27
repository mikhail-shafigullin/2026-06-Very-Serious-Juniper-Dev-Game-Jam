class_name SymbolLegs

static func create(targetType: SlotObject.SlotType, rarity: ItemObject.ItemRarity) -> ItemObject:
	var item := ItemObject.new()
	var typeName: String = SlotObject.SlotType.keys()[int(targetType)].capitalize()
	item.slotType = InventorySlot.InventorySlotType.LEGS
	item.cooldown = 3

	if(rarity == ItemObject.ItemRarity.COMMON):
		item.itemName = typeName + " Boots"
		item.itemDescription = "Adds " + typeName.to_lower() + "s to weapons. Each combination adds more"
		item.icon = load("res://assets/props/boots_common.png")
		item.effects.append(SymbolColumnFillEffect.new(targetType, 1))
	elif(rarity == ItemObject.ItemRarity.RARE):
		item.itemName = typeName + " Boots"
		item.itemDescription = "Adds " + typeName.to_lower() + "s to weapons. Each combination adds more"
		item.icon = load("res://assets/props/boots_rare.png")
		item.effects.append(SymbolColumnFillEffect.new(targetType, 3))
	elif(rarity == ItemObject.ItemRarity.EPIC):
		item.itemName = typeName + " Boots"
		item.itemDescription = "Adds " + typeName.to_lower() + "s to weapons. Each combination adds more"
		item.icon = load("res://assets/props/boots_epic.png")
		item.effects.append(SymbolColumnFillEffect.new(targetType, 5))


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
