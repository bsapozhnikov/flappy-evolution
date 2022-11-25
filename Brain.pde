public class BrainInput {
  public Player me;
  public Obstacle nextObstacle;
}

public class BrainOutput {
  boolean shouldJump;
}

public class Brain {
  private final int id;
  private final LinearLayer layer0;
  private final ReLULayer layer1;
  
  public Brain() {
    this.id = MaxId++;
    this.layer0 = new LinearLayer(3, 3);
    this.layer1 = new ReLULayer(3, 1);
  }
  
  public Brain(Brain parent) {
    this.id = MaxId++;
    this.layer0 = new LinearLayer(parent.layer0);
    this.layer1 = new ReLULayer(parent.layer1);
  }
  
  public void drawDebug(int x, int y) {
    strokeWeight(0);
    fill(255);

    this.layer0.drawLeftNodes(x+10, y+20);
    this.layer1.drawLeftNodes(x+30, y+20);
    
    this.layer0.drawWeights(x+10, y+20);
    this.layer1.drawWeights(x+30, y+20);
  }
  
  public BrainOutput move(BrainInput in) {
    float[] xs = this.convertInput(in);
    float[] ys = this.layer0.apply(xs);
    float z = this.layer1.apply(ys)[0];

    BrainOutput out = new BrainOutput();
    out.shouldJump = z > 0;
    return out;
  }
  
  private float[] convertInput(BrainInput in) {
    Rectangle myBox = in.me.getBoundingBox();
    Rectangle obsSafe = in.nextObstacle.getSafeBox();
    float deltaSafeY = (obsSafe.centerY() - myBox.centerY()) / (height / 2); 
    float y = 2 * myBox.top / height - 1;
    float vy = in.me.getVel() / 15;
    return new float[] { deltaSafeY, y, vy };
  }
  
  private abstract class Layer {
    protected final int n, m;
    protected final float[] weights;
    
    public Layer(int numInputs, int numOutputs) {
      this.n = numInputs + 1;
      this.m = numOutputs;
      this.weights = new float[this.n * this.m];
      for (int i = 0; i < this.n * this.m; i++) {
        this.weights[i] = random(-1.0, 1.0);
      }
    }
    
    public Layer(Layer parent) {
      this.n = parent.n;
      this.m = parent.m;
      this.weights = new float[this.n * this.m];
      for (int i = 0; i < this.n * this.m; i++) {
        float w = parent.weights[i];
        w += randomGaussian() / 4;
        w = min(w, 1);
        w = max(w, -1);
        this.weights[i] = w;
      }
    }    
    
    public float getWeight(int in, int out) {
      return this.weights[this.m * in + out];
    }

    public void drawLeftNodes(int x, int y) {
      for (int i = 0; i < this.n; i++) {
        circle(x, y+(i*20), 10);
      }
    }
 
    public void drawWeights(int x, int y) {
      stroke(0);
      for (int i = 0; i < this.n; i++) {
        for (int j = 0; j < this.m; j++) {
          float w = this.getWeight(i, j);
          strokeWeight(abs(w));
          if (w > 0) { stroke(0, 150, 0); } else { stroke(150, 0, 0); }
          line(x, y+(i*20), x+20, y+(j*20)); 
        }
      }
    }
    
    public float[] apply(float[] in) {
      float[] out = new float[this.m];
      for (int j = 0; j < this.m; j++) {
        float y = this.getWeight(this.n - 1, j); // bias term
        for (int i = 0; i < in.length; i++) {
          y += in[i] * this.getWeight(i, j);
        }
      
        out[j] = this.activate(y);
      }

      return out;
    }
    
    protected abstract float activate(float pre);
  }
  
  private class ReLULayer extends Layer {
    public ReLULayer(int numInputs, int numOutputs) {
      super(numInputs, numOutputs);
    }

    public ReLULayer(ReLULayer parent) {
      super(parent);
    }
    
    protected float activate(float pre) {
      return pre;
    }
  }
  
  private class LinearLayer extends Layer {
    public LinearLayer(int numInputs, int numOutputs) {
      super(numInputs, numOutputs);
    }

    public LinearLayer(LinearLayer parent) {
      super(parent);
    }    
    
    protected float activate(float pre) {
      return max(0, pre);
    }
  }
}
