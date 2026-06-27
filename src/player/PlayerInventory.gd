class_name PlayerInventory
extends Node;

var head: InventorySlot;
var body: InventorySlot;
var leftHand: InventorySlot;
var rightHand: InventorySlot;
var legs: InventorySlot;

func _init() -> void:
	head = InventorySlot.new(InventorySlot.InventorySlotType.HEAD)
	body = InventorySlot.new(InventorySlot.InventorySlotType.BODY)
	leftHand = InventorySlot.new(InventorySlot.InventorySlotType.HAND)
	rightHand = InventorySlot.new(InventorySlot.InventorySlotType.HAND)
	legs = InventorySlot.new(InventorySlot.InventorySlotType.LEGS)

func tickAllCooldowns() -> void:
	for slot: InventorySlot in [head, body, leftHand, rightHand, legs]:
		slot.tickCooldown()

func slotForItem(item: ItemObject) -> InventorySlot:
	match item.slotType:
		InventorySlot.InventorySlotType.HEAD:
			return head
		InventorySlot.InventorySlotType.BODY:
			return body
		InventorySlot.InventorySlotType.LEGS:
			return legs
		InventorySlot.InventorySlotType.HAND:
			if leftHand.item == null:
				return leftHand
			return rightHand
	return rightHand

func refresh():
	if(head): head.currentCooldown = 0;
	if(body): body.currentCooldown = 0;
	if(leftHand): leftHand.currentCooldown = 0;
	if(rightHand): rightHand.currentCooldown = 0;
	if(legs): legs.currentCooldown = 0;