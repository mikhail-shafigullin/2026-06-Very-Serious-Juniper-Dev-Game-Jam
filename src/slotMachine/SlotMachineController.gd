class_name SlotMachineController
extends Node

const ROWS = 3

var columns: Array[SlotMachineColumn]
var activeEffects: Array[ItemEffect] = []

static func fromItem(mainItem: ItemObject, extraEffects: Array[ItemEffect] = []) -> SlotMachineController:
	var c := SlotMachineController.new()
	c.columns = mainItem.columns.duplicate()
	c.activeEffects = mainItem.effects.duplicate()
	c.activeEffects.append_array(extraEffects)
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
			value += 1

	for combo: SlotMachineCombination in result.getCombinations():
		value = int(value * combo.getMultiplier())

	for effect: ItemEffect in activeEffects:
		value = effect.apply(result, value)

	return value
