#define SPD_MIN_NM 380
#define SPD_MAX_NM 750
#define SPD_STEP_SIZE_NM 10
#define SPD_BUCKETS ((SPD_MAX_NM - SPD_MIN_NM) / SPD_STEP_SIZE_NM + 1)

const float K1 = 0.0031;
const float K2 = 0.650;
const float YD65 = 11619.34742175;

mat3 C_MATRIX = mat3(
    3.2404542, -0.9692660, 0.0556434,
    -1.5371385, 1.8760108, -0.2040259,
    -0.4985314, 0.0415560, 1.0572252
);

struct K_S_Curve {
    float k[SPD_BUCKETS];
    float s[SPD_BUCKETS];
};

float D65[SPD_BUCKETS] = float[](
    49.9755, 54.6482, 82.7549, 91.486, 93.4318, 86.6823, 104.865,
    117.008, 117.812, 114.861, 115.923, 108.811, 109.354, 107.802, 104.79,
    107.689, 104.405, 104.046, 100, 96.3342, 95.788, 88.6856, 90.0062, 89.5991,
    87.6987, 83.2886, 83.6992, 80.0268, 80.2146, 82.2778, 78.2842, 69.7213,
    71.6091, 74.349, 61.604, 69.8856, 75.087, 63.5927
);
float X_[SPD_BUCKETS] = float[](
    0.0002, 0.0024, 0.0191, 0.0847, 0.2045, 0.3147, 0.3837, 0.3707,
    0.3023, 0.1956, 0.0805, 0.0162, 0.0038, 0.0375, 0.1177, 0.2365, 0.3768,
    0.5298, 0.7052, 0.8787, 1.0142, 1.1185, 1.124, 1.0305, 0.8563, 0.6475,
    0.4316, 0.2683, 0.1526, 0.0813, 0.0409, 0.0199, 0.0096, 0.0046, 0.0022,
    0.001, 0.0005, 0.0003
);
float Y_[SPD_BUCKETS] = float[](
    0, 0.0003, 0.002, 0.0088, 0.0214, 0.0387, 0.0621, 0.0895, 0.1282,
    0.1852, 0.2536, 0.3391, 0.4608, 0.6067, 0.7618, 0.8752, 0.962, 0.9918,
    0.9973, 0.9556, 0.8689, 0.7774, 0.6583, 0.528, 0.3981, 0.2835, 0.1798,
    0.1076, 0.0603, 0.0318, 0.0159, 0.0077, 0.0037, 0.0018, 0.0008, 0.0004,
    0.0002, 0.0001
);
float Z_[SPD_BUCKETS] = float[](
    0.0007, 0.0105, 0.086, 0.3894, 0.9725, 1.5535, 1.9673, 1.9948,
    1.7454, 1.3176, 0.7721, 0.4153, 0.2185, 0.112, 0.0607, 0.0305, 0.0137, 0.004,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

const K_S_Curve WHITE = K_S_Curve(
    float[](
        1.06,0.9,0.39,0.13,0.05,0.01,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01
    ),
    float[](
        0.2,0.22,0.24,0.26,0.29,0.31,0.33,0.35,0.37,0.39,0.42,0.44,0.46,0.48,
        0.5,0.52,0.55,0.57,0.59,0.61,0.63,0.65,0.68,0.7,0.72,0.74,0.76,0.78,
        0.81,0.83,0.85,0.87,0.89,0.91,0.94,0.96,0.98,1.0
    )
);
const K_S_Curve RED = K_S_Curve(
    float[](
        1.25,1.42,1.32,1,1.11,0.48,0.27,0.16,0.09,0.05,0.11,0.12,0.36,0.92,2.4,
        1.68,1.2,0.52,0.33,0.16,0.6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    ),
    float[](
      0.08,0.07,0.07,0.06,0.06,0.05,0.05,0.04,0.03,
      0.02,0.02,0.02,0.04,0.08,0.1,0.07,0.05,
      0.03,0.04,0.04,0.04,0.04,0.04,0.03,
      0.03,0.03,0.03,0.03,0.03,0.02,0.02,0.02,
      0.02,0.02,0.02,0.01,0.01,0.01

    )
);
const K_S_Curve BLUE = K_S_Curve(
    float[](
        0.32,0.13,0,0,0,0,0,0,0,0,0,0,0,0.11,0.32,0.73,1.77,2.71,2.89,3.07,
        3.25,3.43,3.61,3.61,3.61,3.61,3.61,2.93,0.64,0.21,0.07,0,0,0,0,0,0,0
    ),
    float[](
        0.2,0.1,0,0,0,0,0,0,0,0,0,0,0,0.06,0.12,0.18,0.24,0.3,0.32,0.34,0.36,
        0.38,0.4,0.4,0.4,0.4,0.4,0.33,0.25,0.18,0.1,0,0,0,0,0,0,0
    )
);

const K_S_Curve YELLOW = K_S_Curve(
    float[](
       0.9,0.16,0.11,0.09,0.08,0.06,
       0.05,0.04,0.05,0.05,0.04,0.04,0.04,
       0.02,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
       0.01,0.01,0.01,0.01,0.01,0.01,0.01

    ),
    float[](
      0.1,0.1,0.1,0.1,0.1,0.1,0.1,
      0.1,0.15,0.25,0.3,0.4,0.4,0.55,
      0.62,0.65,0.7,0.72,0.75,0.72,
      0.72,0.72,0.7,0.69,0.68,0.67,0.66,
      0.64,0.63,0.62,0.61,0.6,0.55,0.52,0.49,0.46,0.43,0.4

    )
);

const K_S_Curve BLACK = K_S_Curve(
    float[](
        13.82,8.06,4.61,4.61,4.61,4.8,4.99,5.18,5.38,5.57,5.76,5.95,6.14,
        6.34,6.53,6.72,6.91,7.1,7.3,7.49,7.68,7.87,8.06,8.26,8.45,8.64,
        8.83,9.02,9.22,9.41,9.6,9.79,9.98,10.18,10.37,10.56,10.75,10.94
    ),
    float[](
        1.2,0.7,0.4,0.4,0.4,0.42,0.43,0.45,0.47,0.48,0.5,0.52,0.53,0.55,
        0.57,0.58,0.6,0.62,0.63,0.65,0.67,0.68,0.7,0.72,0.73,0.75,0.77,
        0.78,0.8,0.82,0.83,0.85,0.87,0.88,0.9,0.92,0.93,0.95
    )
);

float reflectance_mix(float ks) {
    return 1.0 + ks - sqrt(ks * ks + 2.0 * ks);
}

float saunderson_mix(float ks) {
    float R = reflectance_mix(ks);
    return ((1.0 - K1) * (1.0 - K2) * R ) / (1.0 - K2 * R);
}

vec3 rgb_to_srgb(float r, float g, float b) {
    return vec3(pow(r, 1.0/2.2), pow(g, 1.0/2.2), pow(b, 1.0/2.2));
}

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

K_S_Curve mix_pigments(K_S_Curve first_pigment, K_S_Curve second_pigment, float mix_factor) {
    float conc1 = 1.0 - mix_factor;
    float conc2 = mix_factor;

    K_S_Curve result_pigment;

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

vec3 pigment_to_srgb(K_S_Curve pigment) {
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