#version 460 core

#ifdef GL_ES
precision highp float;
#endif

#define PI 3.14159
#include "davis-km.glsl"
#include "extra-colors.glsl"


uniform vec2 u_resolution;

out vec4 FragColor;

void main() {
    vec2 st = gl_FragCoord.xy / u_resolution;

    vec3 color = vec3(1.0);

    if (st.x > .5) {
        pigment mixed_pigment = mix_pigments(YELLOW, BLUE, st.y);
        color = pigment_to_srgb(mixed_pigment);
    } else {
        color = mix(pigment_to_srgb(YELLOW), pigment_to_srgb(BLUE), st.y);

    }

    FragColor = vec4(color, 1.0);

}
