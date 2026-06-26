class_name PlayerController
extends Node;

var maxHp: int = 200
var currentHp: int = 200
var inventory: PlayerInventory

func _init() -> void:
	inventory = PlayerInventory.new()

func takeDamage(amount: int) -> void:
	currentHp -= amount