int a=2, b=3, c=0;  // dichiarazione varibili intere
float /* < numeri reali */ d = 0.34, e;
boolean  flag=true; // true o false
PVector v;//vettori, includono sia vettori che punti

int[] nums; // dichiarazione dell'array 1 dimensione
// nums = new int[5]; //instanziazione dell'array
// print (nums[0]);

//variabile dinamica con array list, collezione generica
ArrayList list; // array list generico
// list = new ArrayList(); // instanziazione

ArrayList<PVector> vecs; // flagged arraylist
// vecs = new ArrayList<PVector>(); // instanziazione

/*
classe:

. fields // definisticono caratteristiche
. methods o behaviors
. constructors // tipo particolare di behaviors o methods, recepisce i parametri di scelta e definisce le caratteristiche specifiche dando fuori quella macchina

le classi possono essere usate come tipo di variabile

*/

 int k;
void setup(){
 size(800,600); // JAVA2D, P2D, P3D
 stroke(0,5); // 4 modi di dichiarazione diversa, 
 noStroke();
 fill(200,0,0,5);
 rectMode(CENTER);
}

void draw(){
 // rect(width*0.5,height*0.5,200,100);
 /*
 a<b <- true or false
 c>=b
 e != f // e diverso da f
 e == f
 && AND - true se entrambe sono true, altrimenti false
 || OR - true se almeno è true
 */
 
 if(mousePressed && mouseButton == LEFT){ // condizione - operatori booleani:
 rect(mouseX,mouseY,200,100);
 } else {
 
 }
}