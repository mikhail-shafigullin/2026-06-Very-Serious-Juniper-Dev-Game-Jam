class_name SlotMachineController
extends Node

const ROWS = 3

var columns: Array[SlotMachineColumn]
var activeEffects: Array[ItemEffect] = []

static func fromItem(mainItem: ItemObject, extraEffects: Array[ItemEffect] = []) -> SlotMachineController:
	var c := SlotMachineController.new()
	for col: SlotMachineColumn in mainItem.columns:
		var copy := SlotMachineColumn.new()
		copy.possibleSlots = col.possibleSlots.duplicate()
		c.columns.append(copy)
	c.activeEffects = mainItem.effects.duplicate()
	c.activeEffects.append_array(extraEffects)
	for effect: ItemEffect in c.activeEffects:
		effect.prepareController(c)
	return c

func spin() -> SlotMachineResult:
	var result := SlotMachineResult.new()
	result.controller = self
	for column: SlotMachineColumn in columns:
		var index := randi() % column.possibleSlots.size()
		var columnResult := column.getSlotsAround(index)
		result.grid.append(columnResult)
	return result

func calculateEffect(result: SlotMachineResult) -> int:
	var value := 0
	for column: Array in result.grid:
		for slot: SlotObject in column:
			if slot.type != SlotObject.SlotType.CROSS:
				value += 1

	for combo: SlotMachineCombination in result.getCombinations():
		value = int(value * combo.getMultiplier())

	for effect: ItemEffect in activeEffects:
		value = effect.apply(result, value)

	return value
