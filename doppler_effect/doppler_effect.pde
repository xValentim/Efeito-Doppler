/*
Baseado no exemplo de Daniel Shiffman (Professor da Universidade de Nova Iorque)
https://youtu.be/BZUdGqeOD0w

Utilizei um algoritmo que modela superficies de liquidos sendo perturbadas.
Daí reescrevi para simular uma fonte em movimento acelerado (pra gerar o efeito Doppler e em seguida o cone de Mach).
*/

int col = 200;
int row = 200;
float t = 0;
float dt = 1;
float vx = 5;
float ax = 0.1;
float tmax = 20;
float ddt = 0.1;
float vy;
int x;
int y;
float[][] current;
float[][] previous;

float dampening = 0.96; //Dissipação

void setup(){
  size(600, 400);
  colorMode(HSB);
  col = width;
  row = height;
  x = width/2-200;
  y = height/2;
  current = new float[col][row];
  previous = new float[col][row];
}

void mouseDragged(){
  previous[mouseX][mouseY] = 255;
  
}

void draw(){
  t += dt;
  if (tmax <= 6){
    tmax = 6;
  }
  if (t % round(tmax) == 0){
    x += vx;
    tmax -= ddt;
    //vx += ax;
  }
  
  if (x > width/2+200){
    x = width/2-200;
  }
  
  previous[x][y] = 255;
  
  background(0);
  loadPixels();
  /*
    1. Artigo sobre o algoritmo para modelar o efeito ondulatorio
    de uma gota caindo numa superfície de líquido:
    https://web.archive.org/web/20160418004149/http://freespace.virgin.net/hugo.elias/graphics/x_water.htm

  */
  for (int i = 1; i < col - 1; i++){
    for (int j = 1; j < row - 1; j++){
      current[i][j] = (
        previous[i-1][j] +
        previous[i+1][j] +
        previous[i][j-1] +
        previous[i][j+1])/2 - current[i][j];
       current[i][j] = current[i][j] * dampening;
       int index = i + j * col;
       pixels[index] = color(current[i][j] * 255);
    }
  }
  updatePixels();
  float[][] temp = previous;
  previous = current;
  current = temp;
}
