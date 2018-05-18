int[] charges = {-1, 1};
import processing.sound.*;

PApplet thisSketchThis=this;

//ArrayList<SinOsc> sines = new ArrayList<SinOsc>();

int screenx = 800, screeny = 600;
ArrayList<Particle> particles = new ArrayList<Particle>();

/*
/A particle should have the following:
/Charge sign (Positive or negative (boolean)) and magnitude (float)
/x- and y-position and speed
/Collision detection
/Render function
/Way of interacting with other particles
*/

class Particle
{
  float xpos, ypos, xspeed, yspeed, magnitude, radius;
  int charge;
  SinOsc sine;
  
  Particle(int charge, float magnitude)
  {
    this.charge = charge;
    this.magnitude = magnitude;
    this.radius = 8;
    xpos = random(screenx/2-150,screenx/2+150);
    ypos = random(screeny/2-150,screeny/2+150);
    xspeed = yspeed = 0;
    
    sine = new SinOsc(thisSketchThis);
    sine.play();
    //sines.add(sine);
  }
 
  void detectCollision()
  {
    if (xpos-2*radius < 0 || xpos > screenx)
      xspeed = -xspeed;
    if (ypos-2*radius < 0 || ypos > screeny)
      yspeed = -yspeed;
  }
  
  void render()
  {
    ellipse(xpos-radius,ypos-radius,2*radius,2*radius);
  }
  
  void updatePosition()
  {
    xpos += xspeed;
    ypos += yspeed;
  }

  
  void updateSpeed()
  {
    float deltax, deltay, theta;
     for (Particle p: particles)
    {
      if (this == p)
        continue;
        
      /*------------------------------------------------------------------------------------------------------------
      /  Change in speed is calculated in the following way:
      /    Get the angle Theta between particle A and B with x as the "floor"
      /    Update speed of x by taking the product of cos(Theta)*magnitude divided by length of distance vector AB
      /    Same for y with sin(Theta).
      /    Can cause null division, i should probably fix that.
      ------------------------------------------------------------------------------------------------------------*/
       //<>//
      deltax = (xpos- p.xpos);
      deltay = (ypos- p.ypos); // Reversed because origo is in top left.
        theta = atan2(deltay, deltax);
      
      xspeed += (500*cos(theta)*p.magnitude*charge)/(( pow( (  pow((xpos-p.xpos), 2) + pow((ypos-p.ypos), 2)), 1) ));
      yspeed += (500*sin(theta)*p.magnitude*charge)/((  pow( (  pow((xpos-p.xpos), 2) + pow((ypos-p.ypos), 2) ), 1) ));  
    }
  }
  
  void update()
  {
    this.updateSpeed();
    this.updatePosition();
    this.detectCollision();
    this.render();
  }
  
  
}


void setup() {
  surface.setSize(screenx, screeny);
  fill(255); 


}

void draw() {
  background(0);
  for (Particle p: particles)
  {
    p.update();
    p.sine.freq(1000/(1+abs(p.xspeed)+abs(p.yspeed)));
  } 
}

void keyPressed() {
  Particle p = new Particle(1,random(8,30));
  particles.add(p);
  } 
