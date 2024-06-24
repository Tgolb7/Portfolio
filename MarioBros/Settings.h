#ifndef SETTINGS_H
#define SETTINGS_H

#include "FileProcessor.h"
#include <iostream>
#include <string>

using namespace std;

class Settings {
    public:
        Settings();
        ~Settings();
        void setPreferences(string file);
        string getPreferences();

        int L; //number of levels
        int N; //dimensions of grid
        int V; //initial lives
        int coinPct;
        int blankPct;
        int goombaPct; 
        int koopaPct;
        int mushroomPct;

    private:
        FileProcessor *fp;
        int settings[8];
};

#endif
