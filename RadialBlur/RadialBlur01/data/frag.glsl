#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

uniform sampler2D u_img;

in vec2 v_texCoord;
in vec4 v_position;
in mat4 v_transform;

uniform vec2 centerpos = vec2(0.5, 0.5); // 径向中心
uniform float glowRange = 5.0;          // 径向范围

void main() {
  vec2 uv = v_texCoord;

  vec4 clraverge = vec4(0, 0, 0, 0);
  float range = glowRange;
  float count = 0;
  float x1 = 0.0;
  float y1 = 0.0;
  vec2 cpos = centerpos;

  for (float j = 1; j <= range; j += 1) {
    // 横坐标为圆心坐标时，计算k分母为0
    if (cpos.x - uv.x == 0) {
      x1 = uv.x;
      // y 方向上一定范围内的采样（0 - 1/10的差值）
      y1 = uv.y + (cpos.y - uv.y) * j / (10 * range);
    } else {
      // 直线的斜率
      float k = (cpos.y - uv.y) / (cpos.x - uv.x);
      // x 方向
      x1 = uv.x + (cpos.x - uv.x) * j / (10. * range);
      // k 方向
      y1 = cpos.y - (cpos.x - x1) * k;
      // 如果超出指定范围则跳过
      if (x1 < 0.0 || y1 < 0.0 || x1 > 1.0 || y1 > 1.0) {
        continue;
      }
    }
    clraverge += texture2D(u_img, vec2(x1, y1));
    count += 1;
  }
  // 取径向范围内的平均值
  clraverge /= count;
  gl_FragColor = clraverge;
}