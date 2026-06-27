class_name SymbolColumnFillEffect
extends ItemEffect

const BASE_COUNT = 3
var targetType: SlotObject.SlotType
var extraSymbols: int = BASE_COUNT

func _init(type: SlotObject.SlotType, _extraSymbols: int) -> void:
	targetType = type
	extraSymbols = _extraSymbols;

func prepareController(controller: SlotMachineController) -> void:
	for column: SlotMachineColumn in controller.columns:
		for i in range(extraSymbols):
			var slot := SlotObject.new()
			slot.type = targetType
			column.possibleSlots.append(slot)

func apply(result: SlotMachineResult, currentValue: int) -> int:
	extraSymbols += result.getCombinations().size()
	return currentValue

func reset() -> void:
	extraSymbols = BASE_COUNT
