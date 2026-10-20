extends Node2D

@onready var move_timer = $move_timer
@onready var delay_timer = $delay_timer
@onready var player1 = $player1
@onready var player2 = $player2
@onready var label = $label
@onready var death_sound = $death_sound
@onready var subtitle = $sublabel
@onready var subtitle_timer = $subtitle_timer

enum State {
	TITLE,
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
var state: State = State.TITLE

func _ready() -> void:
	grid.resize(GRID_SIZE)
	move_timer.timeout.connect(_on_timeout)
	delay_timer.timeout.connect(_on_delay_timer_timeout)
	subtitle_timer.timeout.connect(_on_subtitle_timeout)
	self.set_title()

func _on_delay_timer_timeout():
	label.visible = true

func start_subtitle_blink():
	subtitle_timer.start(1.0)

func stop_subtitle_blink():
	subtitle_timer.stop()
	self.subtitle.visible = false

func _on_subtitle_timeout():
	subtitle_timer.start(0.5)
	self.subtitle.visible = not self.subtitle.visible

func reset_players():
	player1.setup(CELL_SIZE)
	player2.setup(CELL_SIZE)
	grid.resize(GRID_SIZE)
	grid.fill(false)

func set_title():
	self.label.text = "LIGHTCYCLE"
	self.reset_players()
	self.stop_subtitle_blink()
	self.start_subtitle_blink()

func set_running():
	self.reset_players()
	self.stop_subtitle_blink()
	label.text = ""
	label.visible = false
	self.state = State.RUNNING
	self.move_timer.start()

func set_game_over(message: String):
	label.text = message
	self.delay_timer.start()
	self.move_timer.stop()
	self.state = State.GAME_OVER
	self.start_subtitle_blink()

func is_in_bounds(cell: Vector2i) -> bool:
	return !(cell.x < 1 || cell.y < 1 || cell.x >= GRID_WIDTH || cell.y >= GRID_HEIGHT)

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
	var b_button_pressed = Input.is_action_just_pressed("p1_b") || Input.is_action_just_pressed("p2_b")
	if self.state == State.TITLE:
		if a_button_pressed:
			self.set_running()
	if self.state == State.GAME_OVER:
		if a_button_pressed:
			self.set_running()
		elif b_button_pressed:
			self.set_title()

func _draw():
	var border_rect = Rect2(Vector2(1, 1), Vector2(SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1))
	var border_color = Color('#fff')
	draw_rect(border_rect, border_color, false)
