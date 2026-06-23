class_name SlotMachineResult
extends Node

var grid: Array[Array] = []
var combinations: Array[SlotMachineCombination] = []

func getCombinations() -> Array[SlotMachineCombination]:
	combinations.clear()

	var lines: Array = [
		[[0,0],[1,0],[2,0]],
		[[0,1],[1,1],[2,1]],
		[[0,2],[1,2],[2,2]],
		[[0,0],[0,1],[0,2]],
		[[1,0],[1,1],[1,2]],
		[[2,0],[2,1],[2,2]],
		[[0,0],[1,1],[2,2]],
		[[2,0],[1,1],[0,2]],
	]

	for slotType in SlotObject.SlotType.values():
		# collect only slots that belong to at least one valid line of 3
		var matchedByPos: Dictionary = {}
		for line in lines:
			var lineSlots: Array[SlotObject] = []
			var allMatch := true
			for coords in line:
				var slot := grid[coords[0]][coords[1]] as SlotObject
				if slot.type != slotType:
					allMatch = false
					break
				lineSlots.append(slot)
			if allMatch:
				for i in range(line.size()):
					var key := str(line[i][0]) + "," + str(line[i][1])
					matchedByPos[key] = lineSlots[i]

		var count := matchedByPos.size()
		if count == 0:
			continue

		var matchedSlots: Array[SlotObject] = []
		for slot: SlotObject in matchedByPos.values():
			matchedSlots.append(slot)

		var combo := SlotMachineCombination.new()
		combo.slots = matchedSlots

		if count >= 9:
			combo.type = SlotMachineCombination.CombinationType.C9
		elif count >= 8:
			combo.type = SlotMachineCombination.CombinationType.C8
		elif count >= 7:
			combo.type = SlotMachineCombination.CombinationType.C7
		elif count >= 6:
			combo.type = SlotMachineCombination.CombinationType.C6
		elif count >= 5:
			combo.type = SlotMachineCombination.CombinationType.C5
		else:
			combo.type = SlotMachineCombination.CombinationType.C3

		combinations.append(combo)

	return combinations

func getTotalMultiplier() -> float:
	var total := 1.0
	for combo: SlotMachineCombination in getCombinations():
		if combo.slots[0].type != SlotObject.SlotType.BLANK:
			total *= combo.getMultiplier()
	return total