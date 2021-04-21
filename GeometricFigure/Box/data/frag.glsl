#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float box(in vec2 p, in vec2 b, in float r) {
  vec2 q = abs(p) - b;

  // 同时计算 q.x q.y 的大值和小值
  vec2 m = vec2(min(q.x, q.y), max(q.x, q.y));

  // @note q.x, q.y 都大于 0 则计算平方根距离，否则取 q.x, q.y 中的大值作为距离
  float d = (m.x > 0.0) ? length(q) : m.y;

  return length(max(q, 0.)) + ///< 直角矩形, 但内部距离还是 0
       min(max(q.x, q.y), 0.); ///< 内部为负的距离;
}

void main() {

  vec2 p = (2.0 * gl_FragCoord.xy - u_resolution.xy) / u_resolution.y;

  vec2 ra = 0.4 + 0.3 * sin(u_time + vec2(0.0, 1.57));
  float d = box(p, ra, 0.2);

  // sign比较x与0的值,大于,等于,小于 分别返回 1.0 ,0.0,-1.0
  // 根据d的符号，设置不同的颜色（矩形内部为白色，矩形外部为黄色）
  vec3 col = vec3(1.0) - sign(d) * vec3(0.1, 0.4, 0.7);

  // 增强颜色对比度
  col *= 1.0 - exp(-2.0 * abs(d));
  // 波纹效果
  col *= 0.8 + 0.2 * cos(120.0 * d);

  // 白色边界，大约0 .02宽
  col = mix(col, vec3(1.0), 1.0 - smoothstep(0.0, 0.02, abs(d)));

  gl_FragColor = vec4(col, 1.0);
}
