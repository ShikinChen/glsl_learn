#ifdef GL_ES
precision highp float;
#endif

#define PI 3.14159265358979323846264338327950288419716939937510

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#define SORT_SIZE 8

float sort[SORT_SIZE];
float medians[SORT_SIZE];

uniform sampler2D u_img;

in vec2 v_texCoord;
in vec4 v_position;
in mat4 v_transform;
in mat4 v_texMatrix;
in mat4 v_modelview;
in mat4 v_projection;
in mat3 v_normalMatrix;

float pack(vec3 c) {
  float lum = (c.x + c.y + c.z) * (1.0 / 3.0);
  return lum;
}

vec3 unpack(float x) { return vec3(x); }

void swap(int a, int b) {
  float t = sort[a];
  sort[a] = sort[b];
  sort[b] = t;
}

// 简单的冒泡排序
void bubbleSort(int num) {
  // 把最小值移到最左边
  for (int j = 0; j < num; j++) {
    for (int i = num - 1; i > j; i--) {
      if (sort[i] < sort[i - 1]) {
        swap(i, i - 1);
      }
    }
  }
}

vec2 rotateUV(vec2 uv, float rotation) {
  // 以中点为锚点 z轴旋转
  float mid = 0.5;
  return vec2(cos(rotation) * (uv.x - mid) + sin(rotation) * (uv.y - mid) + mid,
              cos(rotation) * (uv.y - mid) - sin(rotation) * (uv.x - mid) +
                  mid);
}

void main() {

  // vec2 ooRes = vec2(1.0) / u_resolution.xy;
  // vec2 fragCoord = gl_FragCoord.xy / u_resolution.xy;
  for (int j = 0; j < SORT_SIZE; j++) {
    for (int i = 0; i < SORT_SIZE; i++) {
      // TODO 因为mvp关系计算错误 产生十字线
      vec2 offset=(vec2(float(i), float(j)) -
                 vec2(SORT_SIZE / 2.0)) /
                v_position.xy;
      vec2 uv = v_texCoord.xy + offset;

      float c = pack(texture2D(u_img, uv).rgb);

      sort[i] = c;
    }
    // 针对某列进行纵向排序
    bubbleSort(SORT_SIZE);
    //保存该列的中值
    float m = sort[SORT_SIZE / 2];

    medians[j] = m;
  }

  for (int i = 0; i < SORT_SIZE; i++) {
    sort[i] = medians[i];
  }
  //对上一步 SORT_SIZE个列中值 进行横向排序
  bubbleSort(SORT_SIZE);
  gl_FragColor = vec4(unpack(sort[SORT_SIZE / 2]), 1.0);
  // vec2 uv = rotateUV((v_texMatrix * vec4(fragCoord, 1.0, 1.0)).st, 1.0 * PI);
  // gl_FragColor = texture2D(u_img, vec2(1.0-uv.s, uv.t));// 1.0-s进行翻转
}