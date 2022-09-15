shader_type spatial;

uniform sampler2D light;

void fragment() {
	// Place fragment code here.
	vec3 norm = NORMAL;
	
	vec3 color_res = vec3(UV,0);
	
	ALBEDO = color_res;
}
