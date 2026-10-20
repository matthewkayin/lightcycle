extends Node2D

@export var player: String
@export var starting_direction: Vector2i
@export var texture: Texture2D

@onready var debug_head = $debug_head
@onready var death_anim = $death_anim

var CELL_SIZE: int
var tail: Array[Vector2i] = []
var direction: Vector2i
var color: Color
var is_dead: bool

enum Direction {
	UP,
	RIGHT,
	DOWN,
	LEFT
}

const SpriteLookup = [
	0, 4, 1, 3,
	4, 0, 5, 2,
	1, 5, 0, 6,
	3, 2, 6, 0
]

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
	self.death_anim.animation_finished.connect(_on_animation_finished)

func play_death_animation():
	self.get_parent().death_sound.play()
	self.death_anim.visible = true
	self.death_anim.play()

func _on_animation_finished():
	self.death_anim.stop()
	self.death_anim.visible = false

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
		self.death_anim.position = Vector2(next * CELL_SIZE) + Vector2(CELL_SIZE / 2, CELL_SIZE / 2)
		self.play_death_animation()
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

func get_frame_index(index: int) -> int:
	if tail.size() == 1:
		return 0

	if index == tail.size() - 1:
		match self.direction:
			Vector2i.RIGHT: return 7
			Vector2i.LEFT: return 8
			Vector2i.UP: return 9
			Vector2i.DOWN: return 10
			_: return 0

	var current = self.tail[index]

	var next = self.tail[index + 1]
	var next_direction: Direction
	for direction_index in range(4):
		if next == current + DIRECTION_VECTOR2I[direction_index]:
			next_direction = direction_index as Direction
			break

	if index == 0:
		match (next_direction + 2) % 4:
			Direction.RIGHT: return 7
			Direction.LEFT: return 8
			Direction.UP: return 9
			Direction.DOWN: return 10

	var prev = self.tail[index - 1]
	var prev_direction: Direction
	for direction_index in range(4):
		if prev == current + DIRECTION_VECTOR2I[direction_index]:
			prev_direction = direction_index as Direction
			break

	return SpriteLookup[prev_direction + (next_direction * 4)]

func _draw() -> void:
	for index in range(tail.size()):
		var frame_index = self.get_frame_index(index)
		var cell = self.tail[index]
		var rect = Rect2(cell * CELL_SIZE, Vector2(CELL_SIZE, CELL_SIZE))
		var src_rect = Rect2(Vector2(frame_index * CELL_SIZE, 0), Vector2(CELL_SIZE, CELL_SIZE))
		draw_texture_rect_region(self.texture, rect, src_rect)
