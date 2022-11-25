public class ObstacleManager {  
  private static final int OBSTACLE_COUNT = 2;
  private ArrayList<Obstacle> obstacles;

  public ObstacleManager() {
    this.restart();
  }
  
  public void restart() {
    this.obstacles = new ArrayList<Obstacle>();
    this.tick();
  }
  
  public void tick() {
    ArrayList<Obstacle> toRemove = new ArrayList<Obstacle>();
    float newObstacleZone = width - (width / OBSTACLE_COUNT);
    int newObstacleCnt = 0;
    for (Obstacle obs : this.obstacles) {
      obs.tick();
      if (obs.getSafeBox().right < 0) {
        toRemove.add(obs);
        continue;
      }
      
      if (obs.getSafeBox().right > newObstacleZone) {
        newObstacleCnt++;
      }
    }
    
    this.obstacles.removeAll(toRemove);
    
    if (newObstacleCnt == 0) {
      this.obstacles.add(new Obstacle());
    }
  }
  
  public Obstacle getNextObstacle() {
    var i = 0;
    Obstacle o = this.obstacles.get(i);
    while (o.getSafeBox().right < Player.X) { o = this.obstacles.get(++i); }
    
    return o;
  }
  
  public void drawObstacles() {
    for (Obstacle obs : this.obstacles) {
      obs.draw();
    }
  }
  
  public boolean anyCollideWith(Player p) {
    Rectangle playerBox = p.getBoundingBox();
    for (Obstacle obs : this.obstacles) {
      if (!obs.isSafe(playerBox)) { return true; }
    }  
    
    return false;
  }
}
