class_name EnemiesContainer
extends Node2D

const ENEMY_SPRITE_MAP: Dictionary = {
	"Wolf": 1,
	"Skeleton": 2
}

const ORBIT_RADIUS: float = 5.0
const ORBIT_SPEED: float = 1.5

@onready var enemySprite1: Sprite2D = %Monstr1
@onready var enemySprite2: Sprite2D = %Monstr2
@onready var enemySprite3: Sprite2D = %Monstr3
@onready var enemySprite4: Sprite2D = %Monstr4
@onready var enemySprite5: Sprite2D = %Monstr5
@onready var enemySprite6: Sprite2D = %Monstr6
@onready var playerAttackEffect: AnimatedSprite2D = %PlayerAttackEffect;
@onready var timer: Timer = %Timer;
@onready var damageAnimLabel: Label = %DamageAnimLabel;

var _activeSprite: Sprite2D = null
var _basePosition: Vector2 = Vector2.ZERO
var _tween: Tween = null
var _pendingDamage: int = 0

func _ready() -> void:
	_hideAllEnemies()
	playerAttackEffect.sprite_frames.set_animation_loop("slash", false)
	playerAttackEffect.animation_finished.connect(_onAttackEffectFinished)
	timer.timeout.connect(_onTimerTimeout)
	EventBus.battle_started.connect(_on_battle_started)
	EventBus.battle_finished.connect(_onBattleFinished)
	EventBus.player_turn_result.connect(onPlayerAttack)

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
	_activeSprite.visible = true
	_startOrbitTween()

func _startOrbitTween() -> void:
	_tween = create_tween().set_loops()
	_tween.tween_method(_setOrbitPosition, 0.0, TAU, TAU / ORBIT_SPEED)

func _setOrbitPosition(angle: float) -> void:
	_activeSprite.position = _basePosition + Vector2(cos(angle), sin(angle)) * ORBIT_RADIUS

func _onBattleFinished() -> void:
	if _activeSprite == null:
		return
	if _tween != null:
		_tween.kill()
		_tween = null
	var fadeTween := create_tween()
	fadeTween.tween_property(_activeSprite, "modulate:a", 0.0, 0.5)
	await fadeTween.finished
	_activeSprite.visible = false
	_activeSprite.modulate.a = 1.0
	_activeSprite = null

func onPlayerAttack(damage: int) -> void:
	_pendingDamage = damage
	timer.start()

func _onTimerTimeout() -> void:
	playerAttackEffect.show()
	playerAttackEffect.play("slash")
	damageAnimLabel.text = str(_pendingDamage)
	damageAnimLabel.modulate.a = 1.0
	damageAnimLabel.position = Vector2.ZERO
	damageAnimLabel.show()
	var tween := create_tween()
	tween.tween_property(damageAnimLabel, "position:y", -40.0, 0.6)
	tween.parallel().tween_property(damageAnimLabel, "modulate:a", 0.0, 0.6)

func _onAttackEffectFinished() -> void:
	playerAttackEffect.stop()
	playerAttackEffect.hide()
