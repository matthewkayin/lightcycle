extends Node2D

@export var player: String
@export var starting_direction: Vector2i

@onready var debug_head = $debug_head

var CELL_SIZE: int
var tail: Array[Vector2i] = []
var direction: Vector2i
var color: Color
var is_dead: bool

var DIRECTION_INPUTS: Array[String]
const DIRECTION_VECTOR2I = [
	Vector2i.UP,
	Vector2i.RIGHT,
	Vector2i.DOWN,
	Vector2i.LEFT,
]

func _ready() -> void:
	self.color = debug_head.color
	self.DIRECTION_INPUTS = [
		player + "_up",
		player + "_right",
		player + "_down",
		player + "_left"
	]

func setup(with_cell_size: int):
	self.CELL_SIZE = with_cell_size
	debug_head.visible = false
	direction = starting_direction
	var cell = Vector2i(debug_head.position) / CELL_SIZE
	self.tail = [cell]
	self.is_dead = false

func get_next():
	return tail.back() + direction

func step():
	var next = self.get_next()
	var grid = get_parent()
	if grid.is_blocked(next):
		self.is_dead = true
		return
	grid.set_blocked(next, true)
	tail.push_back(next)
	queue_redraw()

func _process(_delta: float) -> void:
	for direction_index in range(4):
		if Input.is_action_just_pressed(DIRECTION_INPUTS[direction_index]):
			var target_direction = DIRECTION_VECTOR2I[direction_index]
			if target_direction != direction * -1:
				direction = target_direction

func _draw() -> void:
	for cell in tail:
		var rect = Rect2(cell * CELL_SIZE, Vector2(CELL_SIZE, CELL_SIZE))
		draw_rect(rect, color)
