class_name GameCycle
extends Node

var player: PlayerController;
var battle: BattleCycle;

func _init() -> void:
	pass;

func _ready() -> void:
	Global.gameCycle = self;
	pass;

func initGame() -> void:
	player = PlayerController.new();

func initLocation() -> void:
	pass;

func startLocation() -> void:
	EventBus.location_started.emit();

func initBattle() -> void:
	battle = BattleCycle.new();
	pass;

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

