class Particle {

  Vec3D pos, vel, acc;
  ArrayList<Vec3D>trail, trailV;
  int nTrail;
  float maxVel;


  Particle(Vec3D pos, Vec3D vel) {
    this.pos = pos;
    this.vel = vel;
    acc = new Vec3D();
    trail = new ArrayList<Vec3D>();
    trailV = new ArrayList<Vec3D>();
    nTrail= 50;
    maxVel = 5;
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
    float vM = vel.magSquared()/(maxVel*maxVel);
    stroke(lerpColor(color(255, 0, 0), color(0), vM));
    strokeWeight(0.5);
    //ellipse(pos.x, pos.y, sR, sR);
    strokeWeight(2);
    point(pos.x, pos.y, pos.z);
  }

  void dispTrail() {
    stroke(255, 200);
    strokeWeight(1);
    for (Vec3D p : trail) point(p.x, p.y, p.z);
  }
}