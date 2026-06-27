class_name EnemyPlayerDebuffAction
extends EnemyAction

var hpReduction: int

func _init(_amount: int) -> void:
	hpReduction = _amount
	strValue = "-" + str(hpReduction) + "MaxHP"

func execute(_enemy: EnemyObject, player: PlayerController) -> int:
	player.maxHp -= hpReduction
	player.currentHp = min(player.currentHp, player.maxHp)
	return 0
