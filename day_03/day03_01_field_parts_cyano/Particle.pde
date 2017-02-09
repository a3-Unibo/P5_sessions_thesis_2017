class Particle {
  PVector pos;
  PVector vel;
  Field f;
  float life, lifeRate;
  float gir;


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

  void display() {
    stroke(0, 255, 255, 20);
    //stroke(randomColorNewR, randomColorNewG, randomColorNewB, opacity);
    strokeWeight(2);
    point(pos.x, pos.y);
  }
}