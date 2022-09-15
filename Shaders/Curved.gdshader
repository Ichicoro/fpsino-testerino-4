shader_type canvas_item;
render_mode blend_premul_alpha;

uniform float dist_amount = 1.0;

void fragment(){
  float y = (UV.x - .5);
  y *= y * (dist_amount * ((2. * UV.y) - 1.));

  COLOR = texture(SCREEN_TEXTURE,UV-vec2(0,y));
}
