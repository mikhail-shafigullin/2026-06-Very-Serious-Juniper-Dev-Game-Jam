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

func initBattle() -> void:
	battle = BattleCycle.new();
	pass;

func startBattle() -> void:
	battle.startBattle();
	pass;

func finishBattle() -> void:
	pass;

func showResults() -> void:
	pass;

func claimRewards() -> void:
	pass;

func showGameOver() -> void:
	pass;

