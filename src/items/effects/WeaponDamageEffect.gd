class_name WeaponDamageEffect
extends ItemEffect

var multiply = 0;

func _init(_multiply: float) -> void:
	multiply = _multiply;

func apply(result: SlotMachineResult, currentValue: int) -> int:
	var count := 0
	for column: Array in result.grid:
		for slot: SlotObject in column:
			count += 1 * multiply
	return currentValue + count
