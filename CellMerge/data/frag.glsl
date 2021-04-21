#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec3 color_bg = vec3(0.0);
vec3 color_inner = vec3(1.0, 0.9, 0.16);

vec3 color_outer = vec3(0.12, 0.59, 0.21);

float timeScale = 1.0;
float mapScale = 0.8;

#define cellCount 20.0

vec2 cellSize = vec2(30.0, 40.0);

vec3 powerToColor(vec2 power) {
  // 控制颜色平滑程度
  float tMax = pow(1.12, mapScale * 3.2);
  float tMin = 1.0 / tMax;

  vec3 color =
      mix(color_bg, color_outer, smoothstep(tMin, tMax, power.y)); // 外圈颜色
  color =
      mix(color, color_inner, smoothstep(tMin, tMax, power.x)); //// 内圈颜色
  return color;
}

vec2 getCellPower(vec2 coord, vec2 pos, vec2 size) {
  vec2 power;
  // 当前像素离 cell 的 pos 越远，power 越小，反之越大
  power = (size * size) / dot(coord - pos, coord - pos);
  power = pow(power, vec2(5.0 / 2.0));
  return power;
}

void main() {

  float T = u_time * 0.1 * timeScale / mapScale;

  vec2 hRes = 0.5 * u_resolution.xy;

  vec2 pos;
  vec2 power = vec2(0.0);

  for (float x = 1.0; x <= cellCount; x++) {
    // 随时间变化的 cell 位置
    pos =
        hRes * vec2(sin(T * fract(0.246 * x) + x * 3.6) *
                            cos(T * fract(0.374 * x) - x * fract(0.6827 * x)) +
                        1.0,
                    cos(T * fract(0.246 * x) + x * 3.6) *
                            sin(T * fract(0.374 * x) - x * fract(0.6827 * x)) +
                        1.0);
    // 根据当前像素的 coord 和 cell 的 pos 和 size 计算 cell 的 power
    power +=
        getCellPower(gl_FragCoord.xy, pos,
                     cellSize * (0.75 + fract(0.2834 * x) * 0.25) / mapScale);
  }
  gl_FragColor = vec4(powerToColor(power), 1.0);
}
