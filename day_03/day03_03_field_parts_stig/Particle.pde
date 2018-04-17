class Particle {
  PVector pos;
  PVector vel;
  Field f;
  float life, lifeRate, angVis;
  float gir, maxVel;


  Particle(PVector pos, PVector vel, Field f, float gir, int life) {
    this.pos =pos;
    this.vel=vel;
    this.f=f;
    this.gir=gir;
    this.life=1;
    this.lifeRate = 1/(float)life;
    angVis = PI*.3;
    maxVel = 1.5;
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

  void moveStig() { // uses 3 sensor points and angle of vision
    int rad = 10;
    float maxVal = 0, val;
    PVector vs = vel.copy().setMag(rad);
    PVector[] sensor = new PVector[3];
    sensor[1] = PVector.add(pos, vs);
    sensor[0] = PVector.add(pos, vs.copy().rotate(angVis));
    sensor[2] = PVector.add(pos, vs.copy().rotate(-angVis));


    PVector dir = PVector.random2D().setMag(vel.mag());
    //PVector dir = vel.copy();

    for (int i=0; i< sensor.length; i++) {
      //stroke(200,0,0);
      //point(sensor[i].x, sensor[i].y); // uncomment to visualize sensors
      val = f.evalScalar(sensor[i]);
      if (val > maxVal) {
        maxVal = val;
        dir = sensor[i].copy();
      }
    }

    f.writeScalar(pos, 0.02);
    //if(maxVal ==0) dir = vel;
    dir.sub(pos);
    dir.setMag(maxVel);
    PVector steer = PVector.sub(dir, vel);
    steer.mult(0.2);
    vel.add(steer);
    vel.limit(maxVel);
    pos.add(vel);
  }

  void moveStigSample() { // smaples a cloud of scattered points
    float maxVal = 0, val;
    int nSamples = 50;
    int rad = 50;

    PVector dir = PVector.random2D().setMag(vel.mag());
    PVector v, futPos = PVector.add(pos, vel.copy().setMag(rad*1.5));

    for (int i=0; i< nSamples; i++) {
      v = PVector.add(futPos, PVector.random2D().mult(rad));
      //v = PVector.add(futPos, new PVector(random(-rad,rad), random(-rad,rad)));

      val = f.evalScalar(v);
      if (val > maxVal) {
        maxVal = val;
        dir = v.copy();
      }
    }

    f.writeScalar(pos, 0.02);
    //if(maxVal ==0) dir = vel;
    dir.sub(pos);
    dir.setMag(maxVel);
    PVector steer = PVector.sub(dir, vel);
    steer.mult(0.1);
    vel.add(steer);
    vel.setMag(maxVel);
    pos.add(vel);
  }

  void wrap() {
    if (pos.x<0) pos.x = width;
    else if (pos.x>width) pos.x = 0;
    if (pos.y<0) pos.y = height;
    else if (pos.y>height) pos.y = 0;
  }

  void display() {
    stroke(255, 255, 0);
    strokeWeight(5);
    point(pos.x, pos.y);
  }
}