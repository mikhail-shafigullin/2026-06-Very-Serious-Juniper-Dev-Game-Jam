class_name PlayerController
extends Node;

var maxHp: int = 1000
var currentHp: int = 1000
var inventory: PlayerInventory

func _init() -> void:
	inventory = PlayerInventory.new()

func takeDamage(amount: int) -> void:
	currentHp -= amount