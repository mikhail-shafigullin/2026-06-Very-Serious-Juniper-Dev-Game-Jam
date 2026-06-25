class_name SlotMachineSlot
extends Control

@export var slotType: SlotObject.SlotType = SlotObject.SlotType.BLANK

@onready var cherry: TextureRect = %Cherry
@onready var chest: TextureRect = %Chest
@onready var star: TextureRect = %Star
@onready var seven: TextureRect = %Seven
@onready var strawberry: TextureRect = %Strawberry
@onready var cross: TextureRect = %Cross

func _ready() -> void:
	setSlotType(slotType)

func setSlotType(type: SlotObject.SlotType) -> void:
	slotType = type
	cherry.visible = type == SlotObject.SlotType.CHERRY
	chest.visible = type == SlotObject.SlotType.CHEST
	star.visible = type == SlotObject.SlotType.STAR
	seven.visible = type == SlotObject.SlotType.SEVEN
	strawberry.visible = type == SlotObject.SlotType.STRAWBERRY
	cross.visible = type == SlotObject.SlotType.CROSS
