class_name ItemObject
extends Resource

enum ItemRarity{COMMON, RARE, EPIC}

var itemName: String
var itemDescription: String;
var slotType: InventorySlot.InventorySlotType
var columns: Array[SlotMachineColumn]
var effects: Array[ItemEffect]
var cooldown: int = 0
var icon: Texture2D
