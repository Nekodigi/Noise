ArrayList<Particle> particles = new ArrayList<Particle>();
int n = 2000;//2000
float scale = 1;//2
float sRand = scale*2;//spawn random scale*2
float r = 10*scale;//10*scale
float nScale = 100*scale;//noise scale 200*scale
OpenSimplexNoise snoise = new OpenSimplexNoise();
float woff = 0;

void setup(){
  size(500, 500, P3D);
  //fullScreen(P3D);
  blendMode(ADD);
  //fullScreen(P3D);
  colorMode(HSB, 360, 100, 100, 100);
  for(int i=0; i<n; i++){
    particles.add(new Particle());
  }
  noStroke();
  background(0);
}

void draw(){
  //fill(360, 10);
  //rect(0, 0, width, height);
  for(Particle p : particles){
    p.update(false);
    p.show();
  }
  //relax();
  //woff += 0.004;
}

void mousePressed(){
  background(0);
  particles = new ArrayList<Particle>();
  for(int i=0; i<n; i++){
    particles.add(new Particle());
  }
  woff = random(100);
}

class Particle{
  PVector pos;
  float speed;
  color col;
  
  Particle(){
    col = color(250, random(10)+90, 100);
    pos = new PVector(width/2 + random(-sRand, sRand), height/2+random(-sRand, sRand), random(-sRand, sRand));
  }
  
  void adjast(){
    if(pos.x < 0 || pos.x > width || pos.y < 0 || pos.y > height)pos = new PVector(random(width), random(height), random(0));
  }
  
  void update(boolean useRaw){
    PVector vec = new PVector();
    if(useRaw){
      vec = noiseVec(pos.x, pos.y, pos.z, woff).mult(scale);
    }else{
      vec = curlNoise(pos.x, pos.y, pos.z, woff).mult(scale);
    }
    speed = vec.mag();
    pos.add(vec);
    //pos.z = 0;
    //adjast();
  }
  
  void show(){
    fill(col);
    rect(pos.x, pos.y, scale, scale);
  }
}

PVector curlNoise(float x_, float y_, float z_, float woff){
  //PVector A = noiseVec(x_, y_, z_, woff);
  PVector px0 = noiseVec(x_-EPSILON, y_, z_, woff);
  PVector px1 = noiseVec(x_+EPSILON, y_, z_, woff);
  PVector py0 = noiseVec(x_, y_-EPSILON, z_, woff);
  PVector py1 = noiseVec(x_, y_+EPSILON, z_, woff);
  PVector pz0 = noiseVec(x_, y_, z_-EPSILON, woff);
  PVector pz1 = noiseVec(x_, y_, z_+EPSILON, woff);
  
  float x = (py1.z - py0.z) - (pz1.y - pz0.y);
  float y = (pz1.x - pz0.x) - (px1.z - px0.z);
  float z = (px1.y - px0.y) - (py1.x - py0.x);
  return new PVector(x, y, z).div(EPSILON*2);
}

PVector noiseVec(float x_, float y_, float z_, float woff){
  float x =(float)snoise.eval(x_/nScale, y_/nScale, z_, woff);
  float y = (float)snoise.eval(x_/nScale, y_/nScale, z_, woff+100);
  float z = (float)snoise.eval(x_/nScale, y_/nScale, z_, woff+200);
  return new PVector(x, y, z);
}
