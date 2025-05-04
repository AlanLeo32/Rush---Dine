shader_type canvas_item;

uniform sampler2D mask_texture : hint_default_white;
uniform vec2 mask_size;
uniform vec2 mask_position;

void fragment() {
    vec2 local_uv = (SCREEN_UV * mask_size - mask_position) / mask_size;
    vec4 mask_pixel = texture(mask_texture, local_uv);
    if (mask_pixel.a < 0.1) {
        discard;
    }
    COLOR = COLOR * mask_pixel.a;
}

