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

// 简单的光线结构体，更高级的Ray Tracer所需的字段更多
struct Ray {
  vec3 origin;    // 光源点
  vec3 direction; //光源方向
};

struct Sphere {
  vec3 center;  // 球心
  float radius; //半径
};

vec4 diffuse(in vec3 surface, in vec3 center, in vec4 color, in vec3 litePos) {
  // 归一化的表面法线向量
  vec3 n = normalize(surface - center);
  // 从表面到光源点的方向向量（归一化）
  vec3 l = normalize(litePos - surface);
  // 散射（diffuse）公式
  return color * max(0.0, dot(n, l));
}

// 直线和圆是否相交
float intersectSphere(in Ray ray, in Sphere sphere) {
  // 圆心到光源点的向量
  vec3 co = ray.origin - sphere.center;

  float discriminant =
      pow(dot(co, ray.direction), 2.0) - dot(co, co) + pow(sphere.radius, 2.0);

  // 判别式非负，表示相交，则计算 光源点 到 圆 表面的距离
  if (discriminant >= 0.0) {
    return -dot(ray.direction, co) - sqrt(discriminant);
  } else {
    return -1; // 判别式为负表示不相交
  }
}

void main() {
  /*
 gl_FragCoord 代表了像素中心.
 例如一个800x600的分辨率, 左下角的像素坐标为 (0.5,0.5)
 右上角的像素坐标为 (799.5, 599.5).
 */
  // 转换像素坐标 (x,y) 到 [0,1]的范围
  vec2 st = gl_FragCoord.xy / u_resolution;
  // 再将其从[0,1] 转到 [-1,1]，并将像素(0, 0)移到屏幕中心
  st = st * 2.0 - vec2(1.0);

  // 为了进行 raytracing, 我们需要一条光线 - 即一个方向和一个光源点
  // 方向是由像素坐标减去相机坐标并归一化得到的

  vec3 pixelPos = vec3(st, 0);

  vec3 eyePos = vec3(0.0, 0.0, -4.0);
  vec3 rayDir = normalize(pixelPos - eyePos);

  Sphere sphere = Sphere(vec3(0.0, 0.0, 7.0), 1.0);

  // 判断光线和球是否相交
  float eyeToSphere = intersectSphere(Ray(eyePos, rayDir), sphere);

  if (eyeToSphere >= 0.0) {
    vec4 diffuseColor = vec4(0.0, 1.0, 1.0, 1.0);
    vec4 ambientColor = vec4(0.2, 0.0, 0.0, 1.0);
    vec3 litePos = vec3(3.0, 0.0, 0.0);

    gl_FragColor = ambientColor + diffuse(eyePos + eyeToSphere * rayDir,
                                          sphere.center, diffuseColor, litePos);
  } else {
    gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
  }
}