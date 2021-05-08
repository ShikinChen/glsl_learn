#ifdef GL_ES
precision highp float;
#endif

// attributes, in
layout(location=0)in vec4 position;
layout(location=1)in vec2 texCoord;

// attributes, out
out vec2 v_texCoord;
out mat4 v_transform;
out vec4 v_position;

// matrices
uniform mat4 transform;

void main()
{
    v_position=transform*position;
    gl_Position=v_position;
    v_texCoord=texCoord;
    v_transform=transform;
}