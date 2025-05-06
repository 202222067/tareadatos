Table table;
int nSamples;
float[] appUsageTime;
float[] screenOnTime;
void setup() {
  size (1000, 1000);

  table = loadTable ("user_behavior_dataset.csv", "header");
  //println(table.getRowCount());

  nSamples = table.getRowCount();

  appUsageTime = new float [nSamples];
  screenOnTime = new float [nSamples];

  for (int i = 0; i < nSamples; i++) {
    appUsageTime[i] = table.getFloat(i, "App Usage Time (min/day)");
    screenOnTime[i] = table.getFloat(i, "Screen On Time (hours/day)");
  }
}

void draw() {
  background(0);
  for (int i = 0; i < nSamples; i++) {
    float x = map(appUsageTime[i], 0, max(appUsageTime), 0, width);
    float y = map(screenOnTime[i], 0, max(screenOnTime), height, 0);

    float rectWidth = 10;
    float rectHeight = 10;

    fill(random(100, 255), random(0, 100), random(50, 80));
    noStroke();
    ellipse(x, y, rectWidth, rectHeight);
  }
}
