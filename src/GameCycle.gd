class_name GameCycle
extends Node

var player: PlayerController;
var battle: BattleCycle;
var locationFactory: LocationFactory
var currentLocation: LocationObject
var rewardController: RewardController

func _init() -> void:
	pass;

func _ready() -> void:
	Global.gameCycle = self;
	locationFactory = LocationFactory.new()
	rewardController = RewardController.new()
	pass;

func initGame() -> void:
	player = PlayerController.new();

func initLocation() -> void:
	player.inventory.leftHand.item = SimpleHandWeapon.create();
	player.inventory.rightHand.item = SimpleHandWeapon.create();
	player.inventory.head.item = SymbolHelmet.create(SlotObject.SlotType.STRAWBERRY)
	player.inventory.legs.item = SymbolLegs.create(SlotObject.SlotType.STRAWBERRY)
	player.inventory.body.item = SymbolArmor.create(SlotObject.SlotType.STRAWBERRY)

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
	player.inventory.refresh();
	EventBus.battle_finished.emit()

func finishLocation() -> void:
	rewardController.rewards.clear()
	EventBus.location_finished.emit();

func showResults() -> void:
	rewardController.generateRewards(currentLocation)
	EventBus.rewards_available.emit(rewardController.rewards)

func claimRewards(itemIndex: int) -> void:
	var item: ItemObject = rewardController.rewards[itemIndex]
	var slot: InventorySlot = player.inventory.slotForItem(item)
	slot.item = item
	rewardController.rewards.clear()

func showGameOver() -> void:
	pass;

