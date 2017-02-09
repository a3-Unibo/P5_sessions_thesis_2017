class Agent {

  Vec3D pos, vel, acc;
  ArrayList<Vec3D>trail, trailV;
  int nTrail;
  float maxVel, maxForce;
  //float cR, cI, sR, sI, aR, aI; // cohesion & separation radius & intensity

  Vec3D world;


  Agent(Vec3D pos, Vec3D vel, Vec3D world) {
    this.pos = pos;
    this.vel = vel;
    this.world = world;
    acc = new Vec3D();
    trail = new ArrayList<Vec3D>();
    trailV = new ArrayList<Vec3D>();
    nTrail= 20;
    maxVel = 1.5;
    maxForce = 0.01;
  }

  void update(ArrayList<Agent> agents) {
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
    Vec3D tC, tS, tA, des, steer;
    float dist, easC, easS;
    cC = 0;
    cS = 0;
    cA = 0;

    ssR = sR*sR;
    ccR = cR*cR;
    aaR = aR*aR;

    tC = new Vec3D();
    tS = new Vec3D();
    tA = new Vec3D();

    for (int i=agents.size()-1; i>=0; i--) {

      Agent other = agents.get(i);

      if (this != other) { // see if we're not checking ourselves

        dist = pos.distanceToSquared(other.pos);

        if (dist < ccR) {
          cC++;
          tC.addSelf(other.pos);
        }
        if (dist < aaR) {
          cA++;
          tA.addSelf(other.vel);
        }
        if (dist < ssR) {
          cS++;
          tS.addSelf(other.pos);
        }
      }
    }

    if (cC > 0) {
      tC.scaleSelf(1.0/cC); // average
      des = tC.sub(pos); // t.sub(pos);
      dist = des.magSquared();
      easC = dist/ccR; // stronger when far
      des.normalizeTo(maxVel);// positive (cohesion)
      steer = des.sub(vel);
      steer.normalizeTo(cI*easC);
      acc.addSelf(steer);

      if (cA > 0) {

        des = tA.scale(1.0/cA); // average
        des.normalizeTo(maxVel);// negative (separate)
        steer = des.sub(vel);
        steer.normalizeTo(aI);
        acc.addSelf(steer);

        if (cS > 0) {
          tS.scaleSelf(1.0/cS); // average
          des = tS.sub(pos); // t.sub(pos);
          dist = des.magSquared();
          easS = 1-dist/ssR; // stronger when near
          des.normalizeTo(maxVel*-1);// negative (separate)
          steer = des.sub(vel);
          steer.normalizeTo(sI*easS);
          acc.addSelf(steer);
        }
      }
    }
  }

  void cohesion(ArrayList<Agent> agents, float cR, float cI) {

    flock(agents, cR, 0, 0, cI, 0, 0);
  }

  void separation(ArrayList<Agent> agents, float sR, float sI) {
    flock(agents, 0, 0, sR, 0, 0, sI);
  }

  void alignment(ArrayList<Agent> agents, float aR, float aI) {
    flock(agents, 0, aR, 0, 0, aI, 0);
  }

  void move() {
    vel.addSelf(acc);
    vel.limit(maxVel);
    pos.addSelf(vel);
    acc = new Vec3D();
  }

  void movePerp(Vec3D a, Vec3D b) {
    vel = getNormalVel(a, b, false);
    pos.addSelf(vel);
  }

  //_______ seek methods

  void seek(Attractor t) {
    Vec3D des = t.pos.sub(pos); // t.sub(pos);
    float dsq=des.magSquared();
    if (dsq<t.rr) {
      des.normalizeTo(maxVel);
      Vec3D steer = des.sub(vel);
      steer.normalizeTo(map((t.rr-dsq)/t.rr, 0, 1, 0.1*t.charge, 0.8*t.charge));
      acc.add(steer);
    }
  }

  void seek(Vec3D t) {
    Vec3D des = t.sub(pos); // t.sub(pos);
    des.normalizeTo(maxVel);
    Vec3D steer = des.sub(vel);
    steer.normalizeTo(maxForce);
    acc.addSelf(steer);
  }

  Vec3D getNormalVel(Vec3D a, Vec3D b, boolean overshoot) {
    Vec3D np = getNormalPoint(pos, a, b, overshoot);
    Vec3D nv = pos.sub(np);
    nv.normalizeTo(maxVel);

    Vec3D axis = getTNBFrame(a, b)[1];

    nv.rotateAroundAxis(axis, PI*0.5);
    return nv;
  }

  Vec3D getNormalPoint(Vec3D p, Vec3D a, Vec3D b, boolean overshoot) {
    float segLen = a.distanceTo(b);
    // vector that points from a to p
    Vec3D ap = p.sub(a);
    // vector that points from a to b
    Vec3D ab = b.sub(a);

    //[full] Using the dot product for scalar projection
    ab.normalizeTo(ap.dot(ab.normalize()));
    //[end]
    // Finding the normal point along the line segment
    Vec3D normalPoint = a.add(ab);
    // checks if the point overshoots the extremities of the segment, in which case it returns the closest extremity
    if (!overshoot) {
      if (normalPoint.distanceTo(a) > segLen) { 
        return b;
      } else if (normalPoint.distanceTo(b) > segLen) {
        return a;
      } else {
        return normalPoint;
      }
    } else {
      return normalPoint;
    }
  }

  Vec3D[] getTNBFrame(Vec3D a, Vec3D b) {
    // gets the Frenet-Serret frame for a segment
    // also known as TNB frame (tangent, normal, binormal)
    if (a != b) {
      Vec3D[] tnb = new Vec3D[3];
      // tangent
      Vec3D t = b.sub(a).normalize();
      // normal
      Vec3D n = t.cross(a.add(b).normalize()).normalize();
      // binormal
      Vec3D bn = t.cross(n).normalize();
      tnb[0] = t;
      tnb[1] = n;
      tnb[2] = bn;
      return tnb;
    } else return null;
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
    if (frameCount % freq == 0) { 
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
    float vM = vel.magSquared()/(maxVel*maxVel);
    stroke(lerpColor(color(255, 0, 0), color(0), vM));
    strokeWeight(0.5);
    //ellipse(pos.x, pos.y, sR, sR);
    strokeWeight(2);
    point(pos.x, pos.y, pos.z);
  }



  void dispTrail() {
    stroke(0, 100);
    strokeWeight(1);
    for (Vec3D p : trail) point(p.x, p.y, p.z);
  }

  void dispTrailCurve() {
    stroke(0, 100);
    strokeWeight(1);
    Vec3D p, p1;
    for (int i=0; i<trail.size()-1; i++) {
      p=trail.get(i);
      p1 =trail.get(i+1);
      if (p.distanceToSquared(p1)<10000) { // avoid drawing trail when wrapping
        line(p.x, p.y, p.z, p1.x, p1.y, p1.z);
      }
    }
  }

  void disptrailV() {
    stroke(0, 100);
    strokeWeight(1);
    Vec3D p, p1;
    for (int i=0; i<trail.size(); i++) {
      p=trail.get(i);
      p1 =trailV.get(i).add(p);
      line(p.x, p.y, p.z, p1.x, p1.y, p1.z);
    }
  }
}