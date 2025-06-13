#version 460 core

#ifdef GL_ES
precision highp float;
#endif

#define PI 3.14159
#define TAU 2 * PI
#include "../davis-km.glsl"

uniform vec2 u_resolution;
uniform float u_time;

out vec4 FragColor;



void main() {
    vec2 st = (gl_FragCoord.xy / u_resolution) * 4.0 - 2.0;
    float mix_factor = distance(st, vec2(0.0)) / 1.5;

    pigment PURPLE = make_pigment(.4, .2, 0.1, 2.0, 0.0);
    
    vec3 color = pigment_to_srgb(mix_pigments(PURPLE, BLACK, mix_factor));
    
    FragColor = vec4(color, 1.0);

}   