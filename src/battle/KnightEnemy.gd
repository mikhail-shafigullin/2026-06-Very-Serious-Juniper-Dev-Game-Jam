class_name KnightEnemy

static func create() -> EnemyObject:
	var actions: Array[EnemyAction] = [
		EnemyDamageAction.new(10),
		EnemyAction.new(),
		EnemyDamageAction.new(15),
	]
	return EnemyObject.new("Knight", 100, actions)
