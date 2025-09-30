shader_type canvas_item;

uniform bool active = false;
uniform vec4 flash_color : source_color = vec4(0.2, 0.4, 1.0, 1.0); 
uniform float flash_strength = 1.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);


    if (active) {
        COLOR = mix(tex_color, flash_color, flash_strength);
    } else {
        COLOR = tex_color;
    }
}

