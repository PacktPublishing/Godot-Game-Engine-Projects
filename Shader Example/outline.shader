shader_type canvas_item;

uniform float outline_width = 4.0;
uniform vec4 outline_color: hint_color;

void fragment(){
	vec4 col = texture(TEXTURE, UV);
	vec2 pixel_size = TEXTURE_PIXEL_SIZE;
	float a;
	float max_alpha = col.a;
	float min_alpha = col.a;
	
	a = texture(TEXTURE, UV + vec2(0, -outline_width) * pixel_size).a;
	max_alpha = max(a, max_alpha);
	min_alpha = min(a, min_alpha);
	
	a = texture(TEXTURE, UV + vec2(0, outline_width) * pixel_size).a;
	max_alpha = max(a, max_alpha);
	min_alpha = min(a, min_alpha);
	
	a = texture(TEXTURE, UV + vec2(-outline_width, 0) * pixel_size).a;
	max_alpha = max(a, max_alpha);
	min_alpha = min(a, min_alpha);
	
	a = texture(TEXTURE, UV + vec2(outline_width, 0) * pixel_size).a;
	max_alpha = max(a, max_alpha);
	min_alpha = min(a, min_alpha);
	
	COLOR = mix(col, outline_color, max_alpha - min_alpha);
}