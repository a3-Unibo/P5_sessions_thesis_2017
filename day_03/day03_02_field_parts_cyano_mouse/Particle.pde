class Particle {
  PVector pos;
  PVector vel;
  Field f;
  float life, lifeRate;
  float gir;
  int opacityStart = 200;
  int opacity = opacityStart-1;


  Particle(PVector pos, PVector vel, Field f, float gir, int life) {
    this.pos =pos;
    this.vel=vel;
    this.f=f;
    this.gir=gir;
    this.life=1;
    this.lifeRate = 1/(float)life;
  }

  void move() { // valore che legge sulla mappa determina l'angolo di rotazione
    if (life > 0) {
      float theta = lerp(gir, 0, life); //linear interpolation
      float ang=map(f.evalScalar(pos), 0, .6, -theta, theta);
      vel.rotate(ang);
      pos.add(vel);
      life-=lifeRate;
    }
  }

void setOpacity() {
  if (opacity>0 && opacity<opacityStart) {
    opacity = opacity -1;
  }
}

  void display() {
    stroke(0,255,255,50);
    //stroke(randomColorNewR, randomColorNewG, randomColorNewB, opacity);
    strokeWeight(2);
    point(pos.x, pos.y);
  }
}