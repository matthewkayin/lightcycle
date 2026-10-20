extends Node2D

@onready var move_timer = $move_timer
@onready var player1 = $player1
@onready var player2 = $player2
@onready var label = $label

enum State {
	RUNNING,
	GAME_OVER
}

const CELL_SIZE: int = 4
const SCREEN_WIDTH: int = 336
const SCREEN_HEIGHT: int = 262
const GRID_WIDTH: int = SCREEN_WIDTH / CELL_SIZE
const GRID_HEIGHT: int = SCREEN_HEIGHT / CELL_SIZE
const GRID_SIZE: int = GRID_WIDTH * GRID_HEIGHT

var grid: Array[bool]
var state: State = State.RUNNING

func _ready() -> void:
	grid.resize(GRID_SIZE)
	move_timer.timeout.connect(_on_timeout)
	self.set_running()

func set_running():
	label.text = ""
	player1.setup(CELL_SIZE)
	player2.setup(CELL_SIZE)
	grid.resize(GRID_SIZE)
	grid.fill(false)
	self.state = State.RUNNING
	self.move_timer.start()

func set_game_over(message: String):
	label.text = message
	self.move_timer.stop()
	self.state = State.GAME_OVER

func is_in_bounds(cell: Vector2i) -> bool:
	return !(cell.x < 1 || cell.y < 1 || cell.x >= GRID_WIDTH - 1 || cell.y >= GRID_HEIGHT - 1)

func is_blocked(cell: Vector2i) -> bool:
	if !is_in_bounds(cell):
		return true
	return grid[cell.x + (cell.y * GRID_WIDTH)]

func set_blocked(cell: Vector2i, value: bool):
	grid[cell.x + (cell.y * GRID_WIDTH)] = value

func _on_timeout():
	var is_tie = player1.get_next() == player2.get_next()

	player1.step()
	player2.step()

	if (player1.is_dead && player2.is_dead) || is_tie:
		self.set_game_over("It's a Tie!")
	elif player1.is_dead:
		self.set_game_over("Player 2 Wins!!")
	elif player2.is_dead:
		self.set_game_over("Player 1 Wins!")

func _process(_delta: float) -> void:
	var a_button_pressed = Input.is_action_just_pressed("p1_a") || Input.is_action_just_pressed("p2_a")
	if self.state == State.GAME_OVER && a_button_pressed:
		self.set_running()

func _draw():
	var border_rect = Rect2(Vector2(1, 1), Vector2(SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1))
	var border_color = Color('#fff')
	draw_rect(border_rect, border_color, false)
