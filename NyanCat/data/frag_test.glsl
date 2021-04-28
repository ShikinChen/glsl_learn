#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

uniform sampler2D u_img;
uniform sampler2D u_bg;

in vec2 v_texCoord;
in vec4 v_position;
in mat4 v_transform;


void main() {
  vec2 p = v_texCoord.xy;
  // 背景滚动的uv
  vec2 uv = vec2(p.x + mod(u_time, 2.0), p.y);
  vec3 bg = vec3(0.0, 51.0 / 255.0, 102.0 / 255.0);
  float f = texture2D(u_bg, uv).x;
  f = f * f;
  bg = mix(bg, vec3(1.0), f);

  float a = 0.01 * sin(40.0 * p.x + 40.0 * u_time);
  float h = (a + p.y - 0.3) / (0.7 - 0.3);
  // 彩虹的位置
  if (p.x < 0.6 && h > 0.0 && h < 1.0) {
    // 彩虹的宽度
    h = floor(h * 6.0);
    // 在不同高度绘制彩虹
    bg = mix(bg, vec3(1.0, 0.0, 0.0), 1.0 - smoothstep(0.0, 0.1, abs(h - 5.0)));
    bg = mix(bg, vec3(1.0, 0.6, 0.0), 1.0 - smoothstep(0.0, 0.1, abs(h - 4.0)));
    bg = mix(bg, vec3(1.0, 1.0, 0.0), 1.0 - smoothstep(0.0, 0.1, abs(h - 3.0)));
    bg = mix(bg, vec3(0.2, 1.0, 0.0), 1.0 - smoothstep(0.0, 0.1, abs(h - 2.0)));
    bg = mix(bg, vec3(0.0, 0.6, 1.0), 1.0 - smoothstep(0.0, 0.1, abs(h - 1.0)));
    bg = mix(bg, vec3(0.4, 0.2, 1.0), 1.0 - smoothstep(0.0, 0.1, abs(h - 0.0)));
  }
  // 重新计算uv，比例和位置的调整
  uv = (p - vec2(0.33, 0.15)) / (vec2(1.3, 1.) - vec2(0.33, 0.15));
  uv = clamp(uv, 0.0, 1.0);

  // 控制彩虹猫图像的偏移, floor很重要
  float ofx = floor(mod(u_time * 10.0 * 2.0, 6.0));

  // 单只彩虹猫的纹理大小 (uv offset)
  float ww = 31.0 / 200.0;
  // uv.y = 1.0-uv.y;
  // 将偏移后的uv换算到单只彩虹猫的纹理大小，否则会把之后的彩虹猫一并显示出来
  uv.x = clamp((uv.x + ofx) * ww, 0.0, 1.0);

  // vec4 fg = texture2D(u_img, uv);

  // vec3 col = mix(bg, fg.xyz, .8);

  gl_FragColor = vec4(bg, 1.0);
}