public class Obstacle extends Rectangle {
  private static final int SAFE_H = 200;
  private final float top;
  private float left;

  public Obstacle() {
    this.top = random(height - SAFE_H);
    this.left = width;
  }

  public void tick() {
    this.left -= 2;
  }

  public void draw() {
    fill(0, 100, 0);
    rect(this.left, 0, 50, this.top);
    rect(this.left, this.top + SAFE_H, 50, height - this.top - SAFE_H);
  }

  public Rectangle getSafeBox() {
    Rectangle r = new Rectangle();
    r.left = this.left;
    r.top = this.top;
    r.right = this.left + 50;
    r.bottom = this.top + SAFE_H;
    return r;
  }

  public boolean isSafe(Rectangle r) {
    Rectangle safe = this.getSafeBox();
    if (r.right < safe.left || r.left > safe.right) { return true; }
    return safe.top < r.top && r.bottom < safe.bottom;
  }
}
