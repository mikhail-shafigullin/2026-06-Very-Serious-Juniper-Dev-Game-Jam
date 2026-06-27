class_name SymbolHelmet

static func create(targetType: SlotObject.SlotType, rarity: ItemObject.ItemRarity) -> ItemObject:
	var item := ItemObject.new()
	var typeName: String = SlotObject.SlotType.keys()[int(targetType)].capitalize()
	item.slotType = InventorySlot.InventorySlotType.HEAD
	item.cooldown = 2
	
	if(rarity == ItemObject.ItemRarity.COMMON):
		item.itemName = typeName + " Helmet"
		item.itemDescription = "Each combination increases damage from all " + typeName.to_lower() + "s"
		item.icon = load("res://assets/props/shlem_common.png")
		item.effects.append(SymbolBonusEffect.new(targetType, 1, 1))
	elif(rarity == ItemObject.ItemRarity.RARE):
		item.itemName = typeName + " Helmet"
		item.itemDescription = "Each combination increases damage from all " + typeName.to_lower() + "s"
		item.icon = load("res://assets/props/shlem_rare.png")
		item.effects.append(SymbolBonusEffect.new(targetType, 1, 2))
	elif(rarity == ItemObject.ItemRarity.EPIC):
		item.itemName = typeName + " Helmet"
		item.itemDescription = "Each combination increases damage from all " + typeName.to_lower() + "s"
		item.icon = load("res://assets/props/shlem_epic.png")
		item.effects.append(SymbolBonusEffect.new(targetType, 1, 3))

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
