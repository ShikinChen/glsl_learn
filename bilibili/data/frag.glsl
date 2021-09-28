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

vec2 off = vec2(0.33, 0.15);

// 2233 娘一维图个数
const float FRMS = 7.0;

void main() {
  vec2 p = v_texCoord;

  vec2 s = (v_transform * vec4(u_resolution, 0.0, 0.0)).xy / u_resolution.xy;

  // 控制 2233 娘的上升的 uv
  float ofy = mod(u_time, abs(s.y)) * 0.5;
  vec2 uv = vec2(p.x, p.y + ofy);

  // uv = v_texCoord;

  // 控制切换到下一帧, floor 很重要
  float ofx = floor(mod(u_time * 20.0, FRMS));

  // 换算单帧 2233 娘的大小 比例 (uv scale)
  float ww = 1.0 / FRMS;

  // 将偏移后的 uv 换算到单只 2233 娘的位置，否则会把下一帧一并显示出来
  uv.x = (uv.x + ofx) * ww;

  vec4 fg = texture2D(u_img, uv);

  gl_FragColor = vec4(mix(vec3(0.9), fg.xyz, fg.a), 1.0);
}