class_name SimpleHandWeapon

static func create(rarity: ItemObject.ItemRarity) -> ItemObject:
	var item := ItemObject.new()
	item.itemName = "Dagger"
	item.slotType = InventorySlot.InventorySlotType.HAND
	item.cooldown = 1

	if(rarity == ItemObject.ItemRarity.COMMON):
		item.itemDescription = "Absolutely common dagger"
		item.icon = load("res://assets/props/sword_common.png")
		item.effects.append(WeaponDamageEffect.new(0))
	elif(rarity == ItemObject.ItemRarity.RARE):
		item.itemDescription = "Absolutely common dagger"
		item.icon = load("res://assets/props/sword_rare.png")
		item.effects.append(WeaponDamageEffect.new(0.5))
	elif(rarity == ItemObject.ItemRarity.EPIC):
		item.itemDescription = "Absolutely common dagger"
		item.icon = load("res://assets/props/sword_epic.png")
		item.effects.append(WeaponDamageEffect.new(1.5))

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
