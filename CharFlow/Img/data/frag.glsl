#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

in vec2 v_texCoord;

uniform sampler2D u_img;

vec3 color = vec3(0.6, 0.1, 0.3);
// 一元随机函数
float rand(float x) { return fract(sin(x) * 4358.5453123); }

// 二元随机函数
float rand(vec2 co) {
  return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5357);
}

// 火星文算法
float invader(vec2 p, float n) {
  p.x = abs(p.x);
  p.y = floor(p.y - 5.0);

  float tmp = exp2(floor(p.x - 3.0 * p.y));

  return step(p.x, 2.0) * step(1.0, floor(mod(n / tmp, 2.0)));
}

float ring(vec2 uv, float rnd) {
  float t = 0.6 * (u_time + 0.2 * rnd);
  float i = floor(t / 2.0); // 确保圆心在某时间范围内不变

  // 随机圆心位置
  vec2 pos = 2.0 * vec2(rand(i * 0.123), rand(i * 2.371)) - 1.0;
  // 动态放大半径：
  // length(uv - pos)表示圆，t在增大，需要更大的uv才使得 diff 为 0，
  // t有一定的随机性，可以实现圆环的闪烁效果
  float diff = length(uv - pos) - mod(t, 2.0);
  return 1.0 - smoothstep(0.0, 0.2, abs(diff));
}

void main() {

  if (u_mouse.x > 0.5) {
    color = vec3(0.2, 0.42, 0.68);
  }
  vec2 p = gl_FragCoord.xy;
  vec2 xy = gl_FragCoord.xy / u_resolution.xy;
  vec2 uv = p / u_resolution.xy - 0.5;

  p.y += 120.0 * u_time;          // 下落的速度
  float r = rand(floor(p / 8.0)); // 控制火星文和光环的随机闪烁

  // 用于生成火星文
  vec2 ip = mod(p, 8.0) - 4.0;
  // 背景中心到四周的颜色渐变
  float a = -0.2 * smoothstep(0.1, 0.8, length(uv));
  // invader * 光环
  float b = invader(ip, 809999.0 * r) * (0.06 + 0.3 * ring(uv, r));
  // 火星文雨的闪烁高光
  float c = invader(ip, 809999.0 * r) * max(0.0, 0.2 * sin(10.0 * r * u_time));
  a += b;
  a += c;
  vec3 img_color = texture2D(u_img, v_texCoord).rgb;
  float img_c = (img_color.r + img_color.g + img_color.b) / 3.0;
  gl_FragColor = vec4(vec3(img_c) + vec3(a), 1.0);
}
