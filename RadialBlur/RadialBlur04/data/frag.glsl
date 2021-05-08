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
float uR = 0.25;
float uD = 90.0;

void main() {
  ivec2 ires = textureSize(u_img, 0);
  vec2 res = vec2(ires);

  vec2 st = v_texCoord;
  float radius = res.x * uR;
  vec2 xy = res * st;

  vec2 dxy = xy - vec2(res.x / 2.0, res.y / 2.0);
  float r = length(dxy);
  // radians 角度转弧度
  float beta = atan(dxy.y, dxy.x) + radians(uD) * 2.0 * (radius - r) / radius;

  vec2 xy1 = xy;
  if (r <= radius) {
    xy1 = res / 2.0 + r * vec2(cos(beta), sin(beta));
  }
  st = xy1 / res;
  vec3 irgb = texture(u_img, st).rgb;

  gl_FragColor = vec4(irgb, 1.0);
}