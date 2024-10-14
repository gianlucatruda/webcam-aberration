# Aberration: webcam shader art

[<img alt="Made with love at the Recurse Center" src="https://cloud.githubusercontent.com/assets/2883345/11325206/336ea5f4-9150-11e5-9e90-d86ad31993d8.png" height="20">](https://www.recurse.com/)

https://github.com/user-attachments/assets/bd6888d7-6e0f-40d2-bb84-526bf90b1768

1. **Access the Webcam Feed**: Use the `MediaDevices` API to capture the webcam feed.
2. **Create a Video Element**: Stream the webcam feed into a hidden HTML `<video>` element.
3. **Create a Texture from the Video**: In WebGL, create a texture that will hold the current frame of the video.
4. **Update the Texture Each Frame**: In your render loop, update the texture with the latest frame from the video.
5. **Pass the Texture to the Shader**: Use a `sampler2D` uniform in your fragment shader to access the texture data.
6. **Render the Scene**: Draw your scene, using the texture data in your shader as needed.

