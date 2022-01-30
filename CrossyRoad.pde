//Crossy Road

//Controls the level of the game
int level = 1;
//Controls the band height, which indirectly controls the size of everything else
int bandHeight;
//Coordinates of the frog
float frogX, frogY;
//Diameter of the frog
float frogDiam;
//The amount the frog moves in the x and y direction
float xMove, yMove;
//The offset variable
float offset;
//The y coordinate for the first object in the bottom row
float firstObjectY;
//The size of the objects
float objectSize;
//Checks if there is a collision
boolean collision = false;

//The background color
final int BG_COLOR = #4074FF;
//The band color
final int BAND_COLOR = #40FFAE;
//The frog color
final int FROG_COLOR = #FEFF46;
//The constant change in the offset
final float OFFSET_CHANGE = 0.275;

void setup()
{
  //Setup
  
  fullScreen();
  bandHeight = height/(level+4);
  frogX = width/2;
  frogY = height - (bandHeight/2);
  frogDiam = bandHeight/2;
  xMove = frogDiam;
  yMove = bandHeight;
  offset = 0;
  firstObjectY = height-(bandHeight/2);
  objectSize = 0.7*bandHeight;
}

void draw()
{ 
  //Draw
  
  if (!collision) //Only works when there is no collision
  {
    background(BG_COLOR);
    drawWorld();
    drawHazards();
    drawFrog(frogX, frogY, frogDiam);
    if (!collision)
      displayMessage("Level "+level);
    if (detectWin()) //If win is detected, then reset everything according to the next level
    {
      bandHeight = height/(level+4);
      frogX = width/2;
      frogY = height - (bandHeight/2);
      frogDiam = bandHeight/2;
      xMove = frogDiam;
      yMove = bandHeight;
      offset = 0;
      firstObjectY = height-(bandHeight/2);
      objectSize = 0.7*bandHeight;
    }
  } 
  else //Display game over message when there is a collision
    displayMessage("Game Over!");
}

void keyPressed()
{
  //Move frog when the key is pressed
  
  if (key == 'w'   || key == 'i'|| key == 'W'   || key == 'I')
  {
    moveFrog(0, -yMove);
  }
  if (key == 's' || key == 'k'|| key == 'S'   || key == 'K')
  {
    moveFrog(0, yMove);
  }
  if (key == 'd' || key == 'l'|| key == 'D'   || key == 'L')
  {
    moveFrog(xMove, 0);
  }
  if (key == 'a' || key == 'j'|| key == 'A'   || key == 'J')
  {
    moveFrog(-xMove, 0);
  }
}

boolean objectInCanvas(float x, float y, float diam)
{
  //Checks if the object is in canvas
  
  return (x-(diam/2)>0 && x+(diam/2)<width && y+(diam/2)<height);
}

boolean detectWin()
{
  //Checks if the user won the current level
  
  if (frogY<bandHeight)
  {
    level++;
    return true;
  }
  return false;
}

void displayMessage(String m)
{
  //Displays the string input as text message on the window
  
  fill(0);
  textSize(bandHeight*0.8);
  text(m, (width/2)-(textWidth(m)/2), bandHeight-textDescent()/2);
}

boolean objectsOverlap(float x1, float y1, float x2, float y2, float size1, float size2)
{
  //Check if two objects overlap
  
  return (abs(x1-x2)<(size1+size2)/2 && abs(y1-y2)<(size1+size2)/2);
}

boolean drawHazards()
{
  //Draws and moves the hazards. Returns true if any object collides with the frog
  
  for (int r=1; r<=level+2; r++)
  {
    for (int i=0; i<(float)(width+bandHeight)/(bandHeight*(r+2))+1; i++)
    {
      if (r%2==0) 
      {
        if (drawHazard((r-1)%3, (i*bandHeight*(r+2))-(offset*(r+2)), firstObjectY-r*bandHeight, objectSize))
          collision = true;
      } else
      {
        if (drawHazard((r-1)%3, (i*bandHeight*(r+2))+offset*(r+2), firstObjectY-r*bandHeight, objectSize))
          collision = true;
      }
      offset = (offset+OFFSET_CHANGE)%bandHeight;
    }
  }
  return collision;
}


boolean drawHazard(int type, float x, float y, float size)
{
  //Draws a single hazard according to the type, size and the coordinates. Returns true if there is an overlap between the hazard and the frog
  
  boolean overlap = objectsOverlap(frogX, frogY, x, y, frogDiam, size);
  if (type == 0)
  {
    fill(255, 0, 0);
    ellipse(x, y, size, size);
  }
  if (type == 1)
  {
    fill(0);
    rect(x-(size/2), y-(size/2), size, size);
  }
  if (type == 2)
  {
    fill(255);
    ellipse(x, y, size, size);
  }
  return overlap;
}

void moveFrog(float xChange, float yChange)
{
  //Moves the frog according to the parameters given
  
  float newFrogX = frogX + xChange;
  float newFrogY = frogY + yChange;
  if (objectInCanvas(newFrogX, newFrogY, frogDiam))
  {
    frogX = frogX + xChange;
    frogY = frogY + yChange;
  }
}

void drawFrog(float x, float y, float diam)
{
  //Draws the frog according to the parameters given
  
  fill(FROG_COLOR);
  ellipse(x, y, diam, diam);
}

void drawWorld()
{
  //Draws the world according to different bandheights
  
  background(BG_COLOR);
  fill(BAND_COLOR);
  rect(0, 0, width, bandHeight);
  rect(0, height-bandHeight, width, bandHeight);
}
