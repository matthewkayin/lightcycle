extends ColorRect

const SCREEN_WIDTH: int = 336
const SCREEN_HEIGHT: int = 262

func _draw():
	var border_rect = Rect2(Vector2(1, 1), Vector2(SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1))
	var border_color = Color('#fff')
	draw_rect(border_rect, border_color, false)
