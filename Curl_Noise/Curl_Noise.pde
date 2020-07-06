ArrayList<Particle> particles = new ArrayList<Particle>();
int n = 500;
float scale = 1;
float r = 10*scale;
float nScale = 100*scale;//noise scale
OpenSimplexNoise snoise = new OpenSimplexNoise();
float woff = 0;

void setup(){
  size(500, 500, P3D);
  //fullScreen(P3D);
  colorMode(HSB, 360, 100, 100, 100);
  for(int i=0; i<n; i++){
    particles.add(new Particle());
  }
  noStroke();
}

void draw(){
  fill(360, 10);
  rect(0, 0, width, height);
  for(Particle p : particles){
    p.update(false);
    p.show();
  }
  //relax();
  woff += 0.004;
}

class Particle{
  PVector pos;
  float speed;
  
  Particle(){
    pos = new PVector(random(width), random(height), random(0));
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
    adjast();
  }
  
  void show(){
    fill(250, 100, 100);
    rect(pos.x, pos.y, speed*5, speed*5);
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
