class_name PlayerController
extends Node;

var inventory: PlayerInventory;

func _init() -> void:
	inventory = PlayerInventory.new();