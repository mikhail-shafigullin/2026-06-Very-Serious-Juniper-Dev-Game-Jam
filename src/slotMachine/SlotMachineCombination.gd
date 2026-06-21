class_name SlotMachineCombination
extends Resource

enum CombinationType{ C3, C5, C6, C7, C8, C9 }

var type: CombinationType
var slots: Array[SlotObject]
var symbol: SlotObject.SlotType

func getMultiplier() -> float:
	match type:
		CombinationType.C3: return 3.0
		CombinationType.C5: return 5.0
		CombinationType.C6: return 6.0
		CombinationType.C7: return 7.0
		CombinationType.C8: return 8.0
		CombinationType.C9: return 100.0
	return 1.0
