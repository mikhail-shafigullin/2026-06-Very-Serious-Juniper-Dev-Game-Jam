class_name BattleCycle
extends Node

enum TurnState { IDLE, PLAYER_TURN, ENEMY_TURN }

var currentBattle: BattleEvent
var turnState: TurnState = TurnState.IDLE
var playerTurnDamage: int = 0
var enemyTurnDamage: int = 0
var chosenSlot: InventorySlot = null

func startBattle() -> void:
	var player := Global.gameCycle.player
	for slot: InventorySlot in [player.inventory.head, player.inventory.body, player.inventory.leftHand, player.inventory.rightHand, player.inventory.legs]:
		if slot.item != null:
			for effect: ItemEffect in slot.item.effects:
				effect.reset()
	EventBus.player_hp_changed.emit(player.currentHp, player.maxHp)
	EventBus.enemy_hp_changed.emit(currentBattle.enemy.currentHp, currentBattle.enemy.maxHp)
	playerTurn()

func playerTurn() -> void:
	turnState = TurnState.PLAYER_TURN
	playerTurnDamage = 0
	chosenSlot = null
	EventBus.player_turn_started.emit()

func chooseWeapon(slot: InventorySlot) -> void:
	if turnState != TurnState.PLAYER_TURN:
		return
	chosenSlot = slot
	EventBus.player_weapon_chosen.emit(slot)

func unchooseWeapon(_slot: InventorySlot) -> void:
	if turnState != TurnState.PLAYER_TURN:
		return
	chosenSlot = null
	EventBus.player_weapon_chosen.emit(null)

func usePlayerItem() -> void:
	if turnState != TurnState.PLAYER_TURN:
		return
	if chosenSlot == null:
		return
	if chosenSlot.isOnCooldown():
		return
	var slot := chosenSlot
	chosenSlot = null
	var player := Global.gameCycle.player
	var extraEffects: Array[ItemEffect] = []
	for passiveSlot: InventorySlot in [player.inventory.head, player.inventory.body, player.inventory.legs]:
		if passiveSlot.item != null and passiveSlot != slot:
			extraEffects.append_array(passiveSlot.item.effects)
	var controller := SlotMachineController.fromItem(slot.item, extraEffects)
	var result := controller.spin()
	var damage := controller.calculateEffect(result)
	slot.applyCooldown()
	EventBus.player_slot_spun.emit(result)
	EventBus.player_turn_result.emit(damage)
	if slot.type == InventorySlot.InventorySlotType.HAND:
		playerTurnDamage += damage
		currentBattle.enemy.takeDamage(playerTurnDamage)
		EventBus.enemy_hp_changed.emit(currentBattle.enemy.currentHp, currentBattle.enemy.maxHp)
		if not currentBattle.enemy.isAlive():
			finishBattle()

func finishPlayerTurn() -> void:
	enemyTurn()

func enemyTurn() -> void:
	turnState = TurnState.ENEMY_TURN
	EventBus.enemy_turn_started.emit()
	var player := Global.gameCycle.player
	var action := currentBattle.enemy.getNextAction()
	enemyTurnDamage = action.execute(currentBattle.enemy, player)
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
