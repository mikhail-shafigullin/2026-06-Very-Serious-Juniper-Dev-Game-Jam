class_name SymbolArmorEffect
extends ItemEffect

var targetType: SlotObject.SlotType
var multiply: float;

func _init(type: SlotObject.SlotType, _multiply: float) -> void:
	targetType = type;
	multiply = _multiply;

func apply(result: SlotMachineResult, _currentValue: int) -> int:
	var symbolCount := 0
	for column: Array in result.grid:
		for slot: SlotObject in column:
			if slot.type == targetType:
				symbolCount += 1 * multiply
	var armor = int(symbolCount * result.getTotalMultiplier())
	EventBus.player_effect_updated.emit("Armor", SlotObject.SlotType.CHERRY, str(armor))
	return armor;
