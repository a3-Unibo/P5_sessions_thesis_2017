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

  c5.addSlider("cR") // <<< use the variable name here
    .setLabel("Cr")
    .setPosition(x, y)
    .setWidth(w).setHeight(h)
    .setRange(50, 300).setValue(cR)
    .setColor(gray);
    //.getCaptionLabel().getStyle().marginRight=130;

  y+=dY;
  c5.addSlider("cI")
    .setLabel("Ci")
    .setPosition(x, y)
    .setWidth(w).setHeight(h)
    .setRange(0.01, 0.20).setValue(cI)
    .setColor(gray);
    //.getCaptionLabel().getStyle().marginLeft=-30;
    
  y+=dY;
  
  y+=dY;
  c5.addSlider("aR")
    .setLabel("Ar")
    .setPosition(x, y)
    .setWidth(w).setHeight(h)
    .setRange(10, 50).setValue(aR)
    .setColor(gray);
    //.getCaptionLabel().getStyle().marginLeft=-30;

  y+=dY;
  c5.addSlider("aI")
    .setLabel("Ai")
    .setPosition(x, y)
    .setWidth(w).setHeight(h)
    .setRange(0.01, 0.15).setValue(aI)
    .setColor(gray);
    //.getCaptionLabel().getStyle().marginLeft=-30;
    
  y+=dY;
  
  y+=dY;
  c5.addSlider("sR")
    .setLabel("Sr")
    .setPosition(x, y)
    .setWidth(w).setHeight(h)
    .setRange(1, 10).setValue(sR)
    .setColor(gray);
    //.getCaptionLabel().getStyle().marginLeft=-30;

  y+=dY;
  c5.addSlider("sI")
    .setLabel("Si")
    .setPosition(x, y)
    .setWidth(w).setHeight(h)
    .setRange(0.1, 3).setValue(sI)
    .setColor(gray);
    //.getCaptionLabel().getStyle().marginLeft=-30;
  // ______________________ buttons and toggles

  y+=dY*2;
  int bW=35;
  int bS = 55;
  c5.addToggle("attract")
    .setLabel("attract")
    .setPosition(x, y)
    .setWidth(bW).setHeight(h)
    .setColor(gray);

  c5.addToggle("tDisp")
    .setLabel("trails")
    .setPosition(x+bS, y)
    .setWidth(bW).setHeight(h)
    .setColor(gray);


  c5.addToggle("trailMode")
    .setLabel("trail mode")
    .setPosition(x+bS*2, y)
    .setWidth(bW).setHeight(h)
    .setColor(gray);

  c5.addButton("saveImg") // << the button calls the function saveImg
    .setLabel("img")
    .setPosition(x+bS*3, y)
    .setWidth(bW).setHeight(h)
    .setColor(gray)
    .getCaptionLabel().getStyle().marginTop=13;
}

void saveImg(int val) {
  // val (1) is returned each time the button is pressed
  saveFrame("img/flock_####.png");
}