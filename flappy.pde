private static final boolean SAVE_FRAMES = false;

private static int MaxId = 0;

private PlayerManager playerManager;
private ObstacleManager obstacleManager;
private int gameNum;
private float score;

public void setup() {
  frameRate(60);
  size(640, 640);
  this.gameNum = 1;
  this.obstacleManager = new ObstacleManager();
  this.playerManager = new PlayerManager(this.obstacleManager);
  restart();
}

public void restart() {
  this.gameNum++;
  this.score = 0;
  this.obstacleManager.restart();
}

public void draw() {
  if (!this.playerManager.tick((int)this.score)) { restart(); }

  this.resetDrawSettings();
  this.obstacleManager.tick();
  this.obstacleManager.drawObstacles();
  this.playerManager.drawPlayers();
  this.tickScore();
  
  if (SAVE_FRAMES) { saveFrame("output/flappy_#####.png"); }
}

private void resetDrawSettings() {
  background(255);
  strokeWeight(1);
  stroke(0);
  fill(255);
}

private void tickScore() {
  this.score += 0.2;
  fill(0);
  text("Game " + this.gameNum, width - 100, 20);
  text("Score: " + (int)this.score, width - 100, 40);
}
