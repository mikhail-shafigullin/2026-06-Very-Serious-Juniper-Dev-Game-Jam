class_name Inventory
extends Control

@onready var slotHead: Button = %InventorySlotHead
@onready var slotLeftHand: Button = %InventorySlotLeftHand
@onready var slotRightHand: Button = %InventorySlotRightHand
@onready var slotBody: Button = %InventorySlotBody
@onready var slotLegs: Button = %InventorySlotLegs

func _ready() -> void:
	slotHead.pressed.connect(func() -> void: _onSlotSelected(Global.gameCycle.player.inventory.head))
	slotLeftHand.pressed.connect(func() -> void: _onSlotSelected(Global.gameCycle.player.inventory.leftHand))
	slotRightHand.pressed.connect(func() -> void: _onSlotSelected(Global.gameCycle.player.inventory.rightHand))
	slotBody.pressed.connect(func() -> void: _onSlotSelected(Global.gameCycle.player.inventory.body))
	slotLegs.pressed.connect(func() -> void: _onSlotSelected(Global.gameCycle.player.inventory.legs))

	EventBus.battle_started.connect(refresh)
	EventBus.player_turn_started.connect(refresh)

	refresh()

func refresh() -> void:
	var inv := Global.gameCycle.player.inventory
	_refreshSlot(slotHead, inv.head)
	_refreshSlot(slotLeftHand, inv.leftHand)
	_refreshSlot(slotRightHand, inv.rightHand)
	_refreshSlot(slotBody, inv.body)
	_refreshSlot(slotLegs, inv.legs)

func _refreshSlot(button: Button, slot: InventorySlot) -> void:
	if slot.item == null:
		button.visible = false
		return
	button.visible = true
	button.disabled = slot.isOnCooldown()

func _onSlotSelected(slot: InventorySlot) -> void:
	if Global.gameCycle.battle == null:
		return
	Global.gameCycle.battle.chooseWeapon(slot)
