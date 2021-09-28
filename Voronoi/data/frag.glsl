#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

// 随机方法
vec2 hash(vec2 p) {
  p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
  return fract(sin(p) * 18.5453);
}

vec2 voronoi(in vec2 x) {
  vec2 n = floor(x);
  //当前像素在 cell space 的坐标
  vec2 f = fract(x);
  //影响每个 cell 的大小，影响背景颜色
  vec3 m = vec3(8.0);

  // 遍历相邻的9个cell
  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {
      // 临近的 cell id 偏移量
      vec2 g = vec2(float(j), float(i));
      // n+g 临近的 cell(n+g) 的随机像素坐标 o (cell space)
      // 根据邻近的 cell id 进行随机，用于计算 cell 的颜色
      vec2 o = hash(n + g);
      vec2 r = g - f + (0.5 + 0.5 * sin(u_time + 6.2831 * o));
      // 计算上面的距离
      float d = dot(r, r);

      // 保存距离更小者，以及该 cell id 的随机值（用于计算 cell颜色）
      if (d < m.x) {
        m = vec3(d, o);
      }
    }
  }
  return vec2(sqrt(m.x), m.y + m.z);
}

void main() {

  vec2 p = gl_FragCoord.xy / max(u_resolution.x, u_resolution.y);
  // 控制 cell 随着时间的放大缩小
  vec2 c = voronoi((14.0 + 6.0 * sin(0.2 * u_time)) * p);
  // cell 的随机颜色
  vec3 col = 0.5 + 0.5 * cos(c.y * 6.2831 + vec3(0.0, 1.0, 2.0));
  //给 cell 加上随着距离变大而加深的阴影
  col *= clamp(1.0 - 0.6 * c.x * c.x, 0.0, 1.0);
  //画 Voronoi 的 site 点集（cell 中间的圆点）
  col -= (1.0 - smoothstep(0.01, 0.06, c.x));
  gl_FragColor = vec4(col, 1.0);
}
