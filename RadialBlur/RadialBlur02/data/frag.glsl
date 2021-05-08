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

const float PI = 3.14159265;
float uR = 0.2;

void main() {
  ivec2 ires = textureSize(u_img, 0);
  vec2 res = vec2(ires);

  vec2 st = v_texCoord;
  float radius = res.x * uR;
  vec2 xy = res * st;

  vec2 dxy = xy - vec2(res.x / 2.0, res.y / 2.0);
  float r = length(dxy);

  vec4 color = vec4(0.0);
  if (r <= radius) {
    float angle = atan(dxy.y, dxy.x);
    int num = 40;
    for (int i = 0; i < num; i++) {
      int int_r = int(r);
      int tmpR = (int_r - i) > 0 ? (int_r - i) : 0;

      int newX = int(float(tmpR) * cos(angle) + res.x / 2.0);
      int newY = int(float(tmpR) * sin(angle) + res.y / 2.0);

      int int_res = int(res.x);
      if (newX < 0) {
        newX = 0;
      }
      if (newX > int_res - 1) {
        newX = int_res - 1;
      }
      int_res = int(res.y);
      if (newY < 0) {
        newY = 0;
      }
      if (newY > int_res - 1) {
        newY = int_res - 1;
      }

      color += texture2D(u_img, vec2(newX, newY) / vec2(ires));
    }

    color /= float(num);
  } else {
    color = texture2D(u_img, st);
  }

  gl_FragColor = color;
}