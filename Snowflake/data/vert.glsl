#ifdef GL_ES
precision highp float;
#endif

// attributes, in
layout(location=0)in vec4 position;
layout(location=1)in vec2 texCoord;

// attributes, out
out vec2 v_texCoord;

// matrices
uniform mat4 transform;

void main()
{
    gl_Position=transform*position;
    v_texCoord=texCoord;
}