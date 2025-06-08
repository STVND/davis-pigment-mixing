#version 460 core

#ifdef GL_ES
precision mediump float;
#endif

#include "davis-km.glsl"


uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

out vec4 FragColor;

void main() {
    vec2 st = gl_FragCoord.xy / u_resolution;
    float pct = 0.0;

    pct = distance(st, vec2(.5));

    pigment mixed_pigment = mix_pigments(YELLOW, RED, pow(st.y, 2.0));
    mixed_pigment = mix_pigments(mixed_pigment, BLUE, pow(st.x, 2.0));
    mixed_pigment = mix_pigments(mixed_pigment, WHITE, pct);

    vec3 color = pigment_to_srgb(mixed_pigment);

    FragColor = vec4(color, 1.0);

}