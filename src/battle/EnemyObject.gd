class_name EnemyObject
extends Resource

var enemyName: String
var maxHp: int
var currentHp: int
var actions: Array[EnemyAction]
var currentActionIndex: int = 0
var strengthBonus: int = 0

func _init(_name: String, _hp: int, _actions: Array[EnemyAction]) -> void:
	enemyName = _name
	maxHp = _hp
	currentHp = _hp
	actions = _actions

func takeDamage(amount: int) -> void:
	currentHp -= amount

func isAlive() -> bool:
	return currentHp > 0

func getNextAction() -> EnemyAction:
	var action := actions[currentActionIndex]
	currentActionIndex = (currentActionIndex + 1) % actions.size()
	return action
