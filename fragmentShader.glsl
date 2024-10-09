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

    vec3 thresh = vec3(R, G, B);
    fragColor = vec4(thresh, 1.0);
}

void main() {
    mainImage(gl_FragColor, gl_FragCoord.xy);
}
