import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.processing.*;
import peasy.*;
import java.util.*;

PeasyCam cam;

PFont font;

TriangleMesh mesh;
AEMesh aMesh;
AABB bBox;
HashMap<Integer, HashSet<Integer>> meshTopo = new HashMap<Integer, HashSet<Integer>>();
ToxiclibsSupport gfx;
PointOctree octree;
PShape octPts;

Vec3D norm;
Vec3D vS, pivot, extent;

float octreeSampleDist=0;
float octreeSampleIncrement = 0.01;
int nVerts, id=0;
int viewMode = 0;
boolean invY=false;
boolean viewOct=false;

void setup() {

  size(1400, 900, P3D);

  //
  // _______________________________ camera settings _______________________________
  //
  //
  cam = new PeasyCam(this, 600);
  float fov = PI/3.0; // stare tra i 2 e i 4
  float cameraZ = (height/2.0) / tan(fov/2.0);
  //           fov         ratio                  near clip     far clip
  //            |            |                        |            |
  perspective(fov, float(width)/float(height), cameraZ/100.0, cameraZ*100.0);

  //
  // _______________________________ font settings _______________________________
  //
  //
  // create a font for a better text display - install Open Sans if you haven't already
  // or use "Arial" instead
  font =createFont("Open Sans", 50);
  textFont(font); //use the created font for text
  textSize(10);

  //
  // _______________________________ mesh settings _______________________________
  //
  //

  gfx = new ToxiclibsSupport(this);

  mesh = importMesh("data/spheres_fused.stl"); // see mesh functions
  
  aMesh.addMesh(new STLReader().loadBinary(sketchPath("data/spheres_fused.stl"), // remember to put the full path
    STLReader.TRIANGLEMESH));

  mesh.scale(10); // the mesh is very small in terms of units
  mesh.computeVertexNormals();
  mesh.computeFaceNormals();

  nVerts = mesh.vertices.size();
  vS = mesh.getVertexForID(id);

  bBox = mesh.getBoundingBox(); // the mesh bounding box
  extent = mesh.getBoundingBox().getExtent(); // AABB diagonal vector
  pivot = bBox.getMin().add(bBox.getMax()).scale(0.5); // finds mesh pivot (the AABB center)

  computeMeshTopo(mesh);

  cam.lookAt(pivot.x, pivot.y, pivot.z); // look at pivot


  //
  // _______________________________ octree settings _______________________________
  //
  //

  octree = initOctree(pivot, extent.scale(1.05)); // generates an octree slightly larger than the mesh bounding box

  Face f = mesh.faces.get(0);
  Vertex v0 = mesh.getVertexForID(0);
  boolean initializeOctreeSampleDist=true;
  octPts = octShape(octree, color(200, 0, 0), 3);

  //initialize ocTree sample distance
  while (initializeOctreeSampleDist) {
    octreeSampleDist += octreeSampleIncrement;
    ArrayList<Vec3D> pts00 = new ArrayList <Vec3D>();
    pts00 = (ArrayList<Vec3D>) octree.getPointsWithinSphere(v0, octreeSampleDist);
    if (pts00 == null) pts00 = new ArrayList<Vec3D>();
    if (pts00.size() > 25) {
      initializeOctreeSampleDist = false;
      println("octreeSampleDist set to: " + octreeSampleDist);
    }
  }
}

void draw() {
  background (220);


  // __________________________ mesh section

  lights();

  // equals the coordinate system with those of 3D CAD (such as Rhino, 3DSMax, etc.)
  // usually, shapes are mirrored because Y points down here
  // but messes with thext, so use just as verification
  if (invY)scale(1, -1.1);

  meshDisplay(mesh, viewMode);
  if (viewOct) octDisplay(octPts); // octDisplay(octree);

  noLights();

  // __________________________ bounding box section

  pushMatrix();
  pushStyle();

  noFill();
  strokeWeight(1);
  stroke(255);
  gfx.mesh(octree.toMesh());
  stroke(0, 20);
  gfx.mesh(bBox.toMesh());
  stroke(0, 0, 255);
  strokeWeight(5);
  point(pivot.x, pivot.y, pivot.z);

  // __________________________ "the rest" section

  // draw vertex if viewMode != 3
  if (viewMode !=3) {
    neighDisplay(id, mesh);
    alignAtPoint(vS, cam);
    stroke(255, 0, 0);
    strokeWeight(10);
    point(0, 0, 0);
    fill(0);
    textSize(5);
    text(" __________________ this is vertex "+id, 0, 0);
  }
  popStyle();
  popMatrix();
}


void keyPressed() {
  if (key=='m') viewMode = (viewMode+1)%4; // cycles through viewModes
  if (key =='y')invY = !invY;
  if (key=='v') {
    id= (id+1)%nVerts;
    vS = mesh.getVertexForID(id);
  }
  if (key=='o') viewOct = !viewOct;
}