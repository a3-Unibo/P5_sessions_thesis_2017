// Octree initialization

PointOctree initOctree(Vec3D pivot, Vec3D extent) {
  PointOctree octree;

  octree = new PointOctree(pivot, 1);  // centers octree in mesh bounding box
  octree.setExtent(extent); // scales to mesh bounding box with some abundance

  for (Vertex v : mesh.vertices.values()) {
    octree.addPoint(v);
  }
  return octree;
}

PointOctree initOctree(TriangleMesh mesh) {
  PointOctree octree;
  AABB bBox = mesh.getBoundingBox();
  extent = mesh.getBoundingBox().getExtent(); // AABB diagonal vector
  pivot = bBox.getMin().add(bBox.getMax()).scale(0.5); // finds mesh pivot (the AABB center)
  octree = initOctree(pivot, extent);
  return octree;
}


// display

void octDisplay(PointOctree octree) {
  stroke(200, 0, 0);
  strokeWeight(3);
  for (Vec3D v : octree.getPoints()) {
    point(v.x, v.y, v.z);
  }
}

void octDisplay(PShape o) {
  shape(o, 0, 0);
}

// stores Octree Points in a PShape (faster display)

PShape octShape(PointOctree octree, color stroke, float weight) {

  PShape o = createShape();

  o.beginShape(POINTS);
  o.stroke(stroke);
  o.strokeWeight(weight);
  for (Vec3D v : octree.getPoints()) {
    o.vertex(v.x, v.y, v.z);
  }
  o.endShape();

  return o;
}