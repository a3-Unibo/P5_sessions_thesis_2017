/*

Agent based flocking with and without easing - using a triangle shape for display

e - toggles easing behavior (green - on, red - off)
i - save image

*/

Agent a;
ArrayList<Agent> agents;
int nAgents = 1000;
PVector t;

boolean easing = false;

void setup() {
  size(800, 800);
  surface.setSize(displayWidth-20, displayHeight-50);
  agents = new ArrayList<Agent>();

  for (int i=0; i< nAgents; i++) {
    a = new Agent(new PVector(random(width), random(height)), 
      PVector.random2D().mult(random(3)));
    agents.add(a);
  }
  t = new PVector(10, 10);
  background(60);
}

void draw() {
  //background(0);
  t = new PVector(mouseX, mouseY);
  for (Agent ag : agents) {// < altro modo di iterare 
    if (mousePressed)ag.seek(t, 3);
    ag.update(easing);
    ag.displayTri(3, easing);
  }
  
  // noStroke();
  // fill(60,10);
  // rect(0,0,width,height);

}

void keyPressed() {
  if (key == 'i') saveFrame("img/flock_####.png");
  if (key=='e') easing = !easing;
}