shader_type canvas_item;

uniform vec2 center;
uniform float force;
uniform float size;
uniform float thickness;

void fragment() {
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaledUV = (SCREEN_UV - vec2(0.5, 0.0)) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
	float mask = (1.0 - smoothstep(size - 0.1, size, length(scaledUV - center))) *
			smoothstep(size - thickness - 0.1, size - thickness, length(scaledUV - center));
	vec2 disp = normalize(scaledUV - center) * force * mask;
	
	vec3 color = texture(SCREEN_TEXTURE, vec2(scaledUV.x, scaledUV.y) - disp).rgb;
	
	COLOR = vec4(color, 0.5);

}