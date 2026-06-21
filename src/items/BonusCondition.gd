class_name BonusCondition
extends ItemEffect

var symbol: SlotObject.SlotType
var minimumCount: int
var multiplier: float

func apply(result: SlotMachineResult, currentValue: int) -> int:
	if isTriggered(result):
		return int(currentValue * multiplier)
	return currentValue

func isTriggered(result: SlotMachineResult) -> bool:
	var count := 0
	for column: Array in result.grid:
		for slot: SlotObject in column:
			if slot.type == symbol:
				count += 1
	return count >= minimumCount
