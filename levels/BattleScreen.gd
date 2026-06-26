extends Node2D

@onready var location1BG: Sprite2D = %Fon1
@onready var location2BG: Sprite2D = %Fon2
@onready var location3BG: Sprite2D = %Fon3
@onready var location4BG: Sprite2D = %Fon4
@onready var blackFadeIn: ColorRect = %BlackFadeIn;
@onready var nextLocationButton: Button = %NextLocationButton;
@onready var playerHealthProgressBar: TextureProgressBar = %PlayerHealthProgressBar;
@onready var playerHealthLabel: Label = %PlayerHealthLabel;

func _ready() -> void:
	nextLocationButton.hide();
	EventBus.location_started.connect(locationChange)
	EventBus.battle_finished.connect(_battle_finished)
	EventBus.player_hp_changed.connect(_onPlayerHpChanged)
	Global.gameCycle.initGame();
	Global.gameCycle.initLocation();
	Global.gameCycle.startLocation();
	_initPlayerHealthBar()

func locationChange(location: LocationObject) -> void:
	nextLocationButton.modulate.a = 0.0
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

func _battle_finished() -> void:
	await get_tree().create_timer(3.5).timeout
	nextLocationButton.modulate.a = 0.0
	nextLocationButton.show()
	var tween := create_tween()
	tween.tween_property(nextLocationButton, "modulate:a", 1.0, 0.5)


func _initPlayerHealthBar() -> void:
	var player := Global.gameCycle.player
	playerHealthProgressBar.max_value = player.maxHp
	playerHealthProgressBar.value = player.currentHp
	playerHealthLabel.text = "%d/%d" % [player.currentHp, player.maxHp]

func _onPlayerHpChanged(currentHp: int, maxHp: int) -> void:
	playerHealthProgressBar.max_value = maxHp
	playerHealthProgressBar.value = currentHp
	playerHealthLabel.text = "%d/%d" % [currentHp, maxHp]

func _on_next_location_button_pressed() -> void:
	Global.gameCycle.startLocation()
