class Agent {

  PVector pos, vel, acc;
  ArrayList<PVector>trail, trailV;
  float maxVel, maxForce;
  float cR, cI, sR, sI, aR, aI; // cohesion & separation radius & intensity
  float ccR, ssR, aaR; // squared values (faster)
  PVector world;


  Agent(PVector pos, PVector vel, PVector world) {
    this.pos = pos;
    this.vel = vel;
    this.world = world;
    acc = new PVector();
    trail = new ArrayList<PVector>();
    trailV = new ArrayList<PVector>();
    maxVel = 1.5;
    maxForce = 0.01;
    sR = 5;
    sI = 1;
    cR=80; //200
    cI=0.05;
    aR= 40;
    aI = 0.1;
    ssR = sR*sR;
    ccR = cR *cR;
    aaR = aR*aR;
  }

  void update() {
    flock(agents);
    move();
    //bounce();
    wrap();
    updateTrail(8);
  }

  //_______ flocking methods

  void flockSlow(ArrayList<Agent> agents) {
    separation(agents);
    cohesion(agents);
    alignment(agents);
  }

  void flock(ArrayList<Agent> agents) {
    int cC, cS, cA; // counters
    PVector tC, tS, tA, des, steer;
    float dist, easC, easS;
    cC = 0;
    cS = 0;
    cA = 0;
    tC = new PVector();
    tS = new PVector();
    tA = new PVector();
    for (Agent other : agents) {
      dist = PVector.sub(other.pos, pos).magSq();
      if (dist >0 && dist < ccR) {
        cC++;
        tC.add(other.pos);
        if (dist < aaR) {
          cA++;
          tA.add(other.vel);
          if (dist < ssR) {
            cS++;
            tS.add(other.pos);
          }
        }
      }
    }

    if (cC > 0) {
      tC.mult(1.0/cC); // average
      des = PVector.sub(tC, pos); // pos.sub(t);
      dist = des.mag();
      easC = 1 - (cR-dist)/cR; // stronger when far
      des.setMag(maxVel);// positive (cohesion)
      steer = PVector.sub(des, vel);
      steer.setMag(cI*easC);
      acc.add(steer);

      if (cA > 0) {

        des = tA.mult(1.0/cA); // average
        //PVector des = PVector.sub(t, pos); // pos.sub(t);
        dist = des.mag();
        des.setMag(maxVel);// negative (separate)
        steer = PVector.sub(des, vel);
        steer.setMag(aI);
        acc.add(steer);

        if (cS > 0) {
          tS.mult(1.0/cS); // average
          des = PVector.sub(tS, pos); // pos.sub(t);
          dist = des.mag();
          easS = (sR-dist)/sR;
          des.setMag(maxVel*-1);// negative (separate)
          steer = PVector.sub(des, vel);
          steer.setMag(sI*easS);
          acc.add(steer);
        }
      }
    }
  }

  void cohesion(ArrayList<Agent> agents) {
    int count=0;
    PVector t= new PVector();
    float dist, easing;
    for (Agent other : agents) {
      dist = pos.dist(other.pos);
      if (dist>0 && dist<cR) {
        count++;
        t.add(other.pos);
      }
    }
    if (count>0) {
      t.mult(1.0/count); // average
      PVector des = PVector.sub(t, pos); // pos.sub(t);
      dist = des.mag();
      easing = 1 - (cR-dist)/cR; // stronger when far
      des.setMag(maxVel);// positive (cohesion)
      PVector steer = PVector.sub(des, vel);
      steer.setMag(cI*easing);
      acc.add(steer);
    }
  }

  void separation(ArrayList<Agent> agents) {
    int count=0;
    PVector t= new PVector();
    float dist, easing;
    for (Agent other : agents) {
      dist = pos.dist(other.pos);
      if (dist>0 && dist<sR) {
        count++;
        t.add(other.pos);
      }
    }
    if (count>0) {
      t.mult(1.0/count); // average
      PVector des = PVector.sub(t, pos); // pos.sub(t);
      dist = des.mag();
      easing = (sR-dist)/sR;
      des.setMag(maxVel*-1);// negative (separate)
      PVector steer = PVector.sub(des, vel);
      steer.setMag(sI*easing);
      acc.add(steer);
    }
  }

  void alignment(ArrayList<Agent> agents) {
    int count=0;
    PVector des= new PVector();
    float dist;
    for (Agent other : agents) {
      dist = pos.dist(other.pos);
      if (dist>0 && dist<aR) {
        count++;
        des.add(other.vel);
      }
    }
    if (count>0) {
      des.mult(1.0/count); // average
      //PVector des = PVector.sub(t, pos); // pos.sub(t);
      dist = des.mag();
      des.setMag(maxVel);// negative (separate)
      PVector steer = PVector.sub(des, vel);
      steer.setMag(aI);
      acc.add(steer);
    }
  }

  void move() {
    vel.add(acc);
    vel.limit(maxVel);
    pos.add(vel);
    acc = new PVector();
  }

  void seek(PVector t) {
    PVector des = PVector.sub(t, pos); // pos.sub(t);
    des.setMag(maxVel);
    PVector steer = PVector.sub(des, vel);
    steer.setMag(maxForce);
    acc.add(steer);
  }

  //_______ boundary methods

  void bounce() {
    if (pos.x > world.x*0.5 || pos.x <-world.x*0.5) vel.x *=-1;
    if (pos.y > world.y*0.5 || pos.y <-world.y*0.5) vel.y *=-1;
    if (pos.z > world.z*0.5 || pos.z <-world.z*0.5) vel.z *=-1;
  }


  void wrap() {
    if (pos.x > world.x*0.5) pos.x  = -world.x*0.5;
    if (pos.x < -world.x*0.5) pos.x  = world.x*0.5;
    if (pos.y > world.y*0.5) pos.y  = -world.y*0.5;
    if (pos.y < -world.y*0.5) pos.y  = world.y*0.5;
    if (pos.z > world.z*0.5) pos.z  = -world.z*0.5;
    if (pos.z < -world.z*0.5) pos.z  = world.z*0.5;
  }

  //_______ trail methods

  void updateTrail(int freq) {
    if (frameCount % freq == 0) { //se freqCount è multiplo di freq allora facciamo l'update
      trail.add(pos.copy());
      trailV.add(vel.copy());
    }
  }

  //_______ dispaly methods

  void display() {
    float vM = vel.mag()/maxVel;
    stroke(lerpColor(color(255, 0, 0), color(0), vM));
    strokeWeight(0.5);
    //ellipse(pos.x, pos.y, sR, sR);
    strokeWeight(2);
    point(pos.x, pos.y, pos.z);
  }


    void dispTrail() {
      stroke(0, 100);
      strokeWeight(1);
      for (PVector p : trail) point(p.x, p.y, p.z);
    }

    void dispTrailCurve() {
      stroke(0, 100);
      strokeWeight(1);
      PVector p, p1;
      for (int i=0; i<trail.size()-1; i++) {
        p=trail.get(i);
        p1 =trail.get(i+1);
        if (PVector.sub(p1, p).magSq()<10000) {
          line(p.x, p.y, p.z, p1.x, p1.y, p1.z);
        }
      }

      //beginShape();
      //for (PVector p : trail) vertex(p.x, p.y, p.z);
      //endShape();
    }

    void disptrailV() {
    }
  }