class_name WomanEnemy

static func create() -> EnemyObject:
	var actions: Array[EnemyAction] = [
		EnemyPlayerDebuffAction.new(20),
		EnemyDamageAction.new(5),
		EnemyDamageAction.new(5),
	]
	return EnemyObject.new("Woman", 100, actions)
