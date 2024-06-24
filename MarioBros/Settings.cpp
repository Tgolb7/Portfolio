#include "Settings.h"

Settings::Settings(){
    
}
Settings::~Settings(){}

void Settings::setPreferences(string file){
    fp = new FileProcessor();
    fp->readFile(file);

    for(int i = 0; i < 8; ++i){
        settings[i] = fp->fLine[i];
    }

    L           = settings[0]; //num levels
    N           = settings[1]; //grid dimensions
    V           = settings[2]; //initial lives
    coinPct     = settings[3];
    blankPct    = settings[4];
    goombaPct   = settings[5];
    koopaPct    = settings[6];
    mushroomPct = settings[7];

    delete fp;
}

/*
string Settings::getPreferences(){ //helper function for debugging
    return 
        "\nNumber of levels:    " + to_string(L) +
        "\nGrid dimensions:     " + to_string(N) +
        "\nNumber of lives      " + to_string(V) +       
        "\nCoin percentage:     " + to_string(coinPct) +
        "\nBlank percentage:    " + to_string(blankPct) +
        "\nGoomba percentage:   " + to_string(goombaPct) +
        "\nKoopa percentage:    " + to_string(koopaPct) +
        "\nMushroom percentage: " + to_string(mushroomPct);
}
*/
