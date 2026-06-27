class_name LocationFactory
extends Node

var locations: Array[LocationObject];
var nextIndex = 0;

func _init():
	locations = [
		LocationObject.new(LocationObject.LocationType.DUNGEON, SimpleEnemy.create()),
		LocationObject.new(LocationObject.LocationType.DUNGEON, SkeletonEnemy.create()),
		LocationObject.new(LocationObject.LocationType.LOST_TEMPLE, GoblinEnemy.create()),
		LocationObject.new(LocationObject.LocationType.LOST_TEMPLE, WomanEnemy.create()),
		LocationObject.new(LocationObject.LocationType.ASCENTION, KnightEnemy.create()),
		LocationObject.new(LocationObject.LocationType.ALTAR, GodEnemy.create()),
	]

func next() -> LocationObject:
	if(nextIndex >= locations.size()):
		return null;
	var nextLocation = locations[nextIndex];
	nextIndex+=1;
	return nextLocation
