#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float a = 1.0;
float b = 3.0;
float r = 0.9 + 0.1 * sin(3.1415927 * u_time);
float e = 2.0 / u_resolution.y;
// f(x,y) 直接 SDF 的方式绘制椭圆 (左上)
float ellipse1(vec2 p) {
  float f = length(p * vec2(a, b));
  f = abs(f - r);
  return f;
}
// f(x,y) 除以解析解出的梯度 (右上)
float ellipse2(vec2 p) {
  float f = length(p * vec2(a, b));
  return abs(f - r) * f / (length(p * vec2(a * a, b * b)));
}
// f(x,y) 除以 GPU 计算的数值梯度 (左下)
float ellipse3(vec2 p) {
  float f = ellipse1(p);
  float g = length(vec2(dFdx(f), dFdy(f)) / e);
  return f / g;
}
// f(x,y) 除以手动计算的数值梯度 (右下)
float ellipse4(vec2 p) {
  float f = ellipse1(p);
  float g =
      length(vec2(ellipse1(p + vec2(e, 0.0)) - ellipse1(p - vec2(e, 0.0)),
                  ellipse1(p + vec2(0.0, e)) - ellipse1(p - vec2(0.0, e)))) /
      (2.0 * e);
  return f / g;
}

void main() {
  // 坐标范围[-1., 1.]，中心为(0. 0)
  vec2 uv = (2.0 * gl_FragCoord.xy - u_resolution.xy) / u_resolution.xy;
  float f1 = ellipse1(uv);
  float f2 = ellipse2(uv);
  float f3 = ellipse3(uv);
  float f4 = ellipse4(uv);

  vec3 col = vec3(0.3);
  // 将 uv 坐标分为四个区间，绘制椭圆
  // f1, f2
  // f3, f4
  float f = mix(mix(f1, f2, step(0.0, uv.x)), mix(f3, f4, step(0.0, uv.x)),
                step(uv.y, 0.0));
  // 通过 smoothstep 将 f ∈[0., 0.11) 表示在椭圆内；椭圆线宽为 0.11
  col = mix(col, vec3(0.4, 0.6, 0.2), 1.0 - smoothstep(0.1, 0.11, f));

  // 四个区间的分割线： abs(uv.x)在 (0-e) 之间为黑色，在 (2.0*e, 1.)
  // 为白色，中间为插值色
  col *= smoothstep(e, 2.0 * e, abs(uv.x)); //黑色线宽为 2.*e
  col *= smoothstep(e, 2.0 * e, abs(uv.y));

  gl_FragColor = vec4(col, 1.0);
}
