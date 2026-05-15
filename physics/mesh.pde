class Mesh {
  int height_nodes;
  int width_nodes;
  float linkLength;
  Node[][] nodes;
  ArrayList<Link> links;
  Point3D basePos;

  Mesh(Point3D basePos, int height_nodes, int width_nodes, float linkLength, float ks, float kd) {
    this.basePos = basePos;
    this.height_nodes = height_nodes;
    this.width_nodes = width_nodes;
    this.linkLength = linkLength;
    nodes = new Node[height_nodes][width_nodes];
    
    
    for (int ri = 0; ri < height_nodes; ri++) {
      for (int ci = 0; ci < width_nodes; ci++) {
        float x = basePos.x + ci * linkLength;
        float y = basePos.y;
        float z = basePos.z + ri * linkLength;
        
        nodes[ri][ci] = new Node(new Point3D(x, y, z));
      }
    }
    
    initLinks(linkLength, ks, kd);    
  }
  
  private void initLinks(float linkLength, float ks, float kd) {
    this.links = new ArrayList();
    float crossLinkLength = sqrt(linkLength * linkLength + linkLength * linkLength);
    
    for (int ri = 0; ri < height_nodes - 1; ri++) {
      for (int ci = 0; ci < width_nodes - 1; ci++) {
        Node a = nodes[ri][ci];
        Node b = nodes[ri][ci + 1];
        Node c = nodes[ri + 1][ci];
        Node d = nodes[ri + 1][ci + 1];
        
        Link ab = new Link(a, b, linkLength, ks, kd);
        Link ac = new Link(a, c, linkLength, ks, kd);
        Link ad = new Link(a, d, crossLinkLength, ks, kd);
        Link bc = new Link(b, c, crossLinkLength, ks, kd);
        
        links.add(ab);
        links.add(ac);
        links.add(ad);
        links.add(bc);
        if(ci == width_nodes - 2) {
          Link bd = new Link(b, d, linkLength, ks, kd);
          links.add(bd);
        }
        if(ri == height_nodes - 2) {
          Link cd = new Link(c, d, linkLength, ks, kd);
          links.add(cd);
        }
      }
    } 
  }
  
  int getNumNodes() {
    return height_nodes * width_nodes;
  }
  
  Node[] getNodes() {
    Node[] nodesArray = new Node[getNumNodes()];
    for (int ri = 0; ri < height_nodes; ri++) {
      for (int ci = 0; ci < width_nodes; ci++) {
        int arrayIndex = ri * width_nodes + ci;
        nodesArray[arrayIndex] = nodes[ri][ci];
      }
    }
    
    return nodesArray;
  }

  void update(float dt) {    
    for (int i = 0; i < links.size(); i++) {
      Link link = links.get(i);
      link.update(dt);
      if(link.shouldTear()) {
        println("TEAR DETECTED");
        links.remove(link);
      }
    }
    
    Node[] nodeArray = getNodes();
    for (int i = 0; i < getNumNodes(); i++) {
      Node node = nodeArray[i];
      node.applyForce(gravity, dt);
      node.update(dt);
    }
    pinTop();
  }  
  
  void handleCollision(Ball ball) {
    for (int ri = 0; ri < height_nodes; ri++) {
      for (int ci = 0; ci < width_nodes; ci++) {
        Node node = nodes[ri][ci];
        Point3D spherePos = ball.sphere.center;
        Vector3D nodeToSphere = spherePos.minus(node.pos);
        float distance = nodeToSphere.magnitude();
        // Collision Detected
        if (distance < ball.sphere.radius + 0.09) {
          Vector3D sphereNormal = nodeToSphere.toUnit().times(-1.0);
          Vector3D bounce = sphereNormal.times(node.vel.dot(sphereNormal));
          node.vel.subtract(bounce.times(ball.cor));
          node.pos.add(sphereNormal.times(ball.sphere.radius - distance + 0.1));
        }
      }
    }
  }

  void draw() {
    fill(0, 255, 0);
    stroke(0);
    strokeWeight(0.02 * scene_scale);
    
    Node[] nodeArray = getNodes();
    
    // draw nodes
    for (int i = 0; i < getNumNodes(); i++) {
      Node node = nodeArray[i];
      node.draw();
    }
    
    
    // draw links
    for (int i = 0; i < links.size(); i++) {
      Link link = links.get(i);
      link.draw();
    }
  }
  
  void pinTop() {
    for (int ci = 0; ci < width_nodes; ci++) {
      Node node = nodes[0][ci];
      float x = basePos.x + ci * linkLength;
      float y = basePos.y;
      float z = basePos.z;
      node.pos = new Point3D(x,y,z);
      node.vel = new Vector3D(0,0,0);
    }
  }
}
