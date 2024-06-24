#include "Level.h"

Level::Level(){
    settings = new Settings();
    string fileName;
    std::cout << "Enter the name fo the preferences file (e.g. \'preferences.txt\')" << endl;
    std::cin >> fileName;
    settings->setPreferences(fileName);
    std::cout << "Enter the name for the output file (e.g. \'log.txt\')" << endl;
    std::cin >> outputFileName;
    N = settings->N;
    L = settings->L;
    V = settings->V;
    cPct = settings->coinPct;
    bPct = settings->coinPct;
    gPct = settings->coinPct;
    kPct = settings->coinPct;
    mPct = settings->coinPct;
    delete settings;

    //below creates new char[N][N] array (NxN size)
    grid = new char*[N]; 
    for (int i=0; i<N; ++i) {
        grid[i] = new char[N];
    }
}

Level::~Level(){}

void Level::setLevel(){
    int randNum;

    for(int i=0; i<N; ++i){
        for(int j=0; j<N; ++j){
            randNum = rand()%100;
            if (randNum < cPct) { //e.g. <20
                grid[i][j] = 'c';
            } else if (randNum < cPct+bPct) { //e.g. 20-40
                grid[i][j] = 'x';
            } else if (randNum < cPct+bPct+gPct) { //e.g. 40-60, etc.
                grid[i][j] = 'g';
            } else if (randNum < cPct+bPct+gPct+kPct) {
                grid[i][j] = 'k';
            } else {
                grid[i][j] = 'm';
            }
        }
    }
    //grid is now full of coins, blanks, goombas, koopas, and mushrooms
    //Hero, warp pipe, and level boss will overwrite 3 of these squares
}