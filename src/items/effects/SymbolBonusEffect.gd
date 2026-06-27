class_name SymbolBonusEffect
extends ItemEffect

var targetType: SlotObject.SlotType
var bonusPerSymbol: int = 0
var multiply: float;
var additionalPoints: int;

func _init(type: SlotObject.SlotType, _multiply: float, _additionalPoints: int) -> void:
	targetType = type
	multiply = _multiply;
	additionalPoints = _additionalPoints;
	bonusPerSymbol = additionalPoints;


func apply(result: SlotMachineResult, currentValue: int) -> int:
	bonusPerSymbol += result.getCombinations().size() * multiply

	var symbolCount := 0
	for column: Array in result.grid:
		for slot: SlotObject in column:
			if slot.type == targetType:
				symbolCount += 1

	return currentValue + symbolCount * bonusPerSymbol

func reset() -> void:
	bonusPerSymbol = additionalPoints
