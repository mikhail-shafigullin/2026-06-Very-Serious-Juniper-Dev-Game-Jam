extends Control

# --- LeftPanel buttons ---
@onready var location1Button: Button = %location1Button
@onready var location2Button: Button = %location2Button
@onready var location3Button: Button = %location3Button
@onready var battle1Button: Button = %battle1Button
@onready var battle2Button: Button = %battle2Button
@onready var battle3Button: Button = %battle3Button
@onready var reward1Button: Button = %reward1Button
@onready var reward2Button: Button = %reward2Button
@onready var gameOverButton: Button = %gameOverButton

@onready var battleScreen: Control = %BattleScreen

# --- BattleScreen: Player ---
@onready var playerHPLabel: Label = %HPLabel
@onready var leftHandUseButton: Button = %LeftHandUseButton
@onready var rightHandUseButton: Button = %RightHandUseButton
@onready var bodyUseButton: Button = %BodyUseButton
@onready var headUseButton: Button = %HeadUseButton
@onready var playerTopSlot1: Label = %PlayerTopSlot1
@onready var playerTopSlot2: Label = %PlayerTopSlot2
@onready var playerTopSlot3: Label = %PlayerTopSlot3
@onready var playerMiddleSlot1: Label = %PlayerMiddleSlot1
@onready var playerMiddleSlot2: Label = %PlayerMiddleSlot2
@onready var playerMiddleSlot3: Label = %PlayerMiddleSlot3
@onready var playerBottomSlot1: Label = %PlayerBottomSlot1
@onready var playerBottomSlot2: Label = %PlayerBottomSlot2
@onready var playerBottomSlot3: Label = %PlayerBottomSlot3
@onready var playerFinalAmount: Label = %PlayerFinalAmount

# --- BattleScreen: Enemy ---
@onready var enemyHPLabel: Label = %EnemyHPLabel
@onready var enemyTopSlot1: Label = %EnemyTopSlot1
@onready var enemyTopSlot2: Label = %EnemyTopSlot2
@onready var enemyTopSlot3: Label = %EnemyTopSlot3
@onready var enemyMiddleSlot1: Label = %EnemyMiddleSlot1
@onready var enemyMiddleSlot2: Label = %EnemyMiddleSlot2
@onready var enemyMiddleSlot3: Label = %EnemyMiddleSlot3
@onready var enemyBottomSlot1: Label = %EnemyBottomSlot1
@onready var enemyBottomSlot2: Label = %EnemyBottomSlot2
@onready var enemyBottomSlot3: Label = %EnemyBottomSlot3
@onready var enemyFinalAmount: Label = %EnemyFinalAmount

# --- ClaimReward ---
@onready var rewardItem1Label: Label = %RewardItem1Label
@onready var rewardItem2Label: Label = %RewardItem2Label
@onready var rewardItem3Label: Label = %RewardItem3Label
@onready var takeItem1Button: Button = %TakeItem1Button
@onready var takeItem2Button: Button = %TakeItem2Button
@onready var takeItem3Button: Button = %TakeItem3Button

func _ready() -> void:
	Global.gameCycle.initGame()
	_connectButtons()
	_connectSignals()

func _connectButtons() -> void:
	location1Button.pressed.connect(_initLocation)
	location2Button.pressed.connect(_initLocation)
	location3Button.pressed.connect(_initLocation)
	battle1Button.pressed.connect(_onBattleButtonPressed)
	battle2Button.pressed.connect(_onBattleButtonPressed)
	battle3Button.pressed.connect(_onBattleButtonPressed)
	reward1Button.pressed.connect(func() -> void: Global.gameCycle.claimRewards(0))
	reward2Button.pressed.connect(func() -> void: Global.gameCycle.claimRewards(1))
	gameOverButton.pressed.connect(Global.gameCycle.showGameOver)
	takeItem1Button.pressed.connect(func() -> void: Global.gameCycle.claimRewards(0))
	takeItem2Button.pressed.connect(func() -> void: Global.gameCycle.claimRewards(1))
	takeItem3Button.pressed.connect(func() -> void: Global.gameCycle.claimRewards(2))
	leftHandUseButton.pressed.connect(_onUseLeftHand)
	rightHandUseButton.pressed.connect(_onUseRightHand)
	bodyUseButton.pressed.connect(_onUseBody)
	headUseButton.pressed.connect(_onUseHead)

func _connectSignals() -> void:
	EventBus.player_hp_changed.connect(_onPlayerHpChanged)
	EventBus.enemy_hp_changed.connect(_onEnemyHpChanged)
	EventBus.player_slot_spun.connect(_onPlayerSlotSpun)
	EventBus.enemy_slot_spun.connect(_onEnemySlotSpun)
	EventBus.player_turn_result.connect(_onPlayerTurnResult)
	EventBus.enemy_turn_result.connect(_onEnemyTurnResult)
	EventBus.rewards_available.connect(_onRewardsAvailable)
	EventBus.battle_started.connect(_onBattleStarted)
	EventBus.battle_finished.connect(_onBattleFinished)
	EventBus.player_turn_started.connect(_onPlayerTurnStarted)
	EventBus.enemy_turn_started.connect(_onEnemyTurnStarted)

func _setUseButtonsDisabled(disabled: bool) -> void:
	leftHandUseButton.disabled = disabled
	rightHandUseButton.disabled = disabled
	bodyUseButton.disabled = disabled
	headUseButton.disabled = disabled

func _useSlotItem(item: ItemObject) -> void:
	Global.gameCycle.battle.usePlayerItem(item)
	Global.gameCycle.battle.finishPlayerTurn()

func _onUseLeftHand() -> void:
	var item := Global.gameCycle.player.inventory.leftHand.item
	if item != null:
		_useSlotItem(item)

func _onUseRightHand() -> void:
	var item := Global.gameCycle.player.inventory.rightHand.item
	if item != null:
		_useSlotItem(item)

func _onUseBody() -> void:
	var item := Global.gameCycle.player.inventory.body.item
	if item != null:
		_useSlotItem(item)

func _onUseHead() -> void:
	var item := Global.gameCycle.player.inventory.head.item
	if item != null:
		_useSlotItem(item)

func _initLocation() -> void:
	Global.gameCycle.initLocation()

func _onBattleButtonPressed() -> void:
	Global.gameCycle.initBattle()
	Global.gameCycle.startBattle()

func _onPlayerHpChanged(current_hp: int, max_hp: int) -> void:
	playerHPLabel.text = "HP: %d / %d" % [current_hp, max_hp]

func _onEnemyHpChanged(current_hp: int, max_hp: int) -> void:
	enemyHPLabel.text = "HP: %d / %d" % [current_hp, max_hp]

func _onPlayerSlotSpun(result: SlotMachineResult) -> void:
	var labels := [
		playerTopSlot1, playerTopSlot2, playerTopSlot3,
		playerMiddleSlot1, playerMiddleSlot2, playerMiddleSlot3,
		playerBottomSlot1, playerBottomSlot2, playerBottomSlot3,
	]
	_fillSlotLabels(labels, result)

func _onEnemySlotSpun(result: SlotMachineResult) -> void:
	var labels := [
		enemyTopSlot1, enemyTopSlot2, enemyTopSlot3,
		enemyMiddleSlot1, enemyMiddleSlot2, enemyMiddleSlot3,
		enemyBottomSlot1, enemyBottomSlot2, enemyBottomSlot3,
	]
	_fillSlotLabels(labels, result)

func _fillSlotLabels(labels: Array, result: SlotMachineResult) -> void:
	var i := 0
	for row in range(SlotMachineController.ROWS):
		for col in range(result.grid.size()):
			if i < labels.size():
				labels[i].text = SlotObject.SlotType.keys()[result.grid[col][row].type]
				i += 1

func _onPlayerTurnResult(total: int) -> void:
	playerFinalAmount.text = str(total)

func _onEnemyTurnResult(total: int) -> void:
	enemyFinalAmount.text = str(total)

func _onRewardsAvailable(items: Array) -> void:
	var labels := [rewardItem1Label, rewardItem2Label, rewardItem3Label]
	for i: int in labels.size():
		labels[i].text = items[i].name if i < items.size() else ""

func _onBattleStarted() -> void:
	battleScreen.show()

func _onBattleFinished() -> void:
	battleScreen.hide()

func _onPlayerTurnStarted() -> void:
	_setUseButtonsDisabled(false)

func _onEnemyTurnStarted() -> void:
	_setUseButtonsDisabled(true)
