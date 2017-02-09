import toxi.geom.*;

Particle pa;
Vec3D a, b, m, n, mn, vel;
boolean overshoot = false;

void setup() {
  size(800, 800, P2D);
  smooth();
  a = new Vec3D(200, 300, 0);
  b = new Vec3D(width-200, height-300, 0);
  vel = Vec3D.randomVector().scale(5);
  vel.z = 0;
  pa = new Particle(new Vec3D(100, 300, 0), vel);
}

void draw() {
  background(80);
  stroke(0);
  line(a.x, a.y, b.x, b.y);
  n = getNormalPoint(pa.pos, a, b, overshoot);
  ellipse(n.x, n.y, 5, 5);
  stroke(255, 200);
  line(pa.pos.x, pa.pos.y, n.x, n.y);
  updatePart(pa, a, b);

  if (mousePressed && mouseButton == LEFT) {
    stroke(0, 60);
    m = new Vec3D(mouseX, mouseY, 0);
    mn = getNormalPoint(m, a, b, overshoot);
    line(m.x, m.y, mn.x, mn.y);
  }
}

void updatePart(Particle pa, Vec3D a, Vec3D b) {
  pa.movePerp(a, b);
  pa.updateTrail(5);
  pushStyle();
  pa.display();
  pa.dispTrail();
  popStyle();
}


Vec3D getNormalPoint(Vec3D p, Vec3D a, Vec3D b, boolean overshoot) {
  float segLen = a.distanceToSquared(b);
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
    if (normalPoint.distanceToSquared(a) > segLen) { 
      return b;
    } else if (normalPoint.distanceToSquared(b) > segLen) {
      return a;
    } else {
      return normalPoint;
    }
  } else {
    return normalPoint;
  }
}

void keyPressed() {
  if (key=='o' || key =='O') overshoot = !overshoot;
}