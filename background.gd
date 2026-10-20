extends ColorRect

const SCREEN_WIDTH: int = 336
const SCREEN_HEIGHT: int = 262

func _draw():
	var line_color = Color('#141714')
	for y in range(0, SCREEN_HEIGHT, 16):
		draw_line(Vector2(0, y), Vector2(SCREEN_WIDTH, y), line_color)
	for x in range(0, SCREEN_WIDTH, 16):
		draw_line(Vector2(x, 0), Vector2(x, SCREEN_HEIGHT), line_color)

	var border_rect = Rect2(Vector2(1, 1), Vector2(SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1))
	var border_inside_rect = Rect2(Vector2(2, 2), Vector2(SCREEN_WIDTH - 2, SCREEN_HEIGHT - 2))
	var border_color = Color('#fff')
	draw_rect(border_rect, border_color, false)
	draw_rect(border_inside_rect, border_color, false)
