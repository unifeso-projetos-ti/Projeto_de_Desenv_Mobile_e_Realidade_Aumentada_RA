#version 300 es

precision mediump float;

in vec2 v_TexCoord;
uniform sampler2D u_Texture;

out vec4 fragColor;

void main() {
    vec4 texColor = texture(u_Texture, v_TexCoord);
    if (texColor.a < 0.1) {
        discard; // Transparente
    }
    fragColor = texColor;
} 