class_name PlayerController
extends Node;

var maxHp: int
var currentHp: int
var inventory: PlayerInventory

func _init() -> void:
	inventory = PlayerInventory.new();