#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

uniform sampler2D u_img;

in vec2 v_texCoord;
in vec4 v_position;
in mat4 v_transform;

uniform mat3 G[2] =
    mat3[](mat3(1.0, 2.0, 1.0, 0.0, 0.0, 0.0, -1.0, -2.0, -1.0),
           mat3(1.0, 0.0, -1.0, 2.0, 0.0, -2.0, 1.0, 0.0, -1.0));

void main() {
  mat3 I;
  float cnv[2];
  vec3 s_img;
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      s_img =
          texelFetch(u_img,
                     ivec2(v_texCoord * u_resolution) + ivec2(i - 1, j - 1), 0)
              .rgb;
      I[i][j] = length(s_img);
    }
  }

  for (int i = 0; i < 2; i++) {
    float dp3 = dot(G[i][0], I[0]) + dot(G[i][1], I[1]) + dot(G[i][2], I[2]);
    cnv[i] = dp3 * dp3;
  }
  gl_FragColor = vec4(0.5 * sqrt(cnv[0] * cnv[0] + cnv[1] * cnv[1]));
}