class_name GoblinEnemy

static func create() -> EnemyObject:
	var actions: Array[EnemyAction] = [
		EnemyDamageAction.new(3),
		EnemyStrengthAction.new(2),
		EnemyDamageAction.new(7),
	]
	return EnemyObject.new("Goblin", 100, actions)
