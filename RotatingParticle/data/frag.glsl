#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float dotSize = 0.01;
float iteration = 100.0;
float xAmp = 0.3;
float yAmp = 0.1;
float speed = 0.1;
float rotateCanvas = 0.0;
float rotateParticles = 1.0;
float rotateMultiplier = 10.0;
vec2 pos = vec2(0.5, 0.5);
float xFactor = 0.2;
float yFactor = 0.2;

vec2 rot(vec2 uv, float a) {
  // 关于 (0, 0) 点的旋转
  return vec2(uv.x * cos(a) - uv.y * sin(a), uv.y * cos(a) + uv.x * sin(a));
}

float circle(vec2 uv, float size) {
  // 向量长度在范围内为白色，范围外为黑
  return length(uv) > size ? 0.0 : 1.0;
}

void main() {
  vec2 uv = gl_FragCoord.xy / u_resolution;
  uv -= vec2(pos);

  vec3 color = vec3(0);

  /// 第一个粒子(i == 0)的纹理坐标 uv，每个粒子都有其对应的 uv 坐标系
  ///【其实第一个粒子是看不见的，因为size == 0】
  /// 首次旋转纹理坐标 uv
  uv = rot(uv, rotateCanvas);

  for (float i = 0.0; i < 100.0; i++) {
    if (iteration < i) {
      break;
    }
    /// 根据时间变化的每个粒子（在当前新 uv 坐标系下）的位置
    /// 所有粒子都随时间做 “椭圆圆周运动” ，越大的粒子越快
    /// x:sin() y:cos()
    vec2 new_pos = vec2(cos(i * xFactor) * (u_time * speed) * xAmp,
                        sin(i * yFactor * (u_time * speed)) * yAmp);

    /// st:当前粒子（在新坐标系下）的纹理坐标 uv 到该粒子位置 new_pos 的向量
    vec2 st = uv - new_pos;

    // 计算 st 向量的长度，并设置粒子的尺寸（从小到大）
    /// 得到当前纹素的颜色
    float dots = circle(st, dotSize * i * 0.01);

    /// 旋转当前粒子的纹理坐标 uv 得到下一个粒子的纹理坐标 uv
    /// 相当于为每个粒子都旋转了坐标系
    uv = rot(uv, rotateParticles * rotateMultiplier);

    // 更新纹素的颜色（只要当前纹素属于其中一个粒子，则置为白色，否则仍然是黑色）
    // 严谨的话是应该进行截断clamp，但是超过 1 也是白色，所以可以忽略
    color += dots;
  }

  gl_FragColor = vec4(color, 1);
}
