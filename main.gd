extends Node2D

@onready var move_timer = $move_timer
@onready var player1 = $player1
@onready var player2 = $player2

const CELL_SIZE: int = 2
const SCREEN_WIDTH: int = 336
const SCREEN_HEIGHT: int = 262
const GRID_WIDTH: int = SCREEN_WIDTH / CELL_SIZE
const GRID_HEIGHT: int = SCREEN_HEIGHT / CELL_SIZE
const GRID_SIZE: int = GRID_WIDTH * GRID_HEIGHT

var grid: Array[bool]

func _ready() -> void:
	player1.setup(CELL_SIZE)
	player2.setup(CELL_SIZE)
	move_timer.timeout.connect(_on_timeout)
	grid.resize(GRID_SIZE)
	grid.fill(false)

func is_in_bounds(cell: Vector2i) -> bool:
	return !(cell.x < 0 || cell.y < 0 || cell.x >= GRID_WIDTH || cell.y >= GRID_HEIGHT)

func is_blocked(cell: Vector2i) -> bool:
	if !is_in_bounds(cell):
		return false
	return grid[cell.x + (cell.y * GRID_WIDTH)]

func set_blocked(cell: Vector2i, value: bool):
	grid[cell.x + (cell.y * GRID_WIDTH)] = value

func _on_timeout():
	player1.step()
	player2.step()

func _process(delta: float) -> void:
	pass

func _draw():
	var border_rect = Rect2(Vector2(1, 1), Vector2(SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1))
	var border_color = Color('#fff')
	draw_rect(border_rect, border_color, false)
