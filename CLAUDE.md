# CLAUDE.md — Project Code Style & Structure

## Game Overview

A turn-based RPG roguelike where all actions (attack, defense, effects) are driven by slot machines.

**Combat:** player and enemy take turns spinning slot machines on their equipped items.  
**Weapon:** 9-slot machine, 6 symbols (strawberry, star, chest, cherry, seven, blank). Each symbol = 1 damage (blank = 0). Matching 3+ identical symbols triggers multipliers (×3 up to ×100 jackpot). Each weapon may have bonus conditions (e.g. three stars → ×2).  
**Armor** (body slot): same slot machine mechanic — armor generated lasts one turn.  
**Inventory slots:** right hand, left hand, body, helmet.  
**Rewards:** after each battle, choose one of three equipment items to add to inventory.

---

## Folder Structure

```
202606-very-serious-juniper-dev-game-jam/
├── autoload/                    # Global singletons (autoload nodes)
│   ├── eventBus/                # EventBus singleton
│   ├── saveSystem/              # SaveSystem singleton
│   ├── sceneTransitionManager/  # SceneTransitionManager singleton (has .tscn)
│   └── Global.gd                # Global autoload script
├── components/                  # Reusable component scripts (no scene required)
│   └── grabableComponent/       # GrabableComponent logic
├── levels/                      # Level scenes
│   └── BattleScene.tscn         # Battle level scene
├── src/                         # Pure GDScript: data models, controllers, utilities
│   ├── battle/                  # Battle system (BattleEvent, EnemyObject)
│   ├── items/                   # Item data (ItemObject)
│   ├── player/                  # Player logic (PlayerController, PlayerInventory)
│   ├── slotMachine/             # Slot machine logic (SlotMachineController)
│   └── GameCycle.gd             # Top-level game cycle controller
└── assets/                      # (not documented)
└── addons/                      # (not documented)
```

**File placement rules:**
- Scenes and their attached scripts live together in the same folder (`MyScene.tscn` + `MyScene.gd`)
- Scripts without scenes (data models, controllers, utilities) go into `src/`
- Reusable component scripts (no scene) go into `components/`
- Autoload singletons go only into `autoload/`
- One level = one scene file under `levels/`

---

## File Naming

| File type          | Convention  | Example                      |
|--------------------|-------------|------------------------------|
| GDScript (`.gd`)   | PascalCase  | `PlayerController.gd`        |
| Scene (`.tscn`)    | PascalCase  | `Player.tscn`                |
| Abstract class     | PascalCase  | `Grabable.gd`, `Usable.gd`   |
| Dialogue           | camelCase   | `testDebug.dialogue`         |

The `.gd` filename must match the `.tscn` it is attached to.

---

## GDScript — Code Style

### Classes

```gdscript
class_name MyClassName  # PascalCase
extends Node2D
```

### Constants

```gdscript
const SPEED = 130.0             # UPPER_SNAKE_CASE
const INTERACT_DISTANCE = 37.0
const GRAB_MULTIPLICATOR = 0.7
```

### Enums

```gdscript
enum State { IDLE, WALK }  # name — PascalCase, values — UPPER_CASE
```

### Variables and fields

```gdscript
var state = State.IDLE
var lastDirection = Vector2.DOWN
var grabbedBody: StaticBody2D = null  # explicit typing is encouraged
```

All names use **camelCase**.

### @export and @onready

```gdscript
@export var starterScene: PackedScene     # camelCase
@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
```

For `@onready`, always reference the node using its unique name via `%NodeName`.

### Signals

```gdscript
signal level_changed()                                  # snake_case
signal usable_object_is_hovered(usable_object: Node2D)
signal animation_fade_in_to_object(obj: Node2D)
```

### Methods

```gdscript
# Godot lifecycle methods — standard underscore-prefixed snake_case
func _ready() -> void:
func _process(_delta: float) -> void:

# Custom methods — camelCase
func updateGrabbedPosition() -> void:
func grabObject() -> void:
func checkRaycast() -> void:
```

Always annotate the return type (`-> void`, `-> bool`, `-> Node2D`, etc.) and parameter types.

### Local variables

```gdscript
var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
var prevTarget := lastInteractTarget  # := for type inference
```

---

## Typing conventions

- Class fields — explicit type annotation: `var foo: int = 0`
- Local variables — type inference via `:=` is acceptable
- Function parameters and return values — always typed

---

## Scene node conventions

- Node names inside `.tscn` files — PascalCase: `AnimatedSprite2D`, `CollisionShape2D`
- Nodes referenced from code must have a **unique name** (`%UniqueName`)
- Never use `$"../../SomeNode"` — always use `@onready` with `%`

---

## General

- Comments only when the *why* is non-obvious; never describe *what* the code does
- No trailing semicolons
- Use `MainEventBus` signals for cross-scene communication instead of direct node references
