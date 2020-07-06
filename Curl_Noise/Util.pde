void relax(){
  float force = 0.1;
  for(int i=0; i<particles.size(); i++){
    Particle particle = particles.get(i);
    for(Particle target : particles){
      if(target == particle)continue;
      PVector diff = PVector.sub(particle.pos, target.pos);
      float dist = diff.x*diff.x + diff.y*diff.y;
      if(dist < 2*r*2*r){
        dist = sqrt(dist);
        float rdist = 2*r-dist;
        particle.pos.add(diff.setMag(rdist).mult(force));
      }
    }
  }
}
