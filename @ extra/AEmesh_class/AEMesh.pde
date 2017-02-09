/*

 Code by Alessio Erioli
 
 (c) Co-de-iT 2017
 
 an extension to the TriangleMesh class with topology functions implemented
 
 . neighbor vertices from a given vertex or vertex id
 . indexes of faces shared by a vertex
 
 also, some extra functions to ease the loading from file process:
 
 . a constructor where the only thing to supply is the fileName string
 NOTE: fileName must include extension
 Mesh files MUST be in STL format
 
 
 FUTURE IMPLEMENTATIONS
 
 . mesh closest point function (point projection)
 
 */


class AEMesh extends TriangleMesh {

  final int STL = 0;
  final int PLY = 1;
  HashMap<Integer, HashSet<Integer>> vTopo;
  HashMap<Integer, HashSet<Integer>> vfTopo;
  HashMap<Integer, Long> vCol;
  color[] vCols;
  // int[]indexMap;
  String vColFileName;

  AEMesh() {
    super();
    vTopo = new HashMap<Integer, HashSet<Integer>>();
    vfTopo = new HashMap<Integer, HashSet<Integer>>();
  }

  AEMesh(String fileName) {
    this();

    String fileType = fileName.substring(fileName.length()-3, fileName.length());
    vColFileName = split(fileName, ".")[0]+"_vCols.txt";

    if (fileType.equals("stl") || fileType.equals("STL")) {
      importSTLMesh(fileName); // imports mesh
      computeVertexTopo();  // builds connected vertex topology
      computeVertexFaceTopo(); // builds connected faces to vertex topology
      vCols = new color[vertices.size()]; // builds color table
      // indexMap = new int[vertices.size()]; // just for verification (delete in the final)
      buildColorTable(true);
    } else println("non-stl files still not implemented");
  }

  //
  // ______________________ simplified import function ______________________
  //

  void importSTLMesh(String fileName) {
    addMesh(new STLReader().loadBinary(dataPath(fileName), STLReader.TRIANGLEMESH));
  }

  void buildColorTable(boolean fast) {
    if (fileExists(dataPath(vColFileName))) {
      print("loading color table from file....");
      String[] lines = loadStrings(dataPath(vColFileName));
      if (lines.length == vertices.size()) {
        vCols = int(loadStrings(dataPath(vColFileName)));
      } else {
        int ind;
        Vec3D p;
        for (int i=0; i< lines.length; i++) {
          String[] ptCol = split(lines[i], '_');
          String[] pt = split(ptCol[0], ',');
          p = new Vec3D(float(pt[0]), float(pt[1]), float(pt[2]));
          ind = getClosestVertexToPoint(p).id;
          // if (i<vertices.size()) indexMap[i]=ind;
          vCols[ind] = int(ptCol[1]);
          println(ind + " " + i);
        }
      }

      //vCols = int(loadStrings(dataPath(vColFileName)));
      println("done");
    } else {
      /*
      print("building color table...");
       for (int i=0; i< vertexCount; i++) {
       Vertex v = getClosestVertexToPoint(vertices[i]);
       vColors[v.id]=vertexColors[i];
       if (i%(int(vertexCount/20))==0) {
       print(nfs(100*(float)i/(float)vertexCount, 3, 0)+"% ");
       }
       }
       println("done");
       print("saving color table...");
       SaveColTable(vColors, vColFileName);
       */
    }
  }

  boolean fileExists(String fName) {
    File f = new File(fName);
    return (f.exists()? true: false);
  }


  //
  // ______________________ mesh topology methods ______________________
  //

  void computeVertexTopo() {
    // vertex neighbors

    // create empty map
    for (int i=0; i<vertices.size(); i++) {
      HashSet<Integer> empty = new HashSet<Integer>();
      vTopo.put(i, empty);
    }

    for (Face f : faces) {
      // add connections for vertex a
      HashSet<Integer> a = vTopo.get(f.a.id);
      a.add(f.b.id);
      a.add(f.c.id);
      vTopo.put(f.a.id, a);
      // add connections for vertex b
      HashSet<Integer> b = vTopo.get(f.b.id);
      b.add(f.a.id);
      b.add(f.c.id);
      vTopo.put(f.b.id, b);
      // add connections for vertex c
      HashSet<Integer> c = vTopo.get(f.c.id);
      c.add(f.a.id);
      c.add(f.b.id);
      vTopo.put(f.c.id, c);
    }
  }

  void computeVertexFaceTopo() {
    // faces connected to each vertex

    // create empty map
    for (int i=0; i<vertices.size(); i++) {
      HashSet<Integer> empty = new HashSet<Integer>();
      vfTopo.put(i, empty);
    }
    Face f;
    for (int i=0; i< faces.size(); i++) {
      f = faces.get(i);
      // add connections for vertex a
      HashSet<Integer> a = vfTopo.get(f.a.id);
      a.add(i);
      vfTopo.put(f.a.id, a);
      // add connections for vertex b
      HashSet<Integer> b = vfTopo.get(f.b.id);
      b.add(i);
      vfTopo.put(f.b.id, b);
      // add connections for vertex c
      HashSet<Integer> c = vfTopo.get(f.c.id);
      c.add(i);
      vfTopo.put(f.c.id, c);
    }
  }


  Vertex[] getNeighbors(int id) {

    HashSet n = vTopo.get(id);
    int nn = n.size();
    Vertex[] neighbors = new Vertex[nn];
    int i=0;
    for (Iterator it = n.iterator(); it.hasNext(); ) {
      neighbors[i] = getVertexForID((int)it.next());    
      i++;
    }
    return neighbors;
  }


  Vertex[] getNeighbors(Vertex v) {
    HashSet n = vTopo.get(v.id);
    int nn = n.size();
    Vertex[] neighbors = new Vertex[nn];
    int i=0;
    for (Iterator it = n.iterator(); it.hasNext(); ) {
      neighbors[i] = getVertexForID((int)it.next());    
      i++;
    }

    return neighbors;
  }

  int[] getConnectedFaces(int id) {
    HashSet n = vfTopo.get(id);
    int nn = n.size();
    int[] neighbors = new int[nn];
    int i=0;
    for (Iterator it = n.iterator(); it.hasNext(); ) {
      neighbors[i] = (int) it.next();    
      i++;
    }
    return neighbors;
  }

  int[] getConnectedFaces(Vertex v) {
    HashSet n = vfTopo.get(v.id);
    int nn = n.size();
    int[] neighbors = new int[nn];
    int i=0;
    for (Iterator it = n.iterator(); it.hasNext(); ) {
      neighbors[i] = (int) it.next();    
      i++;
    }
    return neighbors;
  }

  // topology display

  void neighDisplay(Vertex v) {
    Vertex[] neigh = getNeighbors(v);
    stroke(0, 255, 0);
    strokeWeight(5);
    Vec3D p;
    for (int i=0; i< neigh.length; i++) {
      p = neigh[i];
      point(p.x, p.y, p.z);
    }
  }

  void neighDisplay(int id) {
    Vertex[] neigh = getNeighbors(id);
    stroke(0, 255, 0);
    strokeWeight(5);
    Vec3D p;
    for (int i=0; i< neigh.length; i++) {
      p = neigh[i];
      point(p.x, p.y, p.z);
    }
  }
}