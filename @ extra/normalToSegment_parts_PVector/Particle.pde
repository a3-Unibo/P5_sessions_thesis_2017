class Particle {

  PVector pos, vel, acc;
  float maxVel;


  Particle(PVector pos, PVector vel) {
    this.pos = pos;
    this.vel = vel;
    acc = new PVector();
    maxVel = 1.5;

  }

  Particle() {
    this(new PVector(random(width), random(height)), PVector.random2D());
  }


  void move() {
    vel.add(acc);
    vel.limit(maxVel);
    pos.add(vel);
    acc = new PVector();
  }

  void movePerp() {
    vel = getNormalVel(a, b, false);
    pos.add(vel);
  }


  PVector getNormalVel(PVector a, PVector b, boolean overshoot) {
    PVector np = getNormalPoint(pos, a, b, overshoot);
    PVector nv = PVector.sub(pos, np);
    nv.setMag(maxVel);
    nv.rotate(PI*0.5);
    return nv;
  }

  PVector getNormalPoint(PVector p, PVector a, PVector b, boolean overshoot) {
    float segLen = a.dist(b);
    // PVector that points from a to p
    PVector ap = PVector.sub(p, a);
    // PVector that points from a to b
    PVector ab = PVector.sub(b, a);

    //[full] Using the dot product for scalar projection
    ab.normalize();
    ab.setMag(ap.dot(ab));
    //[end]
    // Finding the normal point along the line segment
    PVector normalPoint = PVector.add(a, ab);
    // checks if the point overshoots the extremities of the segment, in which case it returns the closest extremity
    if (!overshoot) {
      if (normalPoint.dist(a) > segLen) { 
        return b;
      } else if (normalPoint.dist(b) > segLen) {
        return a;
      } else {
        return normalPoint;
      }
    } else {
      return normalPoint;
    }
  }

  void display() {
    float vM = vel.mag()/maxVel;
    stroke(lerpColor(color(255, 0, 0), color(0), vM), 100);
    strokeWeight(0.5);
    dispVec(vel, 5);
    //ellipse(pos.x, pos.y, sR, sR);
    strokeWeight(4);
    point(pos.x, pos.y);
  }

  void dispVec(PVector v, float m) {
    line(pos.x, pos.y, pos.x+v.x*m, pos.y+v.y*m);
  }
}