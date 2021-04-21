#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float circle(in vec2 p, in float r) { return length(p) - r; }

void main() {

  vec2 uv = -1.0 + 2.0 * gl_FragCoord.xy / u_resolution.xy;
  uv.x*=u_resolution.x/u_resolution.y;

  float d = circle(uv,0.5);

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
