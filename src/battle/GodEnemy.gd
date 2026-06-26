class_name GodEnemy

static func create() -> EnemyObject:
	var weapon := ItemObject.new()
	weapon.itemName = "Claws"
	weapon.slotType = InventorySlot.InventorySlotType.HAND

	var allTypes: Array = SlotObject.SlotType.values()
	for i in range(3):
		var column := SlotMachineColumn.new()
		for slotType in allTypes:
			var slot := SlotObject.new()
			slot.type = slotType
			column.possibleSlots.append(slot)
		weapon.columns.append(column)

	return EnemyObject.new("God", 1000, weapon)
