import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer player;
FFT fft;

Table table;
int nSamples;
float[] dailyScreenTime;
float[] mentalHealthScore;

float centroX;
float tamanoGrande = 100; 
float tamanoPequeno = 50; 
float yPos; 
boolean tintilear = false; 

void setup() {
  size(800, 600);
  frameRate(60);
  centroX = width / 2;
  yPos = height;

  // Configuración de Minim y carga del audio
  minim = new Minim(this);
  player = minim.loadFile("Audios.mp3", 1024);
  player.play();

  fft = new FFT(player.bufferSize(), player.sampleRate());

  table = loadTable("digital_diet_mental_health.csv", "header");
  
  nSamples = table.getRowCount();

  dailyScreenTime = new float[nSamples];
  mentalHealthScore = new float[nSamples];

  for (int i = 0; i < nSamples; i++) {
    dailyScreenTime[i] = table.getFloat(i, "daily_screen_time_hours");
    mentalHealthScore[i] = table.getFloat(i, "mental_health_score");
  }
}

void draw() {
  fft.forward(player.mix);

  for (int i = 0; i < height; i++) {
    float inter = map(i, 0, height, 1, 0);
    stroke(lerpColor(color(255), color(0), inter));
    line(0, i, width, i);
  }

  float minMental = min(mentalHealthScore);
  float maxMental = max(mentalHealthScore);
  float minScreen = min(dailyScreenTime);
  float maxScreen = max(dailyScreenTime);

  for (int i = 0; i < nSamples; i++) {
    float x = map(dailyScreenTime[i], minScreen, maxScreen, 0, width);
    float y = map(mentalHealthScore[i], minMental, maxMental, height, 0);
    float rectWidth = 8;
    float rectHeight = 8;

    float baseBrightness = 255 - map(y, 0, height, 0, 255);
    float flicker = baseBrightness + random(-60, 60);
    flicker = constrain(flicker, 0, 255);

    fill(flicker);
    noStroke();
    ellipse(x, y, rectWidth, rectHeight);
  }

  yPos -= 2;
  if (yPos < -tamanoGrande * 1.5) {
    yPos = height;
  }

  fill(255);
  rect(centroX - tamanoGrande / 2, yPos, tamanoGrande, tamanoGrande * 1.5);

  if (tintilear) {
    fill(random(100, 255), random(0, 100), random(50, 80));
  } else {
    fill(0);
  }
  rect(centroX - tamanoPequeno / 2, yPos + (tamanoGrande * 1.5 - tamanoPequeno * 1.5) / 2, tamanoPequeno, tamanoPequeno * 1.5);
}

void mousePressed() {
  tintilear = true;
}

void mouseReleased() {
  tintilear = false;
}

void stop() {
  player.close();
  minim.stop();
  super.stop();
}
