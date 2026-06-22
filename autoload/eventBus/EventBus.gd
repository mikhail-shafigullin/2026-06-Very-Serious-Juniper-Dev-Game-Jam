extends Node

signal gameStarted

signal location_started()
signal location_finished()

signal battle_started()
signal battle_finished()

signal player_hp_changed(current_hp: int, max_hp: int)
signal player_slot_spun(results: Array)
signal player_turn_result(total: int)

signal enemy_hp_changed(current_hp: int, max_hp: int)
signal enemy_slot_spun(results: Array)
signal enemy_turn_result(total: int)

signal rewards_available(items: Array)
