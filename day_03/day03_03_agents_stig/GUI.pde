void checkOverlap() { //controlla se il mouse è sull'interfaccia
  if (c5.isMouseOver()) cam.setActive(false);
  else cam.setActive(true);
}

void dispGUI() {
  cam.beginHUD();

  c5.draw();
  textSize(10);
  fill(255, 0, 0);
  text(frameCount, 10, height-10);

  cam.endHUD();
}

void initGui() {
  CColor gray = new CColor(color(180), color(20), color(200), color(0), color(255));  //dichiaro variabile
  float x=10, y = 20;
  int w=200, h=10;
  float dY = h+10;

  c5.setAutoDraw(false);

  c5.addSlider("cohesionRadius")
    .setLabel("Cr")
    .setPosition(x, y)
    .setWidth(w).setHeight(h)
    .setRange(50, 300).setValue(cR)
    .setColor(gray);
    //.getCaptionLabel().getStyle().marginLeft=-30;

  y+=dY;
  c5.addSlider("cohesionIntensity")
    .setLabel("Ci")
    .setPosition(x, y)
    .setWidth(w).setHeight(h)
    .setRange(0.01, 0.20).setValue(cI)
    .setColor(gray);
    //.getCaptionLabel().getStyle().marginLeft=-30;
    
  y+=dY;
  
  y+=dY;
  c5.addSlider("alignmentRadius")
    .setLabel("Ar")
    .setPosition(x, y)
    .setWidth(w).setHeight(h)
    .setRange(10, 50).setValue(aR)
    .setColor(gray);
    //.getCaptionLabel().getStyle().marginLeft=-30;

  y+=dY;
  c5.addSlider("alignmentIntensity")
    .setLabel("Ai")
    .setPosition(x, y)
    .setWidth(w).setHeight(h)
    .setRange(0.01, 0.15).setValue(aI)
    .setColor(gray);
    //.getCaptionLabel().getStyle().marginLeft=-30;
    
  y+=dY;
  
  y+=dY;
  c5.addSlider("separationRadius")
    .setLabel("Sr")
    .setPosition(x, y)
    .setWidth(w).setHeight(h)
    .setRange(1, 10).setValue(sR)
    .setColor(gray);
    //.getCaptionLabel().getStyle().marginLeft=-30;

  y+=dY;
  c5.addSlider("separationIntensity")
    .setLabel("Si")
    .setPosition(x, y)
    .setWidth(w).setHeight(h)
    .setRange(0.1, 3).setValue(sI)
    .setColor(gray);
    //.getCaptionLabel().getStyle().marginLeft=-30;
}

void cohesionRadius(float value) { //variabile !!
  cR=value;
}

void cohesionIntensity(float value) {
  cI=value;
}

void alignmentRadius(float value) {
  aR=value;
}

void alignmentIntensity(float value) {
  aI=value;
}

void separationRadius(float value) {
  sR=value;
}

void separationIntensity(float value) {
  sI=value;
}