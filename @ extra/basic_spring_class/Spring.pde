class Spring {
  public Node a, b;
  public float len, curLen, stiff, damp;

  Spring(Node a, Node b, float len, float stiff, float damp) {
    this.a = a;
    this.b = b;
    this.len = len;
    this.stiff = stiff;
    this.damp = damp;
    curLen = len; // current length (for stress/deformation evaluation)
    a.val ++;
    b.val ++;
  }

  Spring(Node a, Node b) {
    this(a, b, random(100), .1, 0.5); // some default data
  }

  void update() {
    PVector diff = PVector.sub(b, a);
    curLen = diff.mag();
    diff.normalize();
    diff.mult(len);
    PVector target = PVector.add(a, diff);
    PVector force = PVector.sub(target, b);
    force.mult(0.5f); // if nodes have weight the distribution is uneven
    force.mult(stiff);
    force.mult(1-damp);
    b.vel.add(force);
    a.vel.add(PVector.mult(force, -1));
  }

  void display() {
    float red = constrain((curLen-len)/(len*0.5f), 0, 1)*255;
    float blue = constrain((len-curLen)/(len*0.2f), 0, 1)*255;
    color col = color(red, blue,blue);
    //float ratio = constrain(abs(curLen-len)/(len*0.5f), 0, 1); // if current lenght is > +half rest lenght is considered already at max effort
    //color col = lerpColor(color(0, 0, 0, 50), color(255, 0, 0), ratio);
    stroke(col);
    line(a.x, a.y,a.z, b.x, b.y, b.z);
  }
}