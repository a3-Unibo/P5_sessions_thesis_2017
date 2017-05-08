ArrayList<Connection> connectTrails(PointOctree trails, float range, float ang) {
  ArrayList<Connection> conns = new ArrayList<Connection>();
  ArrayList <Vec3D> pts = (ArrayList <Vec3D>)trails.getPoints();
  ArrayList <Vec3D> neigh;
  Vec3D dir;

  for (Vec3D p : pts) {

    neigh = (ArrayList <Vec3D>)trails.getPointsWithinSphere(new Sphere(p, range));
    if (neigh!=null && neigh.size()>0) {
      for (Vec3D n : neigh) {
        dir = n.sub(p);
        //if (dir.angleBetween()< ang){
        
        //}
        conns.add(new Connection(p,n));
      }
    }
  }

  return conns;
}


class Connection {
  Vec3D a, b;

  Connection(Vec3D a, Vec3D b) {
    this.a = a;
    this.b = b;
  }

  void display() {
    stroke(0, 20);
    strokeWeight(1);
    line(a.x, a.y, a.z, b.x, b.y, b.z);
  }
}