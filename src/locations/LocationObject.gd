class_name LocationObject
extends Resource

enum LocationType{ DUNGEON, LOST_TEMPLE, ASCENTION, ALTAR}
var type: LocationType;
var enemy: EnemyObject;

func _init(_type: LocationType, _enemy: EnemyObject) -> void:
	type = _type;
	enemy = _enemy;