precision mediump float;

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

    float t = sin(PI * iTime);

    // R = -pow(R, d*t);
    // G = 0.1 / ((2.0 * G) - R + d*t) - t;
    // G *= pow(R+G+B, t/.1);
    // G = (3.0 * R)-G-B;
    // G = (R+G+B)/3.0;
    float cTotal = R + G + B;
    float cAvg = cTotal / 3.0;
    float cMin = min(min(R, G), B);
    float cMax = max(max(R, G), B);
    float thresh = min(cAvg, 0.7);
    float eps = 0.0001;

    // R = d + t;
    // G = d + t;
    // B = d + t;

    R = smoothstep(cMin + eps, thresh, R);
    G = smoothstep(cMin + eps, thresh, G);
    B = smoothstep(cMin + eps, thresh, B);

    // B = 0.5/(B + 2.0*t - 0.1);
    // B = - pow(B, d);
    // B *= pow(d, t);

    // R = 0.1;
    // G = 0.1;
    // B = 0.1;

    // R = pow(2.0 * (G - R), t);
    // G = pow(G, t);
    // B = pow((R + G), t);

    vec3 cCam = vec3(R, G, B);
    vec3 cOut = vec3(.0);

    // float x2 = sin(d * 3.0 + iTime) / 4.0;
    for (float i = 0.0; i < 4.0; i++) {
        uv = fract(uv * 1.5) - 0.5;
        float d = length(uv) * exp(-length(uv0));
        float x1 = sin(d * 10.0 + iTime + cCam[0] + cCam[1] + cCam[2]) / 1.0;
        cOut += cCam * pow(0.01 / (abs(length(uv0) + x1 + 0.4 * i)), 1.2);
        // cOut[1] += abs(length(uv0) + x2);
        // cOut[2] += fract(length(uv0) + x1 * -x2);

        // cOut += pow(d * t, 2.0) - pow(d - t, 3.0);
    }
    fragColor = vec4(cOut, 1.0);
    // fragColor = vec4(tex.r, tex.g, tex.b, 1.0);
}

void main() {
    mainImage(gl_FragColor, gl_FragCoord.xy);
}
