#version 460 core

#ifdef GL_ES
precision highp float;
#endif

#define PI 3.14159
#define TAU 2 * PI
#include "../davis-km.glsl"
#include "../extra-colors.glsl"

uniform vec2 u_resolution;
uniform float u_time;

out vec4 FragColor;


float make_pentagon(vec2 st) {
    st.x *= u_resolution.x/u_resolution.y;
    
    int sides = 5;
    float a = atan(st.x, st.y) + PI;
    float r = TAU/float(sides);
    float pentagon = cos(floor(.5+a/r)*r-a)*length(st);

    return 1.0 - pentagon;

}

mat2 rotate2d(float _angle) {
    return mat2(cos(_angle), -sin(_angle), sin(_angle), cos(_angle));
}

void main() {
    vec2 st = (gl_FragCoord.xy / u_resolution) * 4.0 - 2.0;
    float mix_factor = distance(st, vec2(0.0));
    st = rotate2d( sin(u_time)*PI) * st;

    mix_factor += pow(make_pentagon(st * 1.5), 1.0);
    mix_factor *= 1.2;
    
    vec3 color = pigment_to_srgb(mix_pigments(RED, WHITE, mix_factor));
    // vec3 color = vec3(mix_factor);
    // vec3 color = mix(vec3(1.0,0.0,0.0), vec3(1.0,1.0,1.0), mix_factor);
    
    FragColor = vec4(color, 1.0);

}   