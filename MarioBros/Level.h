/*

create NxN level filled with GameObjects

*/

#ifndef LEVEL_H
#define LEVEL_H

#include "Settings.h"
#include <iostream>

class Level {
    public:
        Level();
        ~Level();
        void setLevel();
        int L; //number of levels
        int N; //grid size
        int V; //number of initial lives
        char** grid;
        string outputFileName;

    private:
        int cPct;
        int bPct;
        int gPct;
        int kPct;
        int mPct;
        Settings *settings;
};

#endif
