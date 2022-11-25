import java.util.*;

public class PlayerManager {
  private static final int INITIAL_PLAYER_COUNT = 10;
  private static final int CHILD_COUNT = 2;
  private final ArrayList<Player> players;
  private final PriorityQueue<PlayerLoss> recentLosses; 
  private final ObstacleManager obstacleManager;
  
  public PlayerManager(ObstacleManager obstacleManager) {
    this.players = new ArrayList<Player>();
    this.recentLosses = new PriorityQueue<PlayerLoss>(Collections.reverseOrder());
    this.obstacleManager = obstacleManager;
    
    for (int i = 0; i < INITIAL_PLAYER_COUNT; i++) {
      this.players.add(new Player());
    }
  }
  
  /// Returns true iff the game should continue
  public boolean tick(int score) {
    ArrayList<Player> lostPlayers = new ArrayList<Player>();
    for (Player p : this.players) {
      Rectangle playerBox = p.getBoundingBox();
      if (playerBox.bottom < 0 || playerBox.top > height) {
        lostPlayers.add(p);
        continue;
      }

      if (this.obstacleManager.anyCollideWith(p)) {
        lostPlayers.add(p);
        continue;
      }
      
      BrainInput in = new BrainInput();
      in.me = p;
      in.nextObstacle = this.obstacleManager.getNextObstacle();
      p.tick(in);
    }
        
    this.players.removeAll(lostPlayers);
    
    for (Player loser : lostPlayers) {
      PlayerLoss loss = new PlayerLoss();
      loss.player = loser;
      loss.finalScore = score;
      this.recentLosses.add(loss);
    }
  
    if (this.players.size() == 0 && !this.obstacleManager.anyCollideWith(new Player())) {
      this.makeChildPlayers();
      return false;
    }
    
    return true;
  }
  
  public void drawPlayers() {
    fill(100, 50);
    for (Player p : this.players) { p.draw(); }
    this.drawDebug();
  }
  
  public void drawDebug() {
    int x = width - 100;
    int y = 60;
    for (int i = 0; i < this.players.size(); i++) {
      this.players.get(i).drawDebug(x, y);
      y += Player.DRAW_H + 10;
      if (y + Player.DRAW_H >= height) {
        x -= 100;
        y = 60;
      }
    }
  }
  
  private void makeChildPlayers() {
    while (this.players.size() < INITIAL_PLAYER_COUNT) {
      PlayerLoss bestLoss = this.recentLosses.poll();
      Player parent = bestLoss.player;
      // println("Giving children to player with final score of " + bestLoss.finalScore);
      parent.reset();
      this.players.add(parent);
      for (int i = 0; i < CHILD_COUNT - 1; i++) {
        this.players.add(new Player(parent));
      }
    }
    
    this.recentLosses.clear();
  }
  
}
