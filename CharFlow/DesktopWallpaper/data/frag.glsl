#ifdef GL_ES
precision highp float;
#endif

#define INVADERS 1

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec3 color = vec3(0.2, 0.42, 0.68);

float width = 32.0; // n = 512/32 = 16

float rand(float x) { return fract(sin(x) * 4358.5453); }

// 二元随机函数
float rand(vec2 co) {
  return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 3758.5357);
}

#ifdef INVADERS
// 火星文算法
float invader(vec2 p, float n) {
  p.x = abs(p.x);
  p.y = floor(p.y - 5.0);

  float tmp = exp2(floor(p.x - 3.0 * p.y));

  return step(p.x, 2.0) * step(1.0, floor(mod(n / tmp, 2.0)));
}
#endif

void main() {

  vec2 p = gl_FragCoord.xy;
  vec2 uv = p / u_resolution.xy - 0.5;

  float id1 = rand(floor(p.x / width)); // 影响当前像素（矩形内）的颜色
  float id2 = rand(floor((p.x - 1.0) / width)); // 影响其邻近左侧像素的颜色

  float a = 0.3 * id1; // 当前矩形的颜色
  a += 0.1 *
       step(id2, id1 - 0.08); // 矩形左边界（如果当前像素比左侧淡，则亮边界）
  a += 0.1 *
       step(id1 + 0.8, id2); // 矩形右边界（如果当前像素比左侧深，则亮边暗）
  a -= 0.3 * smoothstep(0.0, 0.7, length(uv)); // 渐变效果）
#ifdef INVADERS
  p.y += 20.0 * u_time;           // 下落的速度
  float r = rand(floor(p / 8.0)); // 控制火星文和光环的随机闪烁

  float inv = invader(mod(p, 8.0) - 4.0, 809999.0 * r);
  a += (0.6 * max(0.0, 0.2 * sin(10.0 * r * u_time))) * inv * step(id1, 0.3);// 分段显示invaders
#endif

  gl_FragColor = vec4(color + vec3(a), 1.0);
}
