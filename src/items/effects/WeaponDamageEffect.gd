class_name WeaponDamageEffect
extends ItemEffect

func apply(result: SlotMachineResult, currentValue: int) -> int:
	var count := 0
	for column: Array in result.grid:
		for slot: SlotObject in column:
			count += 1
	return currentValue + count
