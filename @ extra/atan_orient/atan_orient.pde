
/* 
 

 tutor: Alessio Erioli
 
 Simple use of PShape with a .svg file
 
 */

PShape s;
PVector p;

void setup() {
  size(800, 800);
  //shapeMode(CENTER); // does weird stuff with scale - use the following lines instead
  s = loadShape("North_Pointer.svg"); // load the .svg file
  
  s.scale(0.2); // scale it if too big for your purpose
  s.translate(-s.width/2, -s.height/2); // center the shape
  stroke(0);
  strokeWeight(5);
  
  noCursor(); // removes mouse cursor
  
}


void draw() {
  background(230);
  // a point moves along a Lissajous figure
  p = new PVector(width/2+300*cos(frameCount * 0.03), height/2 + +300*cos(frameCount * 0.0173));
  point(p.x, p.y);
  
  float angle = atan2(mouseY-p.y, mouseX-p.x)-PI/2;
  translate(mouseX, mouseY);
  rotate(angle);
  shape(s, 0, 0);
}