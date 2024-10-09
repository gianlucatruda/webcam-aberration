precision mediump float;

uniform vec2 iResolution; // viewport resolution (in pixels)
uniform float iTime; // shader playback time (in seconds)
uniform vec2 iMouse; // mouse pixel coords. xy: current (if MLB down), zw: click

uniform sampler2D u_texture;

vec3 palette(float t) {
    //https://iquilezles.org/articles/palettes/
    vec3 a = vec3(0.1, 0.1, 0.1);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.0, 0.33, 0.67);

    return a + b * cos(6.28318 * (c * t + d));
}

// Tutorial: https://youtu.be/f4s1h2YETNY
// Based on https://www.shadertoy.com/view/mtyGWy
void mainImage(out vec4 fragColor, in vec2 fragCoord) {

    // Resolution on interval [-1, 1] works on any canvas size and shape
    // iResolution.xy uses "swizzling" to construct a vec2 in specified order
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    // Original origin of the canvas
    vec2 uv0 = uv;

    // // Initialise for black
    // vec3 finalColor = vec3(0.0);

    //
    // // For loops that use fract(uv) give a fractal effect
    // for (float i = 0.0; i < 4.0; i++) {
    //     uv = fract(uv * 1.619) - 0.5;
    //
    //     float d = length(uv) * exp(length(uv0));
    //     vec3 col = palette(length(uv0) - i * 0.1 - iTime * 0.9);
    //     d = sin(d * 5.0 + iTime) / 5.0;
    //     d = abs(d);
    //     d = pow(0.01 / d, 1.9);
    //
    //     finalColor += col * d;
    // }
    //
    // fragColor = vec4(finalColor, 1.0); // alpha is often ignored

    // vec2 uv = vTexCoord;
    // the texture is loaded upside down and backwards by default so lets flip it
    // uv.y = 1.0 - uv.y;

    vec4 tex = texture2D(u_texture, uv);
    float gray = (tex.r + tex.g + tex.b) / 3.0;
    // float res = 20.0;
    // float scl = res / (10.0);
    //
    float R = tex.r;
    float G = tex.g;
    float B = tex.b;
    //
    // R = fract(R * iFrame);
    //
    // // // float threshR = (fract(floor(tex.r*res)/scl)*scl) * gray ;
    // // float threshR = fract(tex.r * iFrame) * gray ;
    // // float threshG = tex.g; //(fract(floor(tex.g*res)/scl)*scl) * gray ;
    // // float threshB = tex.g; //(fract(floor(tex.b*res)/scl)*scl) * gray ;
    //
    vec3 thresh = vec3(R, G, B);
    //
    // // render the output
    // fragColor = vec4(thresh, 1.0);
    fragColor = vec4(thresh, 1.0);
}

void main() {
    mainImage(gl_FragColor, gl_FragCoord.xy);
}
