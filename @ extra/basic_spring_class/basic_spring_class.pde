import peasy.*;

Node a, b, c, d, dummy;
ArrayList <Spring> s;
ArrayList<Node> nodes;
PVector world;
PeasyCam cam;



void setup() {
  size(800, 800, P3D);
  world = new PVector(1000,1000,600);
  
  PFont font = createFont("Arial", 50);
  textFont(font);
  textSize(10);
  
  s = new ArrayList<Spring>();
  nodes = new ArrayList<Node>();
  
  // add nodes
  a = new Node(width*0.5, height*0.5);
  b = new Node(random(-world.x, world.x), random(-world.y, world.y), random(-world.z, world.z), 2);
  c = new Node(random(-world.x, world.x), random(-world.y, world.y), random(-world.z, world.z), 1.5);
  d = new Node(random(-world.x, world.x), random(-world.y, world.y), random(-world.z, world.z), 0.2);
  dummy = new Node(width*.5, height*.5); // a dummy to center the diagram
  nodes.add(a);
  nodes.add(b);
  nodes.add(c);
  nodes.add(d);
  
  // add springs
  s.add(new Spring(a, b, 100, .2, 0.8));
  s.add(new Spring(a, c, 50, .1, 0.7));
  s.add(new Spring(a, d, 70, .1, 0.5));
  
  cam = new PeasyCam(this,3000); 
  perspective(PI/3.0, float(width)/float(height), 0.001, 10000);
  
  background(221);
}

void draw() {
  background(221);
  for (Spring sp : s) {
    sp.update();
    sp.display();
  }
  
  for (Node n: nodes){
    n.attract(nodes);
    n.update();
    n.display();
    n.dispVal(true);
  }
  stroke(0,20);
  noFill();
  box(world.x*2, world.y*2, world.z*2);
  
  cam.beginHUD();

  //gui();

  cam.endHUD();
}

Node closest(Node a, ArrayList<Node> v) {
  Node r = new Node();
  float dist, minD = Float.MAX_VALUE;

  for (Node p : v) {
    dist = Node.sub(p, a).magSq();
    if (dist < minD) {
      minD = dist;
      r = p;
    }
  }
  return r;
}

void mousePressed() {
  // trace double clicks with RIGHT mouse button only
  if (mouseEvent.getClickCount()==2 && mouseButton==RIGHT) {
    // do something
  }
  if (mouseButton==RIGHT) {
    Node m = new Node(random(-world.x, world.x), random(-world.y, world.y), random(-world.z, world.z), 2);
    Node n = closest(m, nodes);
    //Spring s1 = new Spring(m, n, PVector.sub(n,m).mag() *0.5, .1, 0);
    float dist = PVector.dist(m,n);
    //Spring s1 = new Spring(m, n, 100+random(100), .5, 0.5);
    Spring s1 = new Spring(m, n, random(dist*0.1, dist*1.5), .5, 0.5);
    nodes.add(m);
    s.add(s1);
  }
}