public class PlayerLoss implements Comparable<PlayerLoss> {
  public Player player;
  public int finalScore;
  
  public int compareTo(PlayerLoss o) { return this.finalScore - o.finalScore; }
}
