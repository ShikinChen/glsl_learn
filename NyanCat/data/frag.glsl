#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform vec2 u_img_size;

uniform sampler2D u_img;
uniform sampler2D u_bg;

in vec2 v_texCoord;
in vec4 v_position;
in mat4 v_transform;
// in mat4 v_texMatrix;

void main() {
  vec2 p = v_texCoord;
  vec2 s = (v_transform * vec4(u_resolution, 0.0, 0.0)).xy / u_resolution.xy;
  // 背景滚动的uv
  vec2 uv = vec2(p.x * 0.5 + mod(u_time / 10, s.x * 0.25), p.y);
  vec3 bg = vec3(0.0, 51.0 / 255.0, 102.0 / 255.0);
  float f = texture2D(u_bg, uv).r;
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

  // 重新计算uv，比例,只能按640*640适配彩虹猫
  vec2 k = v_texCoord * u_resolution.xy / gl_FragCoord.xy;
  k += vec2(10.0, 0.0);
  float scale = 0.22;
  uv = (k * gl_FragCoord.xy / u_img_size.xy).xy * scale;
  //位置的调整
  uv -= vec2(4.4 * scale, 1.0 * scale);
  uv = clamp(uv, 0.0, 1.0);

  // // 控制彩虹猫图像的偏移, floor很重要
  float ofx = floor(mod(u_time * 10.0 * 2.0, 6.0));

  // // 单只彩虹猫的纹理大小 (uv offset)
  float ww = 31.0 / 200.0;

  // // 将偏移后的uv换算到单只彩虹猫的纹理大小，否则会把之后的彩虹猫一并显示出来
  uv.x = clamp((uv.x + ofx) * ww, 0.0, 1.0);

  vec4 fg = texture2D(u_img, uv);
  vec3 col = mix(bg, fg.rgb, fg.w);

  gl_FragColor = vec4(col, 1.0);
}