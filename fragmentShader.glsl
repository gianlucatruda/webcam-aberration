precision mediump float;

uniform vec2 iResolution; // viewport resolution (in pixels)
uniform float iTime; // shader playback time (in seconds)
uniform vec2 iMouse; // mouse pixel coords. xy: current (if MLB down), zw: click
uniform sampler2D u_texture; // Texture passed in from the webcam feed

void mainImage(out vec4 fragColor, in vec2 fragCoord) {

    // Resolution on interval [-1, 1] works on any canvas size and shape
    // iResolution.xy uses "swizzling" to construct a vec2 in specified order
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    float aspectRatio = iResolution.x / iResolution.y;
    // Original origin of the canvas
    vec2 uv0 = uv;

    // the texture is loaded upside down and backwards by default so lets flip it
    uv.y = -0.5 * uv.y + 0.5;
    uv.x = -0.5 / aspectRatio * uv.x + 0.5;
    vec4 tex = texture2D(u_texture, uv);

    // Extract colour channels from camera feed texture
    float R = tex.r;
    float G = tex.g;
    float B = tex.b;

    float d = length(uv) * exp(-length(uv0));
    float t = abs(sin(d * 4.0 + 1.0 * iTime) / 2.0);
    // R = -pow(R, d*t);
    // G = 0.1 / ((2.0 * G) - R + d*t) - t;
    // G *= pow(R+G+B, t/.1);
    // G = (3.0 * R)-G-B;
    // G = (R+G+B)/3.0;
    float total = R + G + B;
    float cMin = min(min(R, G), B);
    float thresh = min((total / 3.0) * 1.0, 0.8);
    R = smoothstep(cMin, thresh, R);
    G = smoothstep(cMin, thresh, G);
    B = smoothstep(cMin, thresh, B);
    // B = 0.5/(B + 2.0*t - 0.1);
    // B = - pow(B, d);
    // B *= pow(d, t);

    // R = 0.1;
    // G = 0.1;
    // B = 0.1;

    // R = pow(2.0 * (G - R), t);
    // G = pow(G, t);
    // B = pow((R + G), t);

    fragColor = vec4(R, G, B, 1.0);
}

void main() {
    mainImage(gl_FragColor, gl_FragCoord.xy);
}
