public class Player {
  public static final int DRAW_H = 110;
  public static final int X = 100;
  private static final float GRAVITY = 0.5;
  private static final int W = 50;
  private static final int H = 50;
  private final Brain brain;
  private float y;
  private float vy;
  private float ay;
  private int moveTimer;
  
  public Player() {
    this.brain = new Brain();
    this.reset();
  }
  
  public Player(Player parent) {
    this.brain = parent.brain;
    this.reset();
  }
  
  public float getVel() { return this.vy; }
      
  public Rectangle getBoundingBox() {
    Rectangle r = new Rectangle();
    r.left = X;
    r.top = this.y;
    r.right = X + W;
    r.bottom = this.y + H;
    return r;
  }
  
  public void tick(BrainInput in) {
    this.moveTimer = (this.moveTimer + 1) % 10;
    if (this.moveTimer != 0) { return; }
    
    if (this.brain.move(in).shouldJump) { this.jump(); }
    else { this.stopJump(); }
  }
  
  public void draw() {
    this.vy += this.ay + GRAVITY;
    this.y += this.vy;
    
    rect(X, this.y, W, H);
  }
  
  public void drawDebug(int x, int y) {
    strokeWeight(2);
    if (this.isJumping()) { stroke(0, 150, 0); } else { stroke(150, 0, 0); }
    fill(150, 150);
    rect(x, y, 90, DRAW_H);
    fill(0);
    text(Integer.toString(this.brain.id), x + 5, y + 11);
    this.brain.drawDebug(x, y);
  }
  
  public void jump() {
    this.ay = -1;
  }
  
  public void stopJump() {
    this.ay = 0;
  }
  
  public boolean isJumping() {
    return this.ay < 0;
  }
  
  public void reset() {
    this.y = height / 2;
    this.vy = 0;
    this.ay = 0;
    this.moveTimer = 0;
  }
}
