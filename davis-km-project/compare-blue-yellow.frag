#version 460 core

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159
#include "davis-km.glsl"

uniform vec2 u_resolution;

out vec4 FragColor;

void main() {
    vec2 st = gl_FragCoord.xy / u_resolution;
    float pct = 0.0;

    pct = 1.0 - pow(abs(sin(PI *(st.y) / 2.0)), .5);

    vec3 color = vec3(1.0);

    if (st.x > .5) {
        pigment mixed_pigment = mix_pigments(YELLOW, BLUE, pct);
        color = pigment_to_srgb(mixed_pigment);
    } else {
        color = mix(vec3(1.0, 1.0, 0.0), vec3(0.0,0.0,1.0), pct);
    }

    FragColor = vec4(color, 1.0);

}