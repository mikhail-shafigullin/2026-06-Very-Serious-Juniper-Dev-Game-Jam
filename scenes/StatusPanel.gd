extends Control

@onready var armorColumn: Control = %ArmorColumn;
@onready var armorLabel: Control = %ArmorLabel;
@onready var slotDamageColumn: Control = %SlotDamageColumn;
@onready var slotDamageTexture: TextureRect = %SlotDamageTexture;
@onready var slotDamageLabel: Label = %SlotDamageLabel;
@onready var slotAmountColumn: Control = %SlotAmountColumn;
@onready var slotAmountTexture: TextureRect = %SlotAmountTexture;
@onready var slotAmountLabel: Label = %SlotAmountLabel;

func _ready() -> void:
	clear();
	EventBus.player_effect_updated.connect(_playerEffectUpdated)
	pass;

func _playerEffectUpdated(effectStr: String, slotType: SlotObject.SlotType, strValue: String):
	if(effectStr == "Armor"):
		armorColumn.show();
		armorLabel.text = strValue;
	elif(effectStr == "SymbolBonus"):
		slotDamageColumn.show();
		updateTextureFromSlot(slotDamageTexture, slotType)
		slotDamageLabel.text = "+" + str(strValue) + "dmg"
		pass;
	elif(effectStr == "SymbolAdd"):
		slotAmountColumn.show()
		updateTextureFromSlot(slotAmountTexture, slotType)
		slotAmountLabel.text = "+" + str(strValue) + "slot"
		pass;
	pass;

func clear() -> void:
	armorColumn.hide();
	slotDamageColumn.hide();
	slotAmountColumn.hide();

const SLOT_TEXTURES = {
	SlotObject.SlotType.STAR: preload("res://assets/props/zvezda.png"),
	SlotObject.SlotType.SEVEN: preload("res://assets/props/semerka.png"),
	SlotObject.SlotType.STRAWBERRY: preload("res://assets/props/klubnika.png"),
	SlotObject.SlotType.CHEST: preload("res://assets/props/sunduk.png"),
	SlotObject.SlotType.CHERRY: preload("res://assets/props/vishnya.png"),
	SlotObject.SlotType.CROSS: preload("res://assets/props/krestik.png"),
}

func updateTextureFromSlot(target: TextureRect, slotType: SlotObject.SlotType) -> void:
	target.texture = SLOT_TEXTURES[slotType]
