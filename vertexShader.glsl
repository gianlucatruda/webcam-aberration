attribute vec2 a_position;
void main() {
    // Passes on the fullscreen quad coordinates directly
    gl_Position = vec4(a_position, 0.0, 1.0);
}
