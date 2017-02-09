

void setup() {

  size(800, 600);
}


void draw() {

  background(0, 100, 100);
  stroke(255);
  strokeWeight(1);
  quadTree(new PVector(mouseX, mouseY), 0, 0, width, height, 7);
}

void quadTree(PVector p, float x, float y, float w, float h, int gen) {
  if (gen>0) {
    if (p.x>x && p.x <x+w && p.y>y && p.y<y+h) {
      line(x, y+h*0.5, x+w, y+h*0.5);
      line(x+w*0.5, y, x+w*0.5, y+h);
      quadTree(p,x,y,w*0.5, h*0.5, gen-1); // alto-sinistra
      quadTree(p,x+w*0.5,y,w*0.5, h*0.5, gen-1); // alto-destra
      quadTree(p,x,y+h*0.5,w*0.5, h*0.5, gen-1); // basso-sinistra
      quadTree(p,x+w*0.5,y+h*0.5,w*0.5, h*0.5, gen-1); // basso-destra
    }
  }
}