class Node extends PVector {
  // fields

  PVector vel;
  String id;
  int val; // number of connections
  ArrayList<String> ids; // ids of connected Nodes
  float radius; // node radius
  float charge; // attractive or repulsive charge
  float weight; // spring influence weight
  boolean lock; // lock node

  // constructors

  Node(float x, float y, float z, float charge) {
    super(x, y, z);  // call PVector constructor
    vel = new PVector();
    radius = 20;
    this.charge = charge;
    weight = 1;
    val = 0;
    lock = false;
  }
  
    Node(float x, float y, float z) {
    this(x, y, z, 1);
  }

  Node(float x, float y) {
    this(x, y, 0, 1);
  }

  Node() {
    this(0, 0, 0, 1);
  }


  // methods

  void attract(ArrayList<Node> nodes) {
    for (Node n : nodes) attract(n);
  }

  void attract(Node[] nodes) {
    for (int i=0; i< nodes.length; i++) attract(nodes[i]);
  }

  void attract(Node n) {
    PVector f = PVector.sub(n, this);
    if (f.mag() < (radius+n.radius)){
    f.normalize();
    f.mult(n.charge*-1);
    vel.add(f);
    }
  }

  void update() {
    if (!lock) this.add(vel);
    vel = new PVector();
  }

  // display methods

  void display() {
    pushStyle();
    stroke(255);
    strokeWeight(2);
    noFill();
    //ellipse(x,y,radius*2, radius*2);
    point(x,y,z);
    popStyle();
  }

  void dispVal(boolean dot) {
    pushStyle();
    pushMatrix();
    translate(x,y,z);
    if (dot) {
      stroke(0, 80);
      noFill();
      ellipse(0, 0, 3*val, 3*val);
    }
    fill(0);
    alignToView(cam);
    text(val, 0, 0);
    popMatrix();
    popStyle();
  }
}