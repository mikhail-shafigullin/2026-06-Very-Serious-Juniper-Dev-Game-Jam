class_name RewardPanel
extends Control

var selectedIndex: int = -1
var currentItems: Array = []

@onready var reward1: Button = %Reward1
@onready var reward2: Button = %Reward2
@onready var reward3: Button = %Reward3
@onready var takeItButton: Button = %TakeItButton
@onready var ignoreButton: Button = %IgnoreButton
@onready var itemNameLabel: Label = %ItemNameLabel
@onready var itemDescriptionLabel: Label = %ItemDescriptionLabel

func _ready() -> void:
	visible = false
	takeItButton.disabled = true
	reward1.toggled.connect(func(on: bool) -> void: _onRewardToggled(on, 0))
	reward2.toggled.connect(func(on: bool) -> void: _onRewardToggled(on, 1))
	reward3.toggled.connect(func(on: bool) -> void: _onRewardToggled(on, 2))
	takeItButton.pressed.connect(_onTakeIt)
	ignoreButton.pressed.connect(_onIgnore)
	EventBus.rewards_available.connect(_onRewardsAvailable)

func _onRewardsAvailable(items: Array) -> void:
	currentItems = items
	selectedIndex = -1
	takeItButton.disabled = true
	_clearDescription()
	reward1.icon = items[0].icon
	reward2.icon = items[1].icon
	reward3.icon = items[2].icon
	reward1.button_pressed = false
	reward2.button_pressed = false
	reward3.button_pressed = false
	visible = true

func _onRewardToggled(toggledOn: bool, index: int) -> void:
	if toggledOn:
		selectedIndex = index
		var item: ItemObject = currentItems[index]
		itemNameLabel.text = item.itemName
		itemDescriptionLabel.text = item.itemDescription
		takeItButton.disabled = false
	else:
		selectedIndex = -1
		_clearDescription()
		takeItButton.disabled = true

func _onTakeIt() -> void:
	Global.gameCycle.claimRewards(selectedIndex)
	Global.gameCycle.finishLocation()
	visible = false

func _onIgnore() -> void:
	Global.gameCycle.finishLocation()
	visible = false

func _clearDescription() -> void:
	itemNameLabel.text = ""
	itemDescriptionLabel.text = ""
