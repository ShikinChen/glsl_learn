#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float insideBox(vec2 v, vec2 bottomLeft, vec2 topRight) {
  // 如果在矩形内的话，s应该为(1.， 1.)，即函数返回值应该为 1
  vec2 s = step(bottomLeft, v) - step(topRight, v);
  return s.x * s.y;
}

float insideBox3D(vec3 v, vec3 bottomLeft, vec3 topRight) {
    vec3 s = step(bottomLeft, v) - step(topRight, v);
    return s.x * s.y * s.z; 
}

void main() {
  vec4 color = vec4(0.6, 0.3, 0.5, 1.0);
  vec2 texCoord = gl_FragCoord.xy / u_resolution.xy;
  float t = insideBox(texCoord, vec2(0.5, 0.5), vec2(1, 1));
  //鼠标坐标系统和纹理不一样
  float i =
      insideBox(u_mouse.xy / u_resolution.xy, vec2(0.5, 0.5), vec2(1, -1)) + 2;

  gl_FragColor = t * color * i;
}
