PShader shader;
PImage img;

void setup()
{
    size(640, 640, P3D);
    noStroke();
    img = loadImage("test02.jpg");
    shader = loadShader("frag.glsl","vert.glsl");
}
 
void draw()
{
    background(255);
    
    shader.set("u_resolution", float(width), float(height));
    shader.set("u_mouse", float(mouseX), float(mouseY));
    shader.set("u_time", millis() / 1000.0);
  
    shader(shader);
    drawImg(img);
}

void drawImg(PImage source)
{
    float sreen_r = width * 1.0 / height;
    float img_r = source.width * 1.0 / source.height;
    float ratio=1.0;
    if(sreen_r > img_r){
      ratio=height*1.0 / img.height;
      translate(abs(width-img.width*ratio)*0.5, abs(height-img.height*ratio));
    }else{
      ratio=width*1.0 / img.width;
      translate(abs(width-img.width*ratio), abs(height-(img.height*ratio))*0.5);
    }
    scale(ratio);
   
    shader.set("u_img", source);
    
    rect(0, 0, source.width, source.height);
    
  
}
