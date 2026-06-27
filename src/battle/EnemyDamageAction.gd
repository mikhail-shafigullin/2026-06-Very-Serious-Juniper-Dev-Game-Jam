class_name EnemyDamageAction
extends EnemyAction

var damage: int

func _init(_damage: int) -> void:
	damage = _damage

func execute(enemy: EnemyObject, _player: PlayerController) -> int:
	return damage + enemy.strengthBonus
