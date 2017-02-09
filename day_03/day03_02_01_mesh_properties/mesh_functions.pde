// Mesh helping functions

TriangleMesh importMesh(String fileName) {
  TriangleMesh mesh = new TriangleMesh();
  mesh.addMesh(new STLReader().loadBinary(sketchPath(fileName), // remember to put the full path
    STLReader.TRIANGLEMESH));
  return mesh;
}



// mesh topology
void computeMeshTopo(TriangleMesh mesh) {
  // note: it could be called Tri(cera)Top(o)s < a new mesh tool in GH?

  // create empty map
  for (int i=0; i<mesh.vertices.size(); i++) {
    HashSet<Integer> empty = new HashSet<Integer>();
    meshTopo.put(i, empty);
  }

  for (Face f : mesh.faces) {
    // add connections for vertex a
    HashSet<Integer> a = meshTopo.get(f.a.id);
    a.add(f.b.id);
    a.add(f.c.id);
    meshTopo.put(f.a.id, a);
    // add connections for vertex b
    HashSet<Integer> b = meshTopo.get(f.b.id);
    b.add(f.a.id);
    b.add(f.c.id);
    meshTopo.put(f.b.id, b);
    // add connections for vertex c
    HashSet<Integer> c = meshTopo.get(f.c.id);
    c.add(f.a.id);
    c.add(f.b.id);
    meshTopo.put(f.c.id, c);
  }
}

Vertex[] getNeighbors(int id, TriangleMesh m) {

  HashSet n = meshTopo.get(id);
  int nn = n.size();
  Vertex[] neighbors = new Vertex[nn];
  int i=0;
  for (Iterator it = n.iterator(); it.hasNext(); ) {
    neighbors[i] = mesh.getVertexForID((int)it.next());    
    i++;
  }

  return neighbors;
}

Vertex[] getNeighbors(Vertex v, TriangleMesh m) {

  HashSet n = meshTopo.get(v.id);
  int nn = n.size();
  Vertex[] neighbors = new Vertex[nn];
  int i=0;
  for (Iterator it = n.iterator(); it.hasNext(); ) {
    neighbors[i] = mesh.getVertexForID((int)it.next());    
    i++;
  }

  return neighbors;
}

// display

void neighDisplay(Vertex v, TriangleMesh mesh) {
  Vertex[] neigh = getNeighbors(v, mesh);
  stroke(0, 255, 0);
  strokeWeight(5);
  Vec3D p;
  for (int i=0; i< neigh.length; i++) {
    p = neigh[i];
    point(p.x, p.y, p.z);
  }
}

void neighDisplay(int id, TriangleMesh mesh) {
  Vertex[] neigh = getNeighbors(id, mesh);
  stroke(0, 255, 0);
  strokeWeight(5);
  Vec3D p;
  for (int i=0; i< neigh.length; i++) {
    p = neigh[i];
    point(p.x, p.y, p.z);
  }
}

void meshDisplay(TriangleMesh mesh, int viewMode) {

  switch(viewMode) { //alike stream gates in GH
  case 0:
    pushStyle();
    fill(255,20);
    stroke(0, 100, 100, 100);
    strokeWeight(1);
    gfx.mesh(mesh, true);
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
    strokeWeight(2);
    for (Vertex v : mesh.vertices.values()) {
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
  }
}