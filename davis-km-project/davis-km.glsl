#define SPD_MIN_NM 380
#define SPD_MAX_NM 750
#define SPD_STEP_SIZE_NM 10
#define SPD_BUCKETS ((SPD_MAX_NM - SPD_MIN_NM) / SPD_STEP_SIZE_NM + 1)

//K1, K2 affect brightness - they affect the how 'matte' or 'shiny' our fake colors are
//Little on the low side, emulates a matte finish with more saturation
//YD65 is the tristimulus values - basically is a value of light hitting the surface, precomputed
//lower values make the scene brighter
//higher values make the scene darker
const float K1 = 0.02;
const float K2 = 0.65;
const float YD65 = 11619.34742175;
// const float YD65 = 1000.0;
// const float YD65 = 30000.0;

mat3 C_MATRIX = mat3(
    3.2404542, -0.9692660, 0.0556434,
    -1.5371385, 1.8760108, -0.2040259,
    -0.4985314, 0.0415560, 1.0572252
);

struct pigment {
    float k[SPD_BUCKETS];
    float s[SPD_BUCKETS];
};

// light affecting the pigment - CIE Standard Illuminant D65
float D65[SPD_BUCKETS] = float[](
    49.9755, 54.6482, 82.7549, 91.486, 93.4318, 86.6823, 104.865, 117.008,
    117.812, 114.861, 115.923, 108.811, 109.354, 107.802, 104.79, 107.689,
    104.405, 104.046, 100, 96.3342, 95.788, 88.6856, 90.0062, 89.5991,
    87.6987, 83.2886, 83.6992, 80.0268, 80.2146, 82.2778, 78.2842, 69.7213,
    71.6091, 74.349, 61.604, 69.8856, 75.087, 63.5927
);

//X_,Y_,Z_ are CIE 1931 Color Matching Functions - definitions for how to interpret light
//could be changed to mimic vision deficiencies but that's not the current goal
float X_[SPD_BUCKETS] = float[](
    0.0002, 0.0024, 0.0191, 0.0847, 0.2045, 0.3147, 0.3837, 0.3707,
    0.3023, 0.1956, 0.0805, 0.0162, 0.0038, 0.0375, 0.1177, 0.2365, 0.3768,
    0.5298, 0.7052, 0.8787, 1.0142, 1.1185, 1.124, 1.0305, 
    0.8563, 0.6475, 0.4316, 0.2683, 0.1526, 0.0813, 0.0409, 0.0199,
     0.0096,0.0046, 0.0022, 0.001, 0.0005, 0.0003
);
float Y_[SPD_BUCKETS] = float[](
    0, 0.0003, 0.002, 0.0088, 0.0214, 0.0387, 0.0621, 0.0895, 0.1282,
    0.1852, 0.2536, 0.3391, 0.4608, 0.6067, 0.7618, 0.8752,
    0.962, 0.9918, 0.9973, 0.9556, 0.8689, 0.7774, 0.6583, 0.528,
    0.3981, 0.2835, 0.1798, 0.1076, 0.0603, 0.0318, 0.0159, 0.0077,
    0.0037, 0.0018, 0.0008, 0.0004, 0.0002, 0.0001
);
float Z_[SPD_BUCKETS] = float[](
    0.0007, 0.0105, 0.086, 0.3894, 0.9725, 1.5535, 1.9673, 1.9948,
    1.7454, 1.3176, 0.7721, 0.4153, 0.2185, 0.112, 0.0607, 0.0305,
    0.0137, 0.004, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0
);

//base colors
//since it's based on RBY and BW you hypothetically have access to every color
//(within a range that exists between all the given colors)
const pigment WHITE = pigment(
    float[](
        1.62,0.33,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0
    ),
    float[](
        0.4,0.4,0.4,0.4,0.3,0.3,0.3,0.3,
        0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3,
        0.3,0.3,0.3,0.3,0.3,0.3,0.3,
        0.3, 0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3,
        0.3,0.3,0.3,0.3, 0.3,0.3
    )
);
const pigment RED = pigment(
    float[](
        1.72,1.43,0.76,1.44,2.74,1.77,1.41,0.97,
        0.66,0.4,0.92,1.26,1.62,2.15,4.64,4.8,
        4.96,3.35,1.99,0.74,2.28,0.01,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0
    ),
    float[](
        0.11,0.08,0.04,0.09,0.14,0.2,0.25,0.3,
        0.28,0.25,0.23,0.2,0.18,0.19,0.19,0.2,
        0.21,0.21,0.22,0.18,0.15,0.11,0.07,0.03,
        0.03,0.03,0.03,0.03,0.03,0.02,0.02,0.02,
        0.02,0.02,0.02,0.01,0.01,0.01
    )
);
const pigment BLUE = pigment(
    float[](
        0.32,0.19,0.1,0.04,0.03,0.01,0.01,0,
        0,0,0,0,0,0.09,0.26,0.61,
        1.47,2.26,1.81,2.14,2.48,2.82,3.16,3.61,
        3.61,3.61,3.61,2.93,0.64,0.21,0.07,0,
        0,0,0,0,0,0),
    float[](
        0.2,0.15,0.1,0.05,0.05,0.02,0.01,0,
        0,0,0,0,0,0.05,0.1,0.15,
        0.2,0.25,0.2,0.24,0.28,0.31,0.35,0.4,
        0.4,0.4,0.4,0.33,0.25,0.18,0.1,0,
        0,0,0,0,0,0
    )
);

const pigment YELLOW = pigment(
    float[](
        0.9,0.16,0.13,0.11,0.09,0.08,0.07,0.06,
        0.07,0.1,0.1,0.12,0.1,0.01,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0.01,0.01,0.01,0.01,0,0 // Added 2 zeros to make it 38 elements
    ),
    float[](
        0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,
        0.15,0.25,0.3,0.4,0.4,0.55,0.62,0.65,
        0.7,0.72,0.75,0.72,0.72,0.72,0.7,0.69,
        0.68,0.67,0.66,0.64,0.63,0.62,0.61,0.6,
        0.55,0.52,0.49,0.46,0.43,0.4
    )
);

const pigment BLACK = pigment(
    float[] (
        0.49,0.49,0.49,0.49,0.49,0.49,0.49,0.49,
        0.49,0.49,0.49,0.49,0.49,0.49,0.49,0.49,
        0.49,0.49,0.49,0.49,0.49,0.49,0.49,0.49,
        0.49,0.49,0.49,0.49,0.49,0.49,0.49,0.49,
        0.49,0.49,0.49,0.49,0.49,0.49
    ),
    float[] (
    0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,
    0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,
    0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,
    0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,
    0.01,0.01,0.01,0.01,0.01,0.01
    )
);

float reflectance_mix(float ks) {
    ks = max(0.0, ks);
    return 1.0 / (1.0 + ks + sqrt(ks * ks + 2.0 * ks));
}

float saunderson_mix(float ks) {
    float R = reflectance_mix(ks);
    return ((1.0 - K1) * (1.0 - K2) * R ) / (1.0 - K2 * R);
}

vec3 rgb_to_srgb(float r, float g, float b) {
    return vec3(pow(r, 1.0/2.2), pow(g, 1.0/2.2), pow(b, 1.0/2.2));
}


//helper function that takes in pigment and converts to srgb color space
vec3 reflectance_spectrum_to_srgb(float R_spectrum[SPD_BUCKETS]) {
    float res_x = 0.0;
    float res_y = 0.0;
    float res_z = 0.0;

    float table_x[SPD_BUCKETS];
    float table_y[SPD_BUCKETS];
    float table_z[SPD_BUCKETS];

    for (int f = 0; f < SPD_BUCKETS; f++) {
        table_x[f] = D65[f] * X_[f] * R_spectrum[f];
        table_y[f] = D65[f] * Y_[f] * R_spectrum[f];
        table_z[f] = D65[f] * Z_[f] * R_spectrum[f];
    }

    for (int f = 0; f < SPD_BUCKETS - 1; f++) {
        res_x += table_x[f] + table_x[f + 1];
        res_y += table_y[f] + table_y[f + 1];
        res_z += table_z[f] + table_z[f + 1];
    }

    res_x *= float(SPD_STEP_SIZE_NM) / 2.0;
    res_y *= float(SPD_STEP_SIZE_NM) / 2.0;
    res_z *= float(SPD_STEP_SIZE_NM) / 2.0;

    vec3 linear_rgb_vec = (C_MATRIX * vec3(res_x, res_y, res_z)) / YD65;
    return rgb_to_srgb(linear_rgb_vec.r, linear_rgb_vec.g, linear_rgb_vec.b);
}


//does some math to properly blend your pigments
//the default mix function isn't bad but does it a lot less accurately
pigment mix_pigments(pigment first_pigment, pigment second_pigment, float mix_factor) {
    mix_factor = clamp(mix_factor, 0.0, 1.0);
    float conc1 = 1.0 - mix_factor;
    float conc2 = mix_factor;

    pigment result_pigment;

    for (int f = 0; f < SPD_BUCKETS; f++) {
        float K_sum = 0.0;
        float S_sum = 0.0;
        K_sum += conc1 * first_pigment.k[f];
        S_sum += conc1 * first_pigment.s[f];

        K_sum += conc2 * second_pigment.k[f];
        S_sum += conc2 * second_pigment.s[f];

        result_pigment.k[f] = K_sum;
        result_pigment.s[f] = S_sum;
    }
    return result_pigment;
}

//takes in values and treats them as a ratio
//make_pigment(1.0, 1.6, 0.0, 3.0, 0.0) gives a bright, desaturated purple
//it's 1 part red, 1.6 parts blue, and 3 parts white
pigment make_pigment(float red_amount, float blue_amount, float yellow_amount, float white_amount, float black_amount) {
    float red = max(0.0, red_amount);
    float blu = max(0.0, blue_amount);
    float ylw = max(0.0, yellow_amount);
    float wht = max(0.0, white_amount);
    float blk = max(0.0, black_amount);

    float total_color_prop = red + blu + ylw + wht + blk;

    pigment result_pigment;

    if (total_color_prop < 1e-9) {
        for (int f = 0; f < SPD_BUCKETS; f++) {
            result_pigment.k[f] = 0.0;
            result_pigment.s[f] = 0.0;
        }
        return result_pigment;
    }

    float norm_red = red / total_color_prop;
    float norm_blu = blu / total_color_prop;
    float norm_ylw = ylw / total_color_prop;
    float norm_wht = wht / total_color_prop;
    float norm_blk = blk / total_color_prop;


    for (int f = 0; f < SPD_BUCKETS; f++) {
        result_pigment.k[f] = norm_red * RED.k[f] + norm_blu * BLUE.k[f] + norm_ylw * YELLOW.k[f] + norm_wht * WHITE.k[f] + norm_blk * BLACK.k[f];
        result_pigment.s[f] = norm_red * RED.s[f] + norm_blu * BLUE.s[f] + norm_ylw * YELLOW.s[f] + norm_wht * WHITE.s[f] + norm_blk * BLACK.s[f];
    }

    return result_pigment;
}

//turns your pigment into color
vec3 pigment_to_srgb(pigment pigment) {
    float R_spectrum[SPD_BUCKETS];

    for (int f = 0; f < SPD_BUCKETS; f++) {
        float K_val = pigment.k[f];
        float S_val = pigment.s[f];

        float R_val = 0.0;
        if (S_val > 1e-9) {
            R_val = saunderson_mix(K_val / S_val);
        } else if (K_val > 1e-9) {
            R_val = 0.0;
        } else { 
            R_val = 1.0;
        }
        R_spectrum[f] = R_val;
    }

    return reflectance_spectrum_to_srgb(R_spectrum);
}