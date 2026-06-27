class_name GodEnemy

static func create() -> EnemyObject:
	var actions: Array[EnemyAction] = [
		EnemyStrengthAction.new(5),
		EnemyDamageAction.new(10),
		EnemyPlayerDebuffAction.new(30),
		EnemyDamageAction.new(20),
	]
	return EnemyObject.new("God", 100, actions)
