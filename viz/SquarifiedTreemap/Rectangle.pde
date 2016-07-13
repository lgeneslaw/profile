class Rectangle {
  int ID;
  int value;
  ArrayList children;
  int numChildren;
  float rect_width, rect_height;
  float rect_x, rect_y;
  
  public Rectangle(int _ID) {
    ID = _ID;
    children = new ArrayList();
    value = 0;
    numChildren = 0;
  }
  
  private boolean isGreaterThan(Rectangle other) {
    return value > other.getValue();
  }
  
  public Rectangle(int _ID, int val) {
    ID = _ID;
    children = new ArrayList();
    value = val;
    numChildren = 0;
  }
  
  public boolean isLeaf() {
    return children.size() == 0;
  }
  
  public void giveBirth(Rectangle child) {
    children.add(child);
    numChildren++;
  }

  public void setID(int _ID) {
    ID = _ID;
  }
  
  public int getValue() {
    return value;
  }
  
  public void setValue(int val) {
    value = val;
  }
  
  //recursively sums the values of all of the children
  public void setValue() {
    Rectangle child;
    for(int i = 0; i < numChildren; i++) {
      child = (Rectangle)children.get(i);
      if(!child.isLeaf())
        child.setValue();
      value += child.getValue();
    }
  }

  //sorts the children by decreasing values via insertion sort
  private void sortChildren() {
    Rectangle toSort, curr;
    for(int i = 1; i < numChildren; i++) {
      toSort = (Rectangle)children.get(i);
      for(int j = 0; j < i; j++) {
        curr = (Rectangle)children.get(j);
        if(toSort.isGreaterThan(curr)) {
          children.remove(i);
          children.add(j, toSort);
          j = i;
        }
      }
    }
  }

  public int getID() {
    return ID;
  }
  
  public float getWidth() {
    return rect_width;
  }
  
  public float getHeight() {
    return rect_height;
  }
  
  public float getX() {
    return rect_x;
  }
  
  public float getY() {
    return rect_y;
  }
  
  public void setX(float x) {
    rect_x = x;
  }
  
  public void setY(float y) {
    rect_y = y;
  }
  
  private void setDimensions(float w, float h) {
    rect_width = w;
    rect_height = h;
  }
  
  /*curr_row is a list of rectangles that are all within one larger "row" rectangle.
    getRowRect() returns a new Rectangle with dimensions set to the sum of the
    contained Rectangles' dimensions*/
  private Rectangle getRowRect(ArrayList curr_row, float x, float y) {
    Rectangle row_rect = new Rectangle(-1);
    int length = curr_row.size();
    int row_value = 0;
    float row_width = 0;
    float row_height = 0;
    Rectangle temp;
    for(int i = 0; i < length; i++) {
      temp = (Rectangle)curr_row.get(i);
      row_value += temp.getValue();
      row_width += temp.getWidth();
      row_height += temp.getHeight();
    }
    row_rect.setDimensions(row_width, row_height);
    row_rect.setX(x);
    row_rect.setY(y);
    row_rect.setValue(row_value);
    return row_rect;
  }
  
  /*Recursively runs until all children have been "placed." This function places all of this Rectangles
    children by setting the rect_x, rect_y, rect_width, and rect_height variables using the squarify
    algorithm. This function does NOT draw anything. */
  private void placeChildrenHelper(float x, float y, float w, float h, ArrayList toAdd, ArrayList curr_row,
                                   float va_ratio, float ratio_c1, boolean row_along_height) {
    if(toAdd.isEmpty())
      return;
    Rectangle row_rect = getRowRect(curr_row, x, y);
    Rectangle new_rect = (Rectangle)toAdd.get(0);

    int new_row_value = row_rect.getValue() + new_rect.getValue();
    Rectangle new_row_rect = new Rectangle(-2, new_row_value);
    float new_row_width, new_row_height;
    float new_row_area = new_row_value / va_ratio;
    if(row_along_height) {
      new_row_height = row_rect.getHeight();
      new_row_width = new_row_area / new_row_height;
    }
    else {
      new_row_width = row_rect.getWidth();
      new_row_height = new_row_area / new_row_width;
    }
    float new_rect_width, new_rect_height;
    float new_rect_area = new_rect.getValue() / va_ratio;
    if(row_along_height) {
      new_rect_width = new_row_rect.getWidth();
      new_rect_height = new_rect_area / new_rect_width;
    }
    else {
      new_rect_height = new_row_rect.getHeight();
      new_rect_width = new_rect_area / new_rect_height;
    }
    float ratio_c2 = computeAspectRatio(new_rect_width, new_rect_height);
    if(ratio_c2 <= ratio_c1) {
      toAdd.remove(0);

      new_rect.setDimensions(new_rect_width, new_rect_height);
      Rectangle r;
      int length = curr_row.size();
      for(int i = 0; i < length; i++) {
        r = (Rectangle)curr_row.get(i);
        r.setDimensions(new_rect_width, (r.getWidth() * r.getHeight()) / new_rect_width);
      }
      curr_row.add(new_rect);
      setXY(curr_row, x, y, row_along_height);
      placeChildrenHelper(x, y, w, h, toAdd, curr_row, va_ratio, ratio_c2, row_along_height);
    }
    else {
      Rectangle temp = (Rectangle)curr_row.get(0);
      if(row_along_height) {
        x += temp.getWidth();
        w -= temp.getWidth();
        row_along_height = new_rect.addToShortSide(x, y, w, h, va_ratio);
      }
      else {
        y += temp.getHeight();
        h -= temp.getHeight();
        row_along_height = new_rect.addToShortSide(x, y, w, h, va_ratio);
      }
      curr_row.clear();
      ratio_c1 = computeAspectRatio(new_rect.getWidth(), new_rect.getHeight());
      curr_row.add(new_rect);
      toAdd.remove(0);
      placeChildrenHelper(x, y, w, h, toAdd, curr_row, va_ratio, ratio_c1, row_along_height);
    }
  }
  
  /*setXY takes a row of Rectangles that already have their widths and heights set.
    This function simply places the rectangles in their appropriate locations witin a row. */
  private void setXY(ArrayList curr_row, float x, float y, boolean row_along_height) {
    int length = curr_row.size();
    float rx = x;
    float ry = y;
    Rectangle r = (Rectangle)curr_row.get(0);
    for(int i = 0; i < length - 1; i++) {
      r.setX(rx);
      r.setY(ry);
      r = (Rectangle)curr_row.get(i + 1);
      if(row_along_height)
        ry += r.getHeight();
      else
        rx += r.getWidth();
    }
      r.setX(rx);
      r.setY(ry);
  }
  
  /*Recursively places all of the children of this Rectangle in their appropriate locations/orientations
    using placeChildrenHelper */
  public void placeChildren() {
    if(children.isEmpty())
      return;
    sortChildren();
    ArrayList toAdd = new ArrayList();
    for(int i = 0; i < numChildren; i++)
      toAdd.add(children.get(i));
    ArrayList curr_row = new ArrayList(); // current row
    float total_value = value;
    float canvas_area = rect_width * rect_height;
    float va_ratio = total_value / canvas_area;
    Rectangle r = (Rectangle)toAdd.get(0);
    boolean row_along_height = r.addToShortSide(rect_x, rect_y, rect_width, rect_height, va_ratio);
    float ratio_c1 = computeAspectRatio(r.getWidth(), r.getHeight());
    curr_row.add(r);
    toAdd.remove(0);
    placeChildrenHelper(rect_x, rect_y, rect_width, rect_height, toAdd, curr_row, va_ratio, ratio_c1, row_along_height);
    for(int i = 0; i < numChildren; i++)
      ((Rectangle)children.get(i)).placeChildren();
  }
    
  /*All of the Rectangles have been appropriately placed, so now they must actually be drawn.
    If id matches any of the Rectangles' IDs, then that Rectangle will be drawn highlighted. */
  public void drawChildren(int id) {
     //Only write the ID of the leaf rectangles
    if(numChildren == 0) {
      textSize(((width + height) / 2) * .02);
      textAlign(CENTER, CENTER);
      fill(0);
      text(ID, rect_x + (rect_width / 2), rect_y + (rect_height / 2));
    }
    Rectangle r;
    for(int i = 0; i < numChildren; i++) {
      r = (Rectangle)children.get(i);
      if(r.numChildren == 0) {
        strokeWeight(2);
        stroke(255);
        if(id == r.getID())
          fill(225, 100, 150);
        else
          fill(45, 200, 200);
        rect(r.getX(), r.getY(), r.getWidth(), r.getHeight());
      }
    }
    for(int i = 0; i < numChildren; i++)
      ((Rectangle)children.get(i)).drawChildren(id);
  }
  
  // Colors the back buffer with Rectangle IDs
  public void renderBackBuffer(PGraphics pg) {
    Rectangle r;
    for(int i = 0; i < numChildren; i++) {
      r = (Rectangle)children.get(i);
      if(r.numChildren == 0) {
        pg.fill((int)red(r.getID()), (int)green(r.getID()), (int)blue(r.getID()));
        pg.rect(r.getX(), r.getY(), r.getWidth(), r.getHeight());
      }
    }
    for(int i = 0; i < numChildren; i++)
      ((Rectangle)children.get(i)).renderBackBuffer(pg);
  }
  
  //computes the ratio of either w/h or h/w, whichever is larger
  private float computeAspectRatio(float w, float h) {
    float aspect_ratio = w / h;
    if(aspect_ratio < 1)
      aspect_ratio = h / w;
    return aspect_ratio;
  }
  
  /* adds this Rectangle to the shorter side of the canvas outlined by x, y, w and h.
    Also returns true if the Rectangle was drawn along the height of the canvas */
  private boolean addToShortSide(float x, float y, float w, float h, float va_ratio) {
    float pix_area = value / va_ratio;
    if(h < w) {
      rect_height = h;
      rect_width = pix_area / rect_height;
      rect_x = x;
      rect_y = y;
      return true;
    }
    else {
      rect_width = w;
      rect_height = pix_area / rect_width;
      rect_x = x;
      rect_y = y;
      return false;
    }
  }

  public String toString() {
    return "ID = " + ID + ", value = " + value + " x = " + rect_x + "y = " + rect_y + ", width = " + rect_width + ", height = " + rect_height;
  }
}
