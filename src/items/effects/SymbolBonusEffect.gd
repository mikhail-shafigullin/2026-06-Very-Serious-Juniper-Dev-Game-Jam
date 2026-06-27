class_name SymbolBonusEffect
extends ItemEffect

var targetType: SlotObject.SlotType
var bonusPerSymbol: int = 0

func _init(type: SlotObject.SlotType) -> void:
	targetType = type

func apply(result: SlotMachineResult, currentValue: int) -> int:
	bonusPerSymbol += result.getCombinations().size()

	var symbolCount := 0
	for column: Array in result.grid:
		for slot: SlotObject in column:
			if slot.type == targetType:
				symbolCount += 1

	return currentValue + symbolCount * bonusPerSymbol

func reset() -> void:
	bonusPerSymbol = 0
