#include "davis-km.glsl"

const pigment GREEN = pigment(
    mix_pigments(mix_pigments(YELLOW, BLUE, .02), BLACK, .01)
);

const pigment PURPLE = pigment(
    mix_pigments(mix_pigments(RED, BLUE, .15), WHITE, .65)
);

const pigment ORANGE = pigment(
    mix_pigments(mix_pigments(RED, YELLOW, .45), BLACK, .0015)
);