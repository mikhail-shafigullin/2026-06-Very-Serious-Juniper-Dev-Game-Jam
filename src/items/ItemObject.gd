class_name ItemObject
extends Resource

var itemName: String
var itemDescription: String;
var slotType: InventorySlot.InventorySlotType
var columns: Array[SlotMachineColumn]
var effects: Array[ItemEffect]
var cooldown: int = 0
