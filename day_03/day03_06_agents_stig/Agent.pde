class Agent {

  PVector pos, fPos, vel, acc;
  ArrayList<PVector>trail, trailV;
  int nTrail;
  float maxVel, maxForce;
  float fMag = 5;
  PVector world;


  Agent(PVector pos, PVector vel, PVector world) {
    this.pos = pos;
    this.vel = vel;
    this.world = world;
    fPos = PVector.add(pos, vel.copy().mult(fMag));
    acc = new PVector();
    trail = new ArrayList<PVector>();
    trailV = new ArrayList<PVector>();
    nTrail= 10;
    maxVel = 1.5;
    maxForce = 0.01;
  }

  void update() {
    flock(agents, cR, aR, sR, cI, aI, sI);
    move();
    //bounce();
    wrap();
    updateTrail(5);
  }

  //_______ flocking methods


  void flock(ArrayList<Agent> agents, float cR, float aR, float sR, float cI, float aI, float sI) {

    int cC, cS, cA; // counters
    float ccR, ssR, aaR; // squared values (faster)
    PVector tC, tS, tA, des, steer;
    float dist, easC, easS;
    cC = 0;
    cS = 0;
    cA = 0;

    ssR = sR*sR;
    ccR = cR *cR;
    aaR = aR*aR;

    tC = new PVector();
    tS = new PVector();
    tA = new PVector();

    for (int i=agents.size()-1; i>=0; i--) {

      Agent other = agents.get(i);
      dist = PVector.sub(other.pos, pos).magSq();

      if (this != other) {
        if (dist < ccR) {
          cC++;
          tC.add(other.pos);
        }
        if (dist < aaR) {
          cA++;
          tA.add(other.vel);
        }
        if (dist < ssR) {
          cS++;
          tS.add(other.pos);
        }
      }
    }

    if (cC > 0) {
      tC.mult(1.0/cC); // average
      des = PVector.sub(tC, pos); // pos.sub(t);
      dist = des.magSq();
      easC = dist/ccR; // stronger when far
      des.setMag(maxVel);// positive (cohesion)
      steer = PVector.sub(des, vel);
      steer.setMag(cI*easC);
      acc.add(steer);

      if (cA > 0) {

        des = tA.mult(1.0/cA); // average
        //PVector des = PVector.sub(t, pos); // pos.sub(t);
        //dist = des.mag();
        des.setMag(maxVel);// negative (separate)
        steer = PVector.sub(des, vel);
        steer.setMag(aI);
        acc.add(steer);

        if (cS > 0) {
          tS.mult(1.0/cS); // average
          des = PVector.sub(tS, pos); // pos.sub(t);
          dist = des.magSq();
          easS = 1-dist/ssR;
          des.setMag(maxVel*-1);// negative (separate)
          steer = PVector.sub(des, vel);
          steer.setMag(sI*easS);
          acc.add(steer);
        }
      }
    }
  }

  void cohesion(ArrayList<Agent> agents, float cR, float cI) {
    flock(agents, cR, 0, 0, cI, 0, 0);
  }

  void alignment(ArrayList<Agent> agents, float aR, float aI) {
    flock(agents, 0, aR, 0, 0, aI, 0);
  }

  void separation(ArrayList<Agent> agents, float sR, float sI) {
    flock(agents, 0, 0, sR, 0, 0, sI);
  }


  void move() {
    vel.add(acc);
    vel.limit(maxVel);
    pos.add(vel);
    fPos = PVector.add(pos, vel.copy().mult(fMag));
    acc = new PVector();
  }

  void seek(Attractor t) {
    PVector des = PVector.sub(t.pos, pos); // pos.sub(t);
    float dsq=des.magSq();
    if (dsq<t.rr) {
      des.setMag(maxVel);
      PVector steer = PVector.sub(des, vel);
      steer.setMag(map((t.rr-dsq)/t.rr, 0, 1, 0.1*t.charge, 0.8*t.charge));
      acc.add(steer);
    }
  }

  void pointsCohesion(ArrayList<PVector> trails, float cR, float cI) {
    // implement separation and alignment !!!
    int count=0;
    float ccR = cR*cR;
    PVector t= new PVector();
    PVector des;
    float dist, easing, visAng;
    for (int i=trails.size()-1; i>=0; i--) {
      PVector trailPt = trails.get(i);
      des = PVector.sub(trailPt, fPos);
      visAng = PVector.angleBetween(vel, des);
      if (visAng <= PI*.3) {
        dist = des.magSq();
        //(pos.dist(other.pos);
        if (dist >0 && dist<ccR) {
          count++;
          t.add(trailPt);
        }
      }
    }
    if (count>0) {
      t.mult(1.0/count); // average
      des = PVector.sub(t, pos); // pos.sub(t);
      dist = des.mag();
      easing = dist/cR; // stronger when far
      des.setMag(maxVel);// positive (cohesion)
      PVector steer = PVector.sub(des, vel);
      steer.setMag(cI*easing);
      acc.add(steer);
    }
  }

  //_______ boundary methods

  void bounce() {
    if (pos.x > world.x*0.5 || pos.x <-world.x*0.5) vel.x *=-1;
    if (pos.y > world.y*0.5 || pos.y <-world.y*0.5) vel.y *=-1;
    if (pos.z > world.z*0.5 || pos.z <-world.z*0.5) vel.z *=-1;
  }


  void wrap() {
    if (pos.x > world.x*0.5) pos.x  = -world.x*0.5;
    else if (pos.x < -world.x*0.5) pos.x  = world.x*0.5;
    if (pos.y > world.y*0.5) pos.y  = -world.y*0.5;
    else if (pos.y < -world.y*0.5) pos.y  = world.y*0.5;
    if (pos.z > world.z*0.5) pos.z  = -world.z*0.5;
    else if (pos.z < -world.z*0.5) pos.z  = world.z*0.5;
  }

  //_______ trail methods

  void updateTrail(int freq) {
    if (frameCount % freq == 0) { //se freqCount è multiplo di freq allora facciamo l'update
      trail.add(pos.copy());
      trailV.add(vel.copy());
      if (trail.size()>nTrail) {
        trail.remove(0);
        trailV.remove(0);
      }
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