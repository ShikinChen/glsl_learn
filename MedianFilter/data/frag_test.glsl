#ifdef GL_ES
precision highp float;
#endif
#define SORT_SIZE 8

uniform vec2 u_resolution;
uniform sampler2D u_img;

in vec2 v_texCoord;
in vec4 v_position;

float sort[SORT_SIZE];
float medians[SORT_SIZE];

// [0., 1.] -> [0, 255]
float quant(float x) {
  x = clamp(x, 0., 1.);
  return floor(x * 255.);
}

float pack(vec3 c) {
  float lum = (c.x + c.y + c.z) * (1. / 3.);

  return lum;
}

vec3 unpack(float x) { return vec3(x); }

#define SWAP(a, b)                                                             \
  {                                                                            \
    float t = sort[a];                                                         \
    sort[a] = sort[b];                                                         \
    sort[b] = t;                                                               \
  }
void bubble_sort(int num) // 简单的冒泡排序
{
  // 把最小值移到最左边
  for (int j = 0; j < num; ++j) {
    for (int i = num - 1; i > j; --i) {
      if (sort[i] < sort[i - 1]) {
        SWAP(i, i - 1);
      }
    }
  }
}

// uniform sampler2D u_img;
// vec2 u_resolution = vec2(640.0, 640.0);

void main() {
  vec2 ooRes = vec2(1.) / v_position.xy;

  // SORT_SIZE个列
  for (int j = 0; j < SORT_SIZE; j++) {
    // SORT_SIZE个行
    for (int i = 0; i < SORT_SIZE; i++) {
      vec2 uv = v_texCoord.xy + (vec2(i, j) - vec2(SORT_SIZE / 2)) * ooRes;
      float c = pack(texture2D(u_img, uv).rgb);

      sort[i] = c;
    }
    // 针对某列进行纵向排序
    bubble_sort(SORT_SIZE);

    //保存该列的中值
    float m = sort[(SORT_SIZE / 2)];

    medians[j] = m;
  }

  for (int i = 0; i < SORT_SIZE; i++) {
    sort[i] = medians[i];
  }
  //对上一步 SORT_SIZE个列中值 进行横向排序
  bubble_sort(SORT_SIZE);
  // 提取中值
  gl_FragColor = vec4(unpack(sort[SORT_SIZE / 2]), 1.0);
}