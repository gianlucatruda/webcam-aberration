precision mediump float;
uniform vec2 u_resolution;
uniform float u_time;

void main() {
    // Calculate normalized texture coordinates
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;

    // Generate some example color based on position and time, creating a moving color pattern
    vec3 col = 0.5 + 0.5 * cos(u_time + uv.xyx + vec3(0, 2, 4));

    // Output to the screen
    gl_FragColor = vec4(col, 1.0);
}
