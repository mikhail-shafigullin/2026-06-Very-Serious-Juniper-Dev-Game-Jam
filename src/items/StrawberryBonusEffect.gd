class_name StrawberryBonusEffect
extends ItemEffect

var bonusPerStrawberry: int = 0

func apply(result: SlotMachineResult, currentValue: int) -> int:
	var combinationCount := result.getCombinations().size()
	bonusPerStrawberry += combinationCount

	var strawberryCount := 0
	for column: Array in result.grid:
		for slot: SlotObject in column:
			if slot.type == SlotObject.SlotType.STRAWBERRY:
				strawberryCount += 1

	return currentValue + strawberryCount * bonusPerStrawberry

func reset() -> void:
	bonusPerStrawberry = 0
