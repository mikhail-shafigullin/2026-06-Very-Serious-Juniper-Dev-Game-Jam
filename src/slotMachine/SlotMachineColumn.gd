class_name SlotMachineColumn
extends Node;

var possibleSlots: Array[SlotObject];

func getSlotsAround(index) -> Array[SlotObject]:
	var firstSlot = possibleSlots[index-1] if index-1 >= 0 else possibleSlots[possibleSlots.size() - 1];
	var secondSlot = possibleSlots[index];
	var thirdSlot = possibleSlots[index+1] if index+1 < possibleSlots.size() else possibleSlots[0];

	return [firstSlot, secondSlot, thirdSlot];
