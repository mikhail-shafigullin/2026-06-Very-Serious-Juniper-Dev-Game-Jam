class_name ItemEffect
extends Resource

func apply(result: SlotMachineResult, currentValue: int) -> int:
	return currentValue

func prepareController(_controller: SlotMachineController) -> void:
	pass

func reset() -> void:
	pass
