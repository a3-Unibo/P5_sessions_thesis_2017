/*

Agent based flocking with and without easing

e - toggles easing behavior (green - on, red - off)
i - save image

*/

Agent a;
PVector t;
int nAgents = 1000;
ArrayList <Agent> agents;

boolean easing = false;


void setup() {
  size(800, 800);
  surface.setSize(displayWidth-20, displayHeight-50); // 
  agents = new ArrayList<Agent>();

  for (int i=0; i<nAgents; i++) {
    a = new Agent(new PVector(random(width), random(height)),
    PVector.random2D().mult(random(3)));
    agents.add(a);
  }
  t = new PVector(10, 10);
}



void draw() {
  //background(255);
  t = new PVector(mouseX, mouseY);
  for (Agent ag : agents) {// < altro modo di iterare
    if (mousePressed) ag.seek(t, 5); // << seeks with a charge
    ag.update(easing); 
    ag.display(easing);
  }
  noStroke();

  // instead of using background() - for a nice fading effect
  fill(255, 15);
  rect(0, 0, width, height);

}

void keyPressed() {
  if (key=='i')saveFrame("img/flock_####.png");
  if (key=='e') easing = !easing;
}