console.log("Main.js");

window.addEventListener('resize', () => {
	init(); // You may want to turn some functionalities in init into a separate resize function
});
async function fetchShader(url) {
	const res = await fetch(url);
	if (!res.ok) {
		throw new Error(`Failed to fetch shader: ${res.statusText}`);
	}
	return await res.text();
}

async function init() {
	const canvas = document.getElementById('myCanvas');
	const gl = canvas.getContext('webgl');
	if (!gl) {
		alert('WebGL not supported by this browser.');
		return;
	}

	// Adjust for high DPI devices
	let dpi = window.devicePixelRatio;
	let style_height = +getComputedStyle(canvas).getPropertyValue("height").slice(0, -2);
	let style_width = +getComputedStyle(canvas).getPropertyValue("width").slice(0, -2);
	// Scale the canvas by the device pixel ratio, maintaining the aspect ratio.
	canvas.setAttribute('width', style_width * dpi);
	canvas.setAttribute('height', style_height * dpi);
	const vertexShaderSource = await fetchShader('vertexShader.glsl');
	const fragmentShaderSource = await fetchShader('fragmentShader.glsl');

	function createShader(gl, type, source) {
		const shader = gl.createShader(type);
		gl.shaderSource(shader, source);
		gl.compileShader(shader);
		if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
			console.error(`An error occurred compiling the shaders: ${gl.getShaderInfoLog(shader)}`);
			gl.deleteShader(shader);
			return null;
		}
		return shader;
	}

	const vertexShader = createShader(gl, gl.VERTEX_SHADER, vertexShaderSource);
	const fragmentShader = createShader(gl, gl.FRAGMENT_SHADER, fragmentShaderSource);

	const program = gl.createProgram();
	gl.attachShader(program, vertexShader);
	gl.attachShader(program, fragmentShader);
	gl.linkProgram(program);
	if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
		console.error(`Unable to initialize the shader program: ${gl.getProgramInfoLog(program)}`);
		gl.deleteProgram(program);
		return;
	}
	gl.useProgram(program);

	const vertexBuffer = gl.createBuffer();
	gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
	const vertices = new Float32Array([
		-1.0, -1.0,
		1.0, -1.0,
		-1.0, 1.0,
		1.0, 1.0
	]);
	gl.bufferData(gl.ARRAY_BUFFER, vertices, gl.STATIC_DRAW);

	const positionAttributeLocation = gl.getAttribLocation(program, 'a_position');
	gl.enableVertexAttribArray(positionAttributeLocation);
	gl.vertexAttribPointer(positionAttributeLocation, 2, gl.FLOAT, false, 0, 0);

	// Shadertoy variable names
	const resolutionUniformLocation = gl.getUniformLocation(program, 'iResolution');
	gl.uniform2f(resolutionUniformLocation, canvas.width, canvas.height);
	const timeUniformLocation = gl.getUniformLocation(program, 'iTime');
	const mouseUniformLocation = gl.getUniformLocation(program, 'iMouse');

	function render(time) {
		gl.viewport(0, 0, canvas.width, canvas.height);
		gl.uniform1f(timeUniformLocation, time * 0.001);  // time in seconds
		gl.clearColor(0.0, 0.0, 0.0, 1.0);
		gl.clear(gl.COLOR_BUFFER_BIT);
		gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);
		requestAnimationFrame(render);
	}

	requestAnimationFrame(render);
}

window.onload = init;
