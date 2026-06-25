class_name SlotMachine
extends Node2D

const SLOT_SCENE = preload("res://scenes/slots/slotMachineSlot.tscn")

@onready var slotMachineBox: Node2D = %SlotMachineBox
@onready var rollEffectSprite: Sprite2D = %RollEffect
@onready var column1: VBoxContainer = %Column1
@onready var column2: VBoxContainer = %Column2
@onready var column3: VBoxContainer = %Column3

var shakeTween: Tween
var shakeOriginalPos: Vector2

func _ready() -> void:
	shakeOriginalPos = slotMachineBox.position
	EventBus.player_weapon_chosen.connect(_on_player_weapon_chosen)

func setController(controller: SlotMachineController) -> void:
	var vboxColumns := [column1, column2, column3]
	for vbox: VBoxContainer in vboxColumns:
		for child in vbox.get_children():
			child.queue_free()

	for i in min(controller.columns.size(), vboxColumns.size()):
		var vbox: VBoxContainer = vboxColumns[i]
		for slot: SlotObject in controller.columns[i].possibleSlots:
			var slotNode: SlotMachineSlot = SLOT_SCENE.instantiate()
			vbox.add_child(slotNode)
			slotNode.setSlotType(slot.type)

func _on_player_weapon_chosen(slot: InventorySlot) -> void:
	if slot.item != null:
		setController(SlotMachineController.fromItem(slot.item))

func _startShake() -> void:
	if shakeTween:
		shakeTween.kill()
	shakeTween = create_tween().set_loops()
	shakeTween.tween_property(slotMachineBox, "position", shakeOriginalPos + Vector2(2, 1), 0.04)
	shakeTween.tween_property(slotMachineBox, "position", shakeOriginalPos + Vector2(-2, -1), 0.04)
	shakeTween.tween_property(slotMachineBox, "position", shakeOriginalPos + Vector2(1, -2), 0.04)
	shakeTween.tween_property(slotMachineBox, "position", shakeOriginalPos + Vector2(-1, 2), 0.04)

func _stopShake() -> void:
	if shakeTween:
		shakeTween.kill()
		shakeTween = null
	slotMachineBox.position = shakeOriginalPos

func rollTriggered() -> void:
	rollEffectSprite.show()

func _on_handle_roll_triggered() -> void:
	_stopShake()
	rollTriggered()
	if Global.gameCycle.battle != null:
		Global.gameCycle.battle.usePlayerItem()

func _on_handle_handle_left_bottom() -> void:
	_stopShake()

func _on_handle_handle_fully_pulled() -> void:
	_startShake()
