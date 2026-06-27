class_name SymbolArmorEffect
extends ItemEffect

var targetType: SlotObject.SlotType

func _init(type: SlotObject.SlotType) -> void:
	targetType = type

func apply(result: SlotMachineResult, _currentValue: int) -> int:
	var symbolCount := 0
	for column: Array in result.grid:
		for slot: SlotObject in column:
			if slot.type == targetType:
				symbolCount += 1
	return int(symbolCount * result.getTotalMultiplier())
