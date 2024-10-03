console.log("Main.js");

async function fetchShader(url) {
	const res = await fetch(url);
	return await res.text();
}

const W = 500;
const H = 500;
const canvas = document.getElementById('myCanvas');
canvas.width = W;
canvas.height = H;
const gl = canvas.getContext('webgl');
const vertexShaderSource = await fetchShader('vertexShader.glsl');
const fragmentShaderSource = await fetchShader('fragmentShader.glsl');

// Shader creation function as in previous example
const vertexShader = createShader(gl, gl.VERTEX_SHADER, vertexShaderSource);
const fragmentShader = createShader(gl, gl.FRAGMENT_SHADER, fragmentShaderSource);

const program = gl.createProgram();
gl.attachShader(program, vertexShader);
gl.attachShader(program, fragmentShader);
gl.linkProgram(program);
gl.useProgram(program);

// Proceed with additional setup like buffer creation and rendering as necessary
