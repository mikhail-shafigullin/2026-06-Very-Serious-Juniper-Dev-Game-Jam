class_name SlotMachineController
extends Node

const ROWS = 3

var columns: Array[SlotMachineColumn]

func spin() -> SlotMachineResult:
	var result := SlotMachineResult.new()
	for column: SlotMachineColumn in columns:
		var index := randi() % column.possibleSlots.size();
		var columnResult := column.getSlotsAround(index);
		result.grid.append(columnResult);
	return result;
