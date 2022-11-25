public class Rectangle {
  public float left, top, right, bottom;
  public float height() { return this.bottom - this.top; }
  public float centerY() { return (this.height() / 2) + this.top; }
}
