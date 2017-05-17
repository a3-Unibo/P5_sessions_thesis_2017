// Octree initialization

 /*
 note on Octree:
 
 . octree must always be a cube in shape
 . pivot is the lower corner (min coordinates) and extension is the side of a cube
 . must be initialized to its maximum size from the beginning
 
 */

PointOctree initOctreeWorld(Vec3D extent, ArrayList<Vec3D> points) {
  PointOctree octree;
 // finds larger dimension
    float maxDim = extent.x>extent.y? (extent.x > extent.z? extent.x: extent.z):(extent.y > extent.z? extent.y: extent.z);
    // per un Octree più grande moltiplicare maxDim per un fattore > 1 es:
     maxDim *=1.1;
    // il pivot è l'angolo inferiore dell'Octree box
    Vec3D pivot = new Vec3D(-1, -1, -1).scaleSelf(maxDim*0.5);
    octree = new PointOctree(pivot, maxDim);
    octree.setMinNodeSize(10);
    if (points != null)
    octree.addAll(points);
    return octree;
}

// initialization from mesh

PointOctree octreeFromMesh(TriangleMesh mesh) {
  PointOctree octree;
  AABB bBox = mesh.getBoundingBox();
  Vec3D extent = mesh.getBoundingBox().getExtent(); // AABB diagonal vector
  // finds larger dimension
  float maxDim = extent.x>extent.y? (extent.x > extent.z? extent.x: extent.z):(extent.y > extent.z? extent.y: extent.z);

  Vec3D mPivot = bBox.getMin().add(bBox.getMax()).scale(0.5); // finds mesh pivot (the AABB center)

  Vec3D pivot = mPivot.addSelf(new Vec3D(-1, -1, -1).scaleSelf(maxDim)); // find octree pivot

  octree = new PointOctree(pivot, maxDim*2);
  // adds mesh vertices to the Octree
  for (Vertex v : mesh.vertices.values()) {
    octree.addPoint(v);
  }
  return octree;
}

// retrieve vertices

ArrayList<Vertex> getVerts(PointOctree oct, Vec3D p, float r) {

  ArrayList vs = (ArrayList) oct.getPointsWithinSphere(p, r);
  ArrayList<Vertex> verts = (ArrayList<Vertex>) vs;
  return verts;
}

// display


//octree display by Toxi

void drawOctree(PointOctree node, boolean showGrid, int col, float weight) {
  if (showGrid) {
    drawBox(node, col);
  }
  if (node.getNumChildren()>0) {
    PointOctree[] children = node.getChildren();
    for (int i=0; i < 8; i++) {
      if (children[i] != null) {
        drawOctree(children[i], showGrid, col, weight);
      }
    }
  } else {
    java.util.List points = node.getPoints();
    if (points != null) {
      beginShape(POINTS);
      stroke(col);
      strokeWeight(weight);
      for (Vec3D v : node.getPoints()) {
        vertex(v.x, v.y, v.z);
      }
      endShape();
    }
  }
}

void drawBox(PointOctree other, int col) {
  noFill();
  stroke(col, 24);
  strokeWeight(1);
  pushMatrix();
  translate(other.x, other.y, other.z);
  box(other.getSize());
  popMatrix();
}