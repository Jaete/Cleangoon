shader_type canvas_item;

uniform sampler2D screen_text: hint_screen_texture;
uniform sampler2D noise_text : filter_nearest, repeat_enable;
uniform vec2 speed = vec2(0.2, 0.2);

uniform float distortion = 0.01;

void vertex() {
	
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV + speed * TIME;
	vec2 noise = 2.0 * texture(noise_text, uv).rg - vec2(1.0);
	COLOR = texture(TEXTURE, uv);
	COLOR *= texture(screen_text, SCREEN_UV + noise * distortion);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
