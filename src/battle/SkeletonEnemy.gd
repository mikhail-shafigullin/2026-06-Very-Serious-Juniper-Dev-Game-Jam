class_name SkeletonEnemy

static func create() -> EnemyObject:
	var actions: Array[EnemyAction] = [
		EnemyDamageAction.new(10),
		EnemyDamageAction.new(12),
		EnemyDamageAction.new(15),
	]
	return EnemyObject.new("Skeleton", 100, actions)
