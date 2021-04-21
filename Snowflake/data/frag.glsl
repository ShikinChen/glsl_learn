#ifdef GL_ES
precision highp float;
#endif

#define _SnowflakeAmount 400//雪花数
#define _BlizardFactor.25//风的大小

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

uniform sampler2D u_img;

in vec2 v_texCoord;

float rnd(float x){
    // fract 返回x的小数部分
    return fract(
        sin(
            //dot向量x，y之间的点积
            dot(
                vec2(x+47.49,38.2467/(x+2.3)),
                vec2(12.9898,78.233)
            )
        )*(43758.5453)
    );
}

float drawCircle(vec2 uv,vec2 center,float radius){
    //smoothstep 如果x <= agr0，返回0.0 ；如果x >= agr1 返回1.0；如果agr0 < x < agr1，则执行0~1之间的平滑埃尔米特差值。如果agr0 >= agr1，结果是未定义的。
    return 1.-smoothstep(0.,radius,length(uv-center));
}

void main()
{
    vec2 uv=gl_FragCoord.xy/u_resolution.x;
    vec4 color=texture2D(u_img,v_texCoord);
    gl_FragColor=color;
    
    float j;
    // 生成若干个圆，当前uv依次与这些圆心计算距离，未落在圆域内则为黑色，落在圆域内则为白色
    for(int i=0;i<_SnowflakeAmount;i++){
        j=float(i);
        
        float speed=.3+rnd(cos(j))*(.7+.5*cos(j/(float(_SnowflakeAmount)*.25)));
        
        vec2 center=vec2(
            // x坐标 左右环绕分布的范围
            rnd(j)+///< 根据雪花的索引随机起始位置
            (-.25+uv.y)*_BlizardFactor///< 越高的位置越往右偏
            +.1*cos(u_time+sin(j))
            ,
            // y坐标  随着时间下降（不超过 0.95）
            mod(rnd(j)///< 根据雪花的索引随机起始位置
            -speed*(u_time*1.5*(.1+_BlizardFactor)),.95)
        );
        gl_FragColor+=vec4(.9*drawCircle(uv,center,.001+speed*.012));// 输出是这些圆的颜色叠加
    }
}

