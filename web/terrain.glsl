#define time_divamt 30000.0
precision mediump float;
uniform float grid_spacing;
uniform vec2 offset;
uniform vec2 resolution;
varying vec3 color;
uniform vec2 playerPos;
uniform vec2 toplefttile;
uniform float waterMax;
uniform float sandMax;
uniform float dirtMax;
uniform float grassMax;
uniform float stoneMax;
uniform float snowMax;
uniform float time;
uniform vec2 cursorPos;
uniform float frequency;
uniform float amplitude;
uniform float persistence;
uniform float lacunarity;
uniform int octaves;
uniform float scale; // Add scale as a uniform to control zoom level
uniform float seed; // Add seed as a uniform to influence noise generation

vec4 permute(in vec4 x) {return mod(((x * 34.0) + 1.0) * x, 289.0);}
vec4 taylorInvSqrt(in vec4 r) {return 1.79284291400159 - 0.85373472095314 * r;}

vec3 simple_tile_color(vec2 _coord, float n) {
    vec3 color;
    if (n < waterMax) {
        // Water
        color = vec3(20.0 / 255.0, 24.0 / 255.0, 34.0 / 255.0); // Darker deep water color
    } else if (n < sandMax) {
        // Sand 
        color = vec3(0.95, 0.87, 0.70); // Lighter sand color
    } else if (n < dirtMax) {
        // Dirt
        color = vec3(164.0 / 255.0, 158.0 / 255.0, 130.0 / 255.0); // Lightest dirt color
    } else if (n < grassMax) {
        // Grass
        color = vec3(48.0 / 255.0, 71.0 / 255.0, 40.0 / 255.0); // Darkest grass color
    } else if (n < stoneMax) {
        // Stone
        color = vec3(144.0 / 255.0, 144.0 / 255.0, 144.0 / 255.0); // Lightest stone color
    } else {
        // Snow
        color = vec3(1.0, 1.0, 1.0); // Lighter snow color
    }
    return color;
}

vec3 hash(vec3 p) {
    p = vec3(dot(p, vec3(127.1, 311.7, 74.7)), 
             dot(p, vec3(269.5, 183.3, 246.1)),
             dot(p, vec3(113.5, 271.9, 101.5)));
    return -1.0 + 2.0 * fract(sin(p) * 43758.5453);
}

float smootherNoise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);

    vec3 g00 = hash(vec3(i.x, i.y, 0.0));
    vec3 g10 = hash(vec3(i.x + 1.0, i.y, 0.0));
    vec3 g01 = hash(vec3(i.x, i.y + 1.0, 0.0));
    vec3 g11 = hash(vec3(i.x + 1.0, i.y + 1.0, 0.0));

    float n00 = dot(g00.xy, f - vec2(0.0, 0.0));
    float n10 = dot(g10.xy, f - vec2(1.0, 0.0));
    float n01 = dot(g01.xy, f - vec2(0.0, 1.0));
    float n11 = dot(g11.xy, f - vec2(1.0, 1.0));

    float nX0 = mix(n00, n10, u.x);
    float nX1 = mix(n01, n11, u.x);
    return mix(nX0, nX1, u.y);
}

float configurableNoise(vec2 p, float frequency, float amplitude) {
    return smootherNoise(p * frequency) * amplitude;
}

void main() {
    vec2 coord1 = gl_FragCoord.xy;
    vec2 coord = (((coord1/grid_spacing) - toplefttile) * grid_spacing) - offset;
    vec2 _coord = coord / grid_spacing;
    _coord -= resolution * 1.0 / grid_spacing;
    
    // Create basic black/white tiles
    // vec3 color = mod(floor(_coord.x) + floor(_coord.y), 2.0) > 0.5 ? vec3(1.0, 1.0, 1.0) : vec3(0.0, 0.0, 0.0);

    // Create noise-based terrain
    float n = configurableNoise(_coord, frequency, amplitude);
    
    // If cursorPos in 10 radius, disturb the noise
    float distance = distance(vec2(cursorPos.x, resolution - cursorPos.y), gl_FragCoord.xy);
    if (distance < 10.0) {
        n += sin(distance) * 0.9;
    }
    vec3 color = simple_tile_color(_coord, n);

    // Add gridlines
    //float gridLineThickness = 0.01; // Adjust thickness as needed
    //vec3 gridLineColor = vec3(1.0, 1.0, 1.0); // Set gridline color (white in this case)
    //if(mod(_coord.x, 1.0) < gridLineThickness || mod(_coord.y, 1.0) < gridLineThickness) {
    //    color = gridLineColor;
    //}

    
    gl_FragColor = vec4(color, 1.0);
}