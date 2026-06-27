class_name EnemyStrengthAction
extends EnemyAction

var amount: int

func _init(_amount: int) -> void:
	amount = _amount
	strValue = "+" + str(amount) + " STRENGTH"

func execute(enemy: EnemyObject, _player: PlayerController) -> int:
	enemy.strengthBonus += amount
	return 0
