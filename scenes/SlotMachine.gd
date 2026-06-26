class_name SlotMachine
extends Node2D

const SLOT_SCENE = preload("res://scenes/slots/slotMachineSlot.tscn")
const SLOT_HEIGHT = 53
const SPIN_SLOT_COUNT = 30

@onready var handle: Handle = %Handle
@onready var slotMachineBox: Node2D = %SlotMachineBox
@onready var rollEffectSprite: Sprite2D = %RollEffect
@onready var column1: VBoxContainer = %Column1
@onready var column2: VBoxContainer = %Column2
@onready var column3: VBoxContainer = %Column3
@onready var scoreLabel: Label = %ScoreLabel;

var shakeTween: Tween
var rollTween: Tween
var shakeOriginalPos: Vector2
var currentSlot: InventorySlot = null
var pendingSpinResult: SlotMachineResult = null

func _ready() -> void:
	shakeOriginalPos = slotMachineBox.position
	EventBus.player_weapon_chosen.connect(_on_player_weapon_chosen)
	EventBus.player_slot_spun.connect(_on_player_slot_spun)
	EventBus.player_turn_result.connect(_on_player_turn_result)
	EventBus.player_turn_started.connect(_on_player_turn_started)

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

func _updateIsRollPossible() -> void:
	handle.isRollPossible = currentSlot != null and currentSlot.item != null and not currentSlot.isOnCooldown()

func _on_player_turn_started() -> void:
	currentSlot = null
	_updateIsRollPossible()
	scoreLabel.text = str(0);
	scoreLabel.hide();

func _on_player_weapon_chosen(slot: InventorySlot) -> void:
	scoreLabel.text = str(0);
	scoreLabel.hide();
	currentSlot = slot
	if slot != null and slot.item != null:
		setController(SlotMachineController.fromItem(slot.item))
	_updateIsRollPossible()

func _on_player_slot_spun(result: SlotMachineResult) -> void:
	var vboxColumns := [column1, column2, column3]
	if rollTween:
		rollTween.kill()

	for i in min(result.grid.size(), vboxColumns.size()):
		var vbox: VBoxContainer = vboxColumns[i]
		var possibleSlots: Array = result.controller.columns[i].possibleSlots

		for child in vbox.get_children():
			child.queue_free()

		for j in SPIN_SLOT_COUNT:
			var slotNode: SlotMachineSlot = SLOT_SCENE.instantiate()
			vbox.add_child(slotNode)
			slotNode.setSlotType(possibleSlots[randi() % possibleSlots.size()].type)

		for slot: SlotObject in result.grid[i]:
			var slotNode: SlotMachineSlot = SLOT_SCENE.instantiate()
			vbox.add_child(slotNode)
			slotNode.setSlotType(slot.type)

		vbox.position.y = 0

	# Wait one frame so VBoxContainer finishes layout and child positions are accurate
	await get_tree().process_frame
	await get_tree().process_frame

	rollTween = create_tween().set_parallel()
	for i in vboxColumns.size():
		var firstResultChild: Control = vboxColumns[i].get_child(SPIN_SLOT_COUNT)
		var targetY: float = -firstResultChild.position.y
		rollTween.tween_property(vboxColumns[i], "position:y", targetY, 1.0)\
			.set_delay(i * 0.1)\
			.set_ease(Tween.EASE_OUT)\
			.set_trans(Tween.TRANS_QUAD)

	var totalDuration: float = 1.0 + (vboxColumns.size() - 1) * 0.1
	rollTween.tween_property(rollEffectSprite, "modulate:a", 0.0, totalDuration * 0.5)\
		.set_delay(totalDuration * 0.5)

	rollTween.chain().tween_callback(func():
		rollEffectSprite.hide()
		scoreLabel.show();
		_updateIsRollPossible()
	)

func _on_player_turn_result(total: int):
	scoreLabel.text = str(total);
	pass;

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
	rollEffectSprite.modulate = Color.WHITE
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
