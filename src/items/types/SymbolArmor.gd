class_name SymbolArmor

static func create(targetType: SlotObject.SlotType, rarity: ItemObject.ItemRarity) -> ItemObject:
	var item := ItemObject.new()
	var typeName: String = SlotObject.SlotType.keys()[int(targetType)].capitalize()
	item.slotType = InventorySlot.InventorySlotType.BODY
	item.cooldown = 3

	if(rarity == ItemObject.ItemRarity.COMMON):
		item.itemName = typeName + " Armor"
		item.itemDescription = typeName + "s generate armor. All combinations multiply it"
		item.icon = load("res://assets/props/dospeh_common.png")
		item.effects.append(SymbolArmorEffect.new(targetType, 1))
	elif(rarity == ItemObject.ItemRarity.RARE):
		item.itemName = typeName + " Armor"
		item.itemDescription = typeName + "s generate armor. All combinations multiply it"
		item.icon = load("res://assets/props/dospeh_rare.png")
		item.effects.append(SymbolArmorEffect.new(targetType, 1.5))
	elif(rarity == ItemObject.ItemRarity.EPIC):
		item.itemName = typeName + " Armor"
		item.itemDescription = typeName + "s generate armor. All combinations multiply it"
		item.icon = load("res://assets/props/dospeh_epic.png")
		item.effects.append(SymbolArmorEffect.new(targetType, 2.5))

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
