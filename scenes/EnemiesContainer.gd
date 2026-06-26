class_name EnemiesContainer
extends Node2D

const ENEMY_SPRITE_MAP: Dictionary = {
	"Wolf": 1,
}

const ORBIT_RADIUS: float = 5.0
const ORBIT_SPEED: float = 1.5

@onready var enemySprite1: Sprite2D = %Monstr1
@onready var enemySprite2: Sprite2D = %Monstr2
@onready var enemySprite3: Sprite2D = %Monstr3
@onready var enemySprite4: Sprite2D = %Monstr4
@onready var enemySprite5: Sprite2D = %Monstr5
@onready var enemySprite6: Sprite2D = %Monstr6

var _activeSprite: Sprite2D = null
var _basePosition: Vector2 = Vector2.ZERO
var _tween: Tween = null

func _ready() -> void:
	_hideAllEnemies()
	EventBus.battle_started.connect(_on_battle_started)

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
