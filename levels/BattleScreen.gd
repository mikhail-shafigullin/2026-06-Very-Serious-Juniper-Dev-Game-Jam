extends Node2D

@onready var location1BG: Sprite2D = %Fon1
@onready var location2BG: Sprite2D = %Fon2
@onready var location3BG: Sprite2D = %Fon3
@onready var location4BG: Sprite2D = %Fon4
@onready var blackFadeIn: ColorRect = %BlackFadeIn;

func _ready() -> void:
	EventBus.location_started.connect(locationChange)

func locationChange(location: LocationObject) -> void:
	var tween := create_tween()
	tween.tween_property(blackFadeIn, "modulate:a", 1.0, 0.5)
	await tween.finished
	_showBackground(location.type)
	tween = create_tween()
	tween.tween_property(blackFadeIn, "modulate:a", 0.0, 0.5)
	await tween.finished

func _showBackground(type: LocationObject.LocationType) -> void:
	location1BG.visible = false
	location2BG.visible = false
	location3BG.visible = false
	location4BG.visible = false
	match type:
		LocationObject.LocationType.DUNGEON:
			location1BG.visible = true
		LocationObject.LocationType.LOST_TEMPLE:
			location2BG.visible = true
		LocationObject.LocationType.ASCENTION:
			location3BG.visible = true
		LocationObject.LocationType.ALTAR:
			location4BG.visible = true