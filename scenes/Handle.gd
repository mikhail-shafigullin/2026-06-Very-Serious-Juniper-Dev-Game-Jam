class_name Handle
extends Node2D

const THRESHOLD_2 = 30.0
const THRESHOLD_3 = 70.0
const THRESHOLD_4 = 120.0
const STEP_INTERVAL = 0.06
const RETURN_STEP_INTERVAL = 0.03

@onready var ruchka1: Sprite2D = %Ruchka1
@onready var ruchka2: Sprite2D = %Ruchka2
@onready var ruchka3: Sprite2D = %Ruchka3
@onready var ruchka4: Sprite2D = %Ruchka4
@onready var area2d: Area2D = %Area2D
@onready var stepTimer: Timer = %StepTimer

signal roll_triggered()
signal handle_fully_pulled()
signal handle_left_bottom()

var isRollPossible: bool = false

var currentState: int = 1
var targetState: int = 1
var isDragging: bool = false
var isReturning: bool = false
var reachedBottom: bool = false
var dragStartY: float = 0.0

func _ready() -> void:
	area2d.input_event.connect(_onAreaInputEvent)
	stepTimer.timeout.connect(_onStepTimer)

func _onAreaInputEvent(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			isDragging = true
			isReturning = false
			reachedBottom = false
			dragStartY = get_global_mouse_position().y
			stepTimer.wait_time = STEP_INTERVAL
			stepTimer.start()

func _input(event: InputEvent) -> void:
	if not isDragging:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_startReturn()
	elif event is InputEventMouseMotion:
		var delta := get_global_mouse_position().y - dragStartY
		var newTarget := _computeTargetState(delta)
		if newTarget != targetState:
			targetState = newTarget
			if stepTimer.is_stopped():
				stepTimer.wait_time = STEP_INTERVAL
				stepTimer.start()

func _computeTargetState(delta: float) -> int:
	if delta < THRESHOLD_2:
		return 1
	if not isRollPossible:
		return 2
	if delta < THRESHOLD_3:
		return 2
	elif delta < THRESHOLD_4:
		return 3
	else:
		return 4

func _startReturn() -> void:
	if reachedBottom and isRollPossible:
		roll_triggered.emit()
	reachedBottom = false
	isDragging = false
	isReturning = true
	targetState = 1
	if currentState == 1:
		isReturning = false
		stepTimer.stop()
		return
	stepTimer.wait_time = RETURN_STEP_INTERVAL
	if stepTimer.is_stopped():
		stepTimer.start()

func _onStepTimer() -> void:
	if currentState < targetState:
		currentState += 1
		if currentState == 4 and isDragging:
			reachedBottom = true
			handle_fully_pulled.emit()
	elif currentState > targetState:
		currentState -= 1
		if currentState < 4 and isDragging:
			reachedBottom = false
			handle_left_bottom.emit()
	_updateVisuals()
	if currentState == targetState:
		stepTimer.stop()
		if isReturning:
			isReturning = false

func _updateVisuals() -> void:
	ruchka1.visible = currentState == 1
	ruchka2.visible = currentState == 2
	ruchka3.visible = currentState == 3
	ruchka4.visible = currentState == 4
