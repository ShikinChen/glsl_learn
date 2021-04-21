#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float triangle(in vec2 p0, in vec2 p1, in vec2 p2, in vec2 p) {

  // 三角形三条边的向量（顺时针）
  vec2 e0 = p1 - p0;
  vec2 e1 = p2 - p1;
  vec2 e2 = p0 - p2;
  // 三角形三个顶点到p点的向量
  vec2 v0 = p - p0;
  vec2 v1 = p - p1;
  vec2 v2 = p - p2;

  /// p点到三条边的距离向量
  // clamp: min(max(x, minVal), maxVal),返回值被限定在 minVal,maxVal之间
  // dot 返回x y的点积
  vec2 pq0 = v0 - e0 * clamp(dot(v0, e0) / dot(e0, e0), 0.0, 1.0);
  vec2 pq1 = v1 - e1 * clamp(dot(v1, e1) / dot(e1, e1), 0.0, 1.0);
  vec2 pq2 = v2 - e2 * clamp(dot(v2, e2) / dot(e2, e2), 0.0, 1.0);

  // p点到最近的边的距离，通过叉乘判断p点在三角形内（+）还是三角形外（-）
  vec2 d = min(min(vec2(dot(pq0, pq0), v0.x * e0.y - v0.y * e0.x),
                    vec2(dot(pq1, pq1), v1.x * e1.y - v1.y * e1.x)), 
                    vec2(dot(pq2, pq2), v2.x * e2.y - v2.y * e2.x));
  // 返回最近的距离
  return -sqrt(d.x) * sign(d.y);
}

void main() {

  vec2 p = (2.0 * gl_FragCoord.xy - u_resolution.xy) / u_resolution.y;

  // 顺时针方向
  vec2 v1 = cos(u_time + vec2(0.0, 1.57) + 0.0);
  vec2 v2 = cos(u_time + vec2(0.0, 1.57) + 2.0);
  vec2 v3 = cos(u_time + vec2(0.0, 1.57) + 4.0);

  float d = triangle(v1, v2, v3, p);

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
