// Mesh helping functions

void meshDisplay(AEMesh mesh, int viewMode) {

  switch(viewMode) { //alike stream gates in GH
  case 0:
    pushStyle();
    fill(55);
    lightSpecular(230, 255, 255);
    directionalLight(255, 255, 255, -1, -1, -1);
    directionalLight(55, 55, 55, 1, 1, 1);
    shininess(1.0);
    //stroke(0, 100, 100, 100);
    stroke(200,20);
    strokeWeight(1);
    gfx.mesh(mesh, false);
    noLights();
    popStyle();
    break;
  case 1:
    pushStyle();
    noStroke();
    gfx.meshNormalMapped(mesh, true);
    int i=0;
    stroke(0, 80);
    strokeWeight(1);
    for (Vertex v : mesh.vertices.values()) {
      norm = v.normal.scale(5); // normals are a field of Vertex
      line(v.x, v.y, v.z, v.x+norm.x, v.y+norm.y, v.z+norm.z);
      i++;
    }
    popStyle();
    break;
  case 2:
    pushStyle();
    noFill();
    stroke(0);
    strokeWeight(5);
    for (Vertex v : mesh.vertices.values()) {
      stroke(mesh.vCols[v.id]);
      point(v.x, v.y, v.z);
    }
    popStyle();
    break;
  case 3:
    pushStyle();
    noFill();
    stroke(255, 0, 0);
    strokeWeight(2);
    fill(0);
    textSize(2);
    for (Vertex v : mesh.vertices.values()) {
      point(v.x, v.y, v.z);
      textAtPoint(v, str(v.id), cam);
    }
    popStyle();
    break;
  case 4:
    shape(cMesh, 0, 0);
    break;
  }
}

void drawFace(AEMesh m, int fi, color col) {
  try {
    Face f = m.faces.get(fi);
    Vec3D a, b, c;
    a = m.getVertexForID(f.a.id);
    b = m.getVertexForID(f.b.id);
    c = m.getVertexForID(f.c.id);

    beginShape();
    fill(col);
    noStroke();
    vertex(a.x, a.y, a.z);
    vertex(b.x, b.y, b.z);
    vertex(c.x, c.y, c.z);
    endShape(CLOSE);
  }
  catch(Exception e) {
    println("face index not valid");
  }
}

void drawFace(AEMesh m, Face f, color col) {
  try {
    Vec3D a, b, c;
    a = m.getVertexForID(f.a.id);
    b = m.getVertexForID(f.b.id);
    c = m.getVertexForID(f.c.id);

    beginShape();
    fill(col);
    noStroke();
    vertex(a.x, a.y, a.z);
    vertex(b.x, b.y, b.z);
    vertex(c.x, c.y, c.z);
    endShape(CLOSE);
  }
  catch(Exception e) {
    println("face not valid");
  }
}

void drawFace(AEMesh m, Face f) {
  try {
    Vec3D a, b, c, n;
    a = m.getVertexForID(f.a.id);
    b = m.getVertexForID(f.b.id);
    c = m.getVertexForID(f.c.id);
    n = f.normal;

    beginShape(TRIANGLES);
    normal(n.x, n.y, n.z);
    noStroke();
    fill(m.vCols[f.a.id]);
    vertex(a.x, a.y, a.z);
    fill(m.vCols[f.b.id]);
    vertex(b.x, b.y, b.z);
    fill(m.vCols[f.c.id]);
    vertex(c.x, c.y, c.z);
    endShape();
  }
  catch(Exception e) {
    println("face not valid");
  }
}

void drawFace(AEMesh m, int fi) {
  try {
    Face f = m.faces.get(fi);
    Vec3D a, b, c, n;
    a = m.getVertexForID(f.a.id);
    b = m.getVertexForID(f.b.id);
    c = m.getVertexForID(f.c.id);
    n = f.normal;

    beginShape(TRIANGLES);
    normal(n.x, n.y, n.z);
    noStroke();
    fill(m.vCols[f.a.id]);
    vertex(a.x, a.y, a.z);
    fill(m.vCols[f.b.id]);
    vertex(b.x, b.y, b.z);
    fill(m.vCols[f.c.id]);
    vertex(c.x, c.y, c.z);
    endShape();
  }
  catch(Exception e) {
    println("face not valid");
  }
}

void drawNeighborFaces(AEMesh m, int id) {
  try {
    int[] ff = m.getConnectedFaces(id);
    for (int i=0; i<ff.length; i++) {
      drawFace(m, ff[i]);
      //drawFace(m,ff[i],color(255,0,0));
    }
  }
  catch(Exception e) {
  }
}

PShape colorMesh(AEMesh m) {

  PShape cm = createShape(GROUP);
  PShape faceShape;
  for (Face f : m.faces) {
    Vec3D a, b, c, n;
    a = m.getVertexForID(f.a.id);
    b = m.getVertexForID(f.b.id);
    c = m.getVertexForID(f.c.id);
    n = f.normal;
    faceShape = createShape();
    faceShape.beginShape(TRIANGLES);
    faceShape.normal(n.x, n.y, n.z);
    //faceShape.noStroke();
    faceShape.stroke(200,20);
    faceShape.fill(m.vCols[f.a.id]);
    faceShape.vertex(a.x, a.y, a.z);
    faceShape.fill(m.vCols[f.b.id]);
    faceShape.vertex(b.x, b.y, b.z);
    faceShape.fill(m.vCols[f.c.id]);
    faceShape.vertex(c.x, c.y, c.z);
    faceShape.endShape();
    cm.addChild(faceShape);
  }

  return cm;
}