PShader shader;
PImage img;
PImage bg;
float ratio=1.0;
void setup()
{
    size(640, 640, P3D);
    noStroke();
    img = loadImage("nyan_cat.png");
    bg = loadImage("bg.png");
    shader = loadShader("frag.glsl","vert.glsl");
}
 
void draw()
{
    background(255);
    
    shader.set("u_resolution", float(width), float(height));
    shader.set("u_mouse", float(mouseX), float(mouseY));
    shader.set("u_time", millis() / 1000.0);
    

  
    shader(shader);
    drawImg(bg,"u_bg",width,height);
    
    shader.set("u_img_size",img.width*ratio, img.height*ratio);
    //drawImg(img,"u_img",bg.width,bg.height);
    shader.set("u_img", img);
    rect(0, 0, bg.width,  bg.height);
}

void drawImg(PImage source,String name,int w,int h)
{
    float sreen_r = w * 1.0 / h;
    float img_r = source.width * 1.0 / source.height;
    ratio=1.0;
    if(sreen_r > img_r){
      ratio=h*1.0 / source.height;
      translate(abs(w-source.width*ratio)*0.5, abs(h-source.height*ratio));
    }else{
      ratio=w*1.0 / source.width;
      translate(abs(w-source.width*ratio), abs(h-(source.height*ratio))*0.5);
    }
    scale(ratio);
   
    shader.set(name, source);
   
}
