// Implement this class. You just need to implement the constructor
// the three inherited methods from AnimatedSprite will work as is.

public class Prize extends AnimatedSprite{
  // call super appropriately
  // initialize standNeutral PImage array only since
  // we only have four coins and coins do not move.
  // set currentImages to point to standNeutral array(this class only cycles
  // through standNeutral for animation).
  public Prize(PImage img, float scale){
    super(img, scale);
    standNeutral = new PImage[2];
    standNeutral[0] = loadImage("prize1.png");

    standNeutral[1] = loadImage("prize2.png");

    currentImages=standNeutral;
    


  }
  
}
