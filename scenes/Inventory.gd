class_name Inventory
extends Control

@onready var slotHead: Button = %InventorySlotHead
@onready var slotLeftHand: Button = %InventorySlotLeftHand
@onready var slotRightHand: Button = %InventorySlotRightHand
@onready var slotBody: Button = %InventorySlotBody
@onready var slotLegs: Button = %InventorySlotLegs
@onready var skipTurnButton: Button = %SkipTurnButton;
@onready var weaponNameLabel: Label = %WeaponNameLabel;
@onready var weaponNameDescription: Label = %WeaponNameDescription;
@onready var weaponNameCurrentBonusValue: Label = %WeaponNameCurrentBonusValue;

func _ready() -> void:
	slotHead.toggled.connect(func(toggled_on: bool) -> void: _onSlotToggled(toggled_on, Global.gameCycle.player.inventory.head))
	slotLeftHand.toggled.connect(func(toggled_on: bool) -> void: _onSlotToggled(toggled_on, Global.gameCycle.player.inventory.leftHand))
	slotRightHand.toggled.connect(func(toggled_on: bool) -> void: _onSlotToggled(toggled_on, Global.gameCycle.player.inventory.rightHand))
	slotBody.toggled.connect(func(toggled_on: bool) -> void: _onSlotToggled(toggled_on, Global.gameCycle.player.inventory.body))
	slotLegs.toggled.connect(func(toggled_on: bool) -> void: _onSlotToggled(toggled_on, Global.gameCycle.player.inventory.legs))
	skipTurnButton.pressed.connect(_onSkipTurnPressed);

	EventBus.battle_started.connect(refresh)
	EventBus.player_turn_started.connect(refresh)
	EventBus.player_slot_spun.connect(disableUsedWeapon)

	refresh()

func refresh() -> void:
	var inv := Global.gameCycle.player.inventory
	_refreshSlot(slotHead, inv.head)
	_refreshSlot(slotLeftHand, inv.leftHand)
	_refreshSlot(slotRightHand, inv.rightHand)
	_refreshSlot(slotBody, inv.body)
	_refreshSlot(slotLegs, inv.legs)
	clearDescription();

func _refreshSlot(button: Button, slot: InventorySlot) -> void:
	if slot.item == null:
		button.visible = false
		return
	button.visible = true
	button.disabled = slot.isOnCooldown()
	button.button_pressed = false
	button.icon = slot.item.icon
	skipTurnButton.disabled = false

func _onSlotToggled(toggled_on: bool, slot: InventorySlot) -> void:
	if Global.gameCycle.battle == null:
		return
	if toggled_on:
		Global.gameCycle.battle.chooseWeapon(slot)
		writeDescription(slot)
	else:
		Global.gameCycle.battle.unchooseWeapon(slot)
		clearDescription()

func _onSkipTurnPressed():
	skipTurnButton.disabled = true;
	Global.gameCycle.battle.finishPlayerTurn()
	pass;

func writeDescription(slot: InventorySlot):
	weaponNameLabel.text = slot.item.itemName;
	weaponNameDescription.text = slot.item.itemDescription;
	pass;

func clearDescription():
	weaponNameLabel.text = "";
	weaponNameDescription.text = "";
	pass;

func disableUsedWeapon(_ignore):
	refresh()
	pass;
