class_name EnemyObject
extends Resource

var enemyName: String
var maxHp: int
var currentHp: int
var weapon: ItemObject

func _init(_name: String, _hp: int, _weapon: ItemObject) -> void:
	enemyName = _name
	maxHp = _hp
	currentHp = _hp
	weapon = _weapon

func takeDamage(amount: int) -> void:
	currentHp -= amount

func isAlive() -> bool:
	return currentHp > 0

func buildController() -> SlotMachineController:
	return SlotMachineController.fromItem(weapon)
