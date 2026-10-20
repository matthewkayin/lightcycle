shader_type canvas_item;

uniform vec4 line_color: source_color = vec4(1, 1, 1, 1);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float steps = 6.0;
	float diff = 2.0 - (abs(UV.y - 0.5) / 0.5) - (abs(UV.x - 0.5) / 0.5);
	diff += (1.0 - step(diff, 0.8)) * 0.5;
	diff += 0.4;
	diff = floor(diff * steps) / steps;
	COLOR = line_color * diff;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
