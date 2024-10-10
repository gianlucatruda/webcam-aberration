precision lowp float;

uniform vec2 iResolution; // viewport resolution (in pixels)
uniform float iTime; // shader playback time (in seconds)
uniform vec2 iMouse; // mouse pixel coords. xy: current (if MLB down), zw: click
uniform sampler2D u_texture; // Texture passed in from the webcam feed

const float PI = 3.14159265359;

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

    float r0 = tex.r;
    float g0 = tex.g;
    float b0 = tex.b;

    float t = sin(PI * iTime);

    float cTotal = R + G + B;
    float cAvg = cTotal / 3.0;
    float cMin = min(min(R, G), B);
    float cMax = max(max(R, G), B);
    float thresh = min(cAvg, 0.7);
    float eps = 0.0001;

    R = smoothstep(cMin + eps, thresh, R);
    G = smoothstep(cMin + eps, thresh, G);
    B = smoothstep(cMin + eps, thresh, B);

    vec3 cCam = vec3(R, G, B);
    vec3 cOut = vec3(.0);

    // float x2 = sin(d * 3.0 + iTime) / 4.0;
    for (float i = 0.0; i < 5.0; i++) {
        uv = fract(uv * 1.618) - 0.5;
        float d = length(uv) * exp(-length(uv0));
        float x1 = sin(d * 4.0 + iTime + R) / (2. * r0);
        cOut += cCam * pow(0.1 / (abs(length(uv0) + x1 + B + i)), 2.0);
    }
    fragColor = vec4(cOut, 1.0);
    fragColor[0] += cMax - cMin;
    fragColor[1] += cMax - cAvg;
    fragColor[2] += 0.5 * thresh;
    // fragColor = vec4(cCam, 1.0);
}

void main() {
    mainImage(gl_FragColor, gl_FragCoord.xy);
}
