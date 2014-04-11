import controlP5.*;
ControlP5 controlP5;

String textValue = "";
Textfield time_field;
Button b;

ColorPicker cp;

public class Point {
  public int x;
  public int y;
  public int r;
  public int g;
  public int b;
}

Point[] points =  new Point[100];
int numpoints = 0;
float numsecs = 0;

int interval = 940; //our horiz axis spacing
  
void setup() 
{
  size(1250, 500); 
  controlP5 = new ControlP5(this);
  time_field = controlP5.addTextfield("length_secs",10,10,40,20);
  time_field.setFocus(true);
  controlP5.addButton("Save",0,100,10,40,20);
  noStroke();
  rectMode(CENTER);
  cp = controlP5.addColorPicker("picker",1040,0,200,20);
}

void draw() 
{   
  background(0);
  stroke(255);
  textAlign(RIGHT);
  line(40,50,40,450);
  stroke(80);
  for (int i = 50; i < 450; i += 13)
    line(35,i,980,i);
  stroke(255);
  line(40,453,980,453);
  for (int i = 55; i < 455; i += 13)
    text(31-((i-55)/13),30,i);
  for (int i = 0; i < numpoints; i++)
    {
      stroke(color(points[i].r, points[i].g, points[i].b));
      fill(color(points[i].r, points[i].g, points[i].b));
    ellipse(points[i].x, points[i].y, 5, 5);
    
    }
  stroke(80);
  fill(80);
  textAlign(CENTER);
  for (int i = 40; i < 940; i += interval)
    {
      line(i,445,i,455);
      text(((i-40)/interval)*10,i,470);
    }
}

void mousePressed() {
  if ((mouseX > 40) && (mouseY > 40) && (mouseX < 980))
  {
  stroke(cp.getColorValue());
  fill(cp.getColorValue());
  ellipse(mouseX, mouseY,5,5);
  points[numpoints] = new Point();
  points[numpoints].r = (int)red(cp.getColorValue());
  points[numpoints].g = (int)green(cp.getColorValue());
  points[numpoints].b = (int)blue(cp.getColorValue());
  points[numpoints].x = mouseX;
  points[numpoints++].y = mouseY;
  }
}

public void Save(int theValue) {

  float[] freqs = new float[(int)numsecs];
  int[] red = new int[(int)numsecs];
  int[] green = new int[(int)numsecs];
  int[] blue = new int[(int)numsecs];

  float horz_scale = 1/ (numsecs/940);
  //fill in our freqs array with painted points
  for (int i = 0; i < numpoints; i++)
  {
    //freq[floor(points[i].x)] = (1 - (points[i].y - 55)) * vert_scale;
    float time = (points[i].x - 40.0)/horz_scale;
    float freq = 31.0 - ((points[i].y-50.0) /13.0 );
    freqs[floor(time)] = freq;
    red[floor(time)] = points[i].r;
    green[floor(time)] = points[i].g;
    blue[floor(time)] = points[i].b;
  }
  for (int i = 0; i < numsecs; i++)
  {
    if (freqs[i] == 0)
      continue;
    else
    {
      int start = i;
      int end = (int)numsecs-1;
      for (int j = start+1; j < numsecs; j++)
      {
        if (freqs[j]!=0)
        {
          end = j;
          j = (int)numsecs; //just a lazy way to say: we found the next one, end loop
        }
      }
      //here we interpolate from the painted point to the next painted point, linearly
      float freq_increment = (freqs[end] - freqs[start]) / (end - start);
      float color_increment = (end - start) / numsecs;
      for (int j = start+1; j < end; j++)
        freqs[j] = freqs[j-1] + freq_increment;
      for (int j = start+1; j < end; j++)
        {
          red[j] = lerpColor(red[j-1],red[end], color_increment);
          green[j] = lerpColor(green[j-1],green[end], color_increment);
          blue[j] = lerpColor(blue[j-1],blue[end], color_increment);
        }
    }
  }
    String[] lines = new String[4];
    lines[0] = "int r["+(int)numsecs+"] = {";
    for (int j = 0; j < numsecs-1; j++)
      lines[0] = lines[0] + red[j]+",";
    lines[0] = lines[0] + red[(int)numsecs-1] + "};";
    lines[1] = "int g["+(int)numsecs+"] = {";
    for (int j = 0; j < numsecs-1; j++)
      lines[1] = lines[1] + green[j]+",";
    lines[1] = lines[1] + green[(int)numsecs-1] + "};";
    lines[2] = "int b["+(int)numsecs+"] = {";
    for (int j = 0; j < numsecs-1; j++)
      lines[2] = lines[2] + blue[j]+",";
    lines[2] = lines[2] + blue[(int)numsecs-1] + "};";
    lines[3] = "float freq["+(int)numsecs+"] = {";
    for (int j = 0; j < numsecs-1; j++)
      lines[3] = lines[3] + nf(freqs[j],2,1)+",";
    lines[3] = lines[3] + nf(freqs[(int)numsecs-1],2,1) + "};";
    saveStrings("c:\\arrays.txt", lines);
}

public void length_secs(String theText) {
  numsecs = int(theText);
  interval = (int)(940 / (numsecs/10));
}
