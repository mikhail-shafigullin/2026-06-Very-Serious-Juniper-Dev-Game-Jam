class_name EnemiesContainer
extends Node2D

const ENEMY_SPRITE_MAP: Dictionary = {
	"Wolf": 1,
	"Skeleton": 2,
	"Goblin": 3,
	"Woman": 4,
	"Knight": 5,
	"God": 6
}

const ORBIT_RADIUS: float = 5.0
const ORBIT_SPEED: float = 1.5

@onready var enemyHealthBar: ProgressBar = %EnemyHealthBar
@onready var enemySprite1: Sprite2D = %Monstr1
@onready var enemySprite2: Sprite2D = %Monstr2
@onready var enemySprite3: Sprite2D = %Monstr3
@onready var enemySprite4: Sprite2D = %Monstr4
@onready var enemySprite5: Sprite2D = %Monstr5
@onready var enemySprite6: Sprite2D = %Monstr6
@onready var playerAttackEffect: AnimatedSprite2D = %PlayerAttackEffect;
@onready var timer: Timer = %Timer;
@onready var damageAnimLabel: Label = %DamageAnimLabel;
@onready var healthLabel: Label = %HealthLabel;

var _activeSprite: Sprite2D = null
var _basePosition: Vector2 = Vector2.ZERO
var _tween: Tween = null
var _pendingDamage: int = 0
var _pendingHpCurrent: int = 0
var _pendingHpMax: int = 0
var _battleFinished: bool = false

func _ready() -> void:
	_hideAllEnemies()
	playerAttackEffect.sprite_frames.set_animation_loop("slash", false)
	playerAttackEffect.animation_finished.connect(_onAttackEffectFinished)
	timer.timeout.connect(_onTimerTimeout)
	EventBus.location_started.connect(_startNextBattle);
	EventBus.battle_started.connect(_on_battle_started)
	EventBus.battle_finished.connect(_onBattleFinished)
	EventBus.player_turn_result.connect(onPlayerAttack)
	EventBus.enemy_hp_changed.connect(_onEnemyHpChanged)

func _hideAllEnemies() -> void:
	if _tween != null:
		_tween.kill()
		_tween = null
	if _activeSprite != null:
		_activeSprite.position = _basePosition
		_activeSprite = null
	enemySprite1.visible = false
	enemySprite2.visible = false
	enemySprite3.visible = false
	enemySprite4.visible = false
	enemySprite5.visible = false
	enemySprite6.visible = false

func _on_battle_started() -> void:
	_hideAllEnemies()
	var enemy := Global.gameCycle.battle.currentBattle.enemy
	var spriteIndex: int = ENEMY_SPRITE_MAP.get(enemy.enemyName, -1)
	_showEnemy(spriteIndex)
	enemyHealthBar.max_value = _pendingHpMax
	enemyHealthBar.value = _pendingHpCurrent
	enemyHealthBar.show()

func _showEnemy(index: int) -> void:
	match index:
		1: _activeSprite = enemySprite1
		2: _activeSprite = enemySprite2
		3: _activeSprite = enemySprite3
		4: _activeSprite = enemySprite4
		5: _activeSprite = enemySprite5
		6: _activeSprite = enemySprite6
	if _activeSprite == null:
		return
	_basePosition = _activeSprite.position
	_activeSprite.modulate.a = 0.0
	_activeSprite.scale = Vector2(0.8, 0.8)
	_activeSprite.visible = true
	var appearTween := create_tween().set_parallel()
	appearTween.tween_property(_activeSprite, "modulate:a", 1.0, 0.4)
	appearTween.tween_property(_activeSprite, "scale", Vector2(1.0, 1.0), 0.4)
	_startOrbitTween()

func _startOrbitTween() -> void:
	_tween = create_tween().set_loops()
	_tween.tween_method(_setOrbitPosition, 0.0, TAU, TAU / ORBIT_SPEED)

func _setOrbitPosition(angle: float) -> void:
	_activeSprite.position = _basePosition + Vector2(cos(angle), sin(angle)) * ORBIT_RADIUS

func _onEnemyHpChanged(current: int, maxHp: int) -> void:
	_pendingHpCurrent = current
	_pendingHpMax = maxHp

func _onBattleFinished() -> void:
	_battleFinished = true
	enemyHealthBar.hide()
	if _tween != null:
		_tween.kill()
		_tween = null

func onPlayerAttack(damage: int) -> void:
	_pendingDamage = damage
	timer.start()

func _onTimerTimeout() -> void:
	playerAttackEffect.show()
	playerAttackEffect.play("slash")
	var tween := create_tween()
	tween.tween_interval(0.2)
	tween.tween_callback(_triggerHitEffects)

func _triggerHitEffects() -> void:
	enemyHealthBar.max_value = _pendingHpMax
	enemyHealthBar.value = _pendingHpCurrent
	healthLabel.text = str(_pendingHpCurrent) + "/" + str(_pendingHpMax);
	if _activeSprite != null:
		var flashTween := create_tween()
		flashTween.tween_property(_activeSprite, "modulate", Color.RED, 0.08)
		flashTween.tween_property(_activeSprite, "modulate", Color.WHITE, 0.08)
	damageAnimLabel.text = str(_pendingDamage)
	damageAnimLabel.modulate.a = 1.0
	damageAnimLabel.position = Vector2.ZERO
	damageAnimLabel.show()
	var labelTween := create_tween()
	labelTween.tween_property(damageAnimLabel, "position:y", -40.0, 0.6)
	labelTween.parallel().tween_property(damageAnimLabel, "modulate:a", 0.0, 0.6)
	if _battleFinished:
		_battleFinished = false
		await labelTween.finished
		if _activeSprite == null:
			return
		var fadeTween := create_tween()
		fadeTween.tween_property(_activeSprite, "modulate:a", 0.0, 0.5)
		await fadeTween.finished
		_activeSprite.visible = false
		_activeSprite.modulate.a = 1.0
		_activeSprite = null

func _onAttackEffectFinished() -> void:
	playerAttackEffect.stop()
	playerAttackEffect.hide()


func _startNextBattle(_location) -> void:
	Global.gameCycle.initBattle()
	await get_tree().create_timer(2.0).timeout
	Global.gameCycle.startBattle()
