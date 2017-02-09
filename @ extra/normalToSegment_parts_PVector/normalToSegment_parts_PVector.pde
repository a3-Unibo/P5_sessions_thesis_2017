Particle pa;
PVector a, b, m, n, mn;
boolean overshoot = false;

void setup() {
  size(800, 800, P2D);
  smooth();
  a = new PVector(200, 300);
  b = new PVector(width-200, height-300);
  pa = new Particle(new PVector(100, 200), PVector.random2D());
}

void draw() {
  background(80);
  stroke(0);
  line(a.x, a.y, b.x, b.y);
  m = new PVector(mouseX, mouseY);
  n = getNormalPoint(pa.pos, a, b, overshoot);
  stroke(255,200);

  line(pa.pos.x, pa.pos.y, n.x, n.y);
  if (mousePressed && mouseButton == LEFT) {
    stroke(0,60);
    mn = getNormalPoint(m, a, b, overshoot);
    line(m.x, m.y, mn.x, mn.y);
  }
  pa.movePerp();
  pushStyle();
  pa.display();
  popStyle();
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

void keyPressed() {
  if (key=='o' || key =='O') overshoot = !overshoot;
}