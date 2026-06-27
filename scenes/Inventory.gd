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
	skipTurnButton.pressed.connect(_onSkipTurnPressed)

	EventBus.battle_started.connect(refresh)
	EventBus.battle_finished.connect(disableAllButtons)
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
	skipTurnButton.disabled = false;
	clearDescription();

func disableAllButtons():
	slotHead.disabled = true;
	slotLeftHand.disabled = true;
	slotRightHand.disabled = true;
	slotBody.disabled = true;
	slotLegs.disabled = true;
	skipTurnButton.disabled = true;

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

var _lastHoveredSlot: InventorySlot = null

func _process(_delta: float) -> void:
	var mousePos := get_local_mouse_position()
	var hovered := _getHoveredSlot(mousePos)
	if hovered == _lastHoveredSlot:
		return
	_lastHoveredSlot = hovered
	if hovered != null and hovered.item != null:
		writeDescription(hovered)
	else:
		clearDescription()

func _getHoveredSlot(mousePos: Vector2) -> InventorySlot:
	var inv := Global.gameCycle.player.inventory
	if slotHead.visible and slotHead.get_rect().has_point(mousePos):
		return inv.head
	if slotLeftHand.visible and slotLeftHand.get_rect().has_point(mousePos):
		return inv.leftHand
	if slotRightHand.visible and slotRightHand.get_rect().has_point(mousePos):
		return inv.rightHand
	if slotBody.visible and slotBody.get_rect().has_point(mousePos):
		return inv.body
	if slotLegs.visible and slotLegs.get_rect().has_point(mousePos):
		return inv.legs
	return null
