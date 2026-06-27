class_name SimpleEnemy

static func create() -> EnemyObject:
	var actions: Array[EnemyAction] = [
		EnemyDamageAction.new(5),
		EnemyDamageAction.new(8),
		EnemyDamageAction.new(10),
	]
	return EnemyObject.new("Wolf", 100, actions)
