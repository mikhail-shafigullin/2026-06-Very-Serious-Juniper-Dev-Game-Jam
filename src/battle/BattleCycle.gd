class_name BattleCycle
extends Node

enum TurnState { IDLE, PLAYER_TURN, ENEMY_TURN }

var currentBattle: BattleEvent
var turnState: TurnState = TurnState.IDLE
var playerTurnDamage: int = 0
var enemyTurnDamage: int = 0

func startBattle() -> void:
	var player := Global.gameCycle.player
	EventBus.player_hp_changed.emit(player.currentHp, player.maxHp)
	EventBus.enemy_hp_changed.emit(currentBattle.enemy.currentHp, currentBattle.enemy.maxHp)
	playerTurn()

func playerTurn() -> void:
	turnState = TurnState.PLAYER_TURN
	playerTurnDamage = 0
	EventBus.player_turn_started.emit()

func usePlayerItem(slot: InventorySlot) -> void:
	if turnState != TurnState.PLAYER_TURN:
		return
	if slot.isOnCooldown():
		return
	var controller := SlotMachineController.fromItem(slot.item)
	var result := controller.spin()
	var damage := controller.calculateEffect(result)
	playerTurnDamage += damage
	slot.applyCooldown()
	EventBus.player_slot_spun.emit(result)
	EventBus.player_turn_result.emit(playerTurnDamage)

func finishPlayerTurn() -> void:
	currentBattle.enemy.takeDamage(playerTurnDamage)
	EventBus.enemy_hp_changed.emit(currentBattle.enemy.currentHp, currentBattle.enemy.maxHp)
	if not currentBattle.enemy.isAlive():
		finishBattle()
	else:
		enemyTurn()

func enemyTurn() -> void:
	turnState = TurnState.ENEMY_TURN
	EventBus.enemy_turn_started.emit()
	var controller := currentBattle.enemy.buildController()
	var result := controller.spin()
	enemyTurnDamage = controller.calculateEffect(result)
	EventBus.enemy_slot_spun.emit(result)
	EventBus.enemy_turn_result.emit(enemyTurnDamage)
	finishEnemyTurn()

func finishEnemyTurn() -> void:
	var player := Global.gameCycle.player
	player.takeDamage(enemyTurnDamage)
	EventBus.player_hp_changed.emit(player.currentHp, player.maxHp)
	if player.currentHp <= 0:
		finishBattle()
	else:
		player.inventory.tickAllCooldowns()
		playerTurn()

func finishBattle() -> void:
	turnState = TurnState.IDLE
	Global.gameCycle.finishBattle()
