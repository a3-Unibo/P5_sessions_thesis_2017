/*

 Basic class Agent with seek behavior, cohesion+separation
 
 mouse pressed - trigger mouse seek behavior
 i - save image
 
*/


Agent a;
PVector t;
int nAgents = 1000;
ArrayList <Agent>Agents;


void setup() {
  size(800, 800);
  surface.setSize(displayWidth-20, displayHeight-50); // how to resize a window
  
  Agents = new ArrayList<Agent>();

  for (int i=0; i<nAgents; i++) {
    a = new Agent(new PVector(random(width), random(height)), PVector.random2D().mult(random(3)));
    Agents.add(a);
  }
  t = new PVector(10, 10);
}



void draw() {
  //background(0);
  t = new PVector(mouseX, mouseY);
  for (Agent ag : Agents) {// < altro modo di iterare
    if (mousePressed) ag.seek(t);
    ag.update();
    ag.display();
  }
  noStroke();
  fill(0, 20);
  rect(0, 0, width, height);
}

void keyPressed() {
  if (key=='i')saveFrame("img/flock_####.png");
}