shader_type canvas_item;

uniform vec4 fill_color:hint_color;

void fragment(){
	COLOR.rgb = fill_color.rgb;
	COLOR.a = texture(TEXTURE, UV).a;
}