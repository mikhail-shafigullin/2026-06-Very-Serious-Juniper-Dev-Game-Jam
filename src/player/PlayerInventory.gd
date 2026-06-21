class_name PlayerInventory
extends Node;

var head: InventorySlot;
var body: InventorySlot;
var leftHand: InventorySlot;
var rightHand: InventorySlot;

func _init() -> void:
	head = InventorySlot.new(InventorySlot.InventorySlotType.HEAD)
	body = InventorySlot.new(InventorySlot.InventorySlotType.BODY)
	leftHand = InventorySlot.new(InventorySlot.InventorySlotType.LEFT_HAND)
	rightHand = InventorySlot.new(InventorySlot.InventorySlotType.RIGHT_HAND)
	