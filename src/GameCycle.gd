class_name GameCycle
extends Node

var player: PlayerController;
var battle: BattleCycle;
var locationFactory: LocationFactory
var currentLocation: LocationObject

func _init() -> void:
	pass;

func _ready() -> void:
	Global.gameCycle = self;
	locationFactory = LocationFactory.new()
	pass;

func initGame() -> void:
	player = PlayerController.new();

func initLocation() -> void:
	player.inventory.leftHand.item = SimpleHandWeapon.create()

func startLocation() -> void:
	currentLocation = locationFactory.next();
	EventBus.location_started.emit(currentLocation);

func initBattle() -> void:
	battle = BattleCycle.new()
	var event := BattleEvent.new()
	event.enemy = currentLocation.enemy
	battle.currentBattle = event

func startBattle() -> void:
	battle.startBattle()
	EventBus.battle_started.emit()

func finishBattle() -> void:
	EventBus.battle_finished.emit()

func finishLocation() -> void:
	EventBus.location_finished.emit();

func showResults() -> void:
	pass;

func claimRewards(_item_index: int) -> void:
	pass;

func showGameOver() -> void:
	pass;

