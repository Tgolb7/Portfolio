/*
creates L number of Levels
creates and controls hero, H
controls actions of hero and game flow
contains method which returns each move output to FileProcessor
*/


#ifndef GAME_H
#define GAME_H

#include "Level.h"

#include <string>
#include <iostream>

class Game {
    public:
        Game();
        ~Game();
    
    private:
        void setSpecialObjects();
        void playLevel();
        void move();
        int randNum(int bound);
        void printGrid(int n);
        Level *l;
        int level;
        int heroX;
        int heroY;
        char occObj; //object that mario 'steps' on
        int coins;
        int powLev;
        int lives;
        int killCount;
        int gridSize;
        string log;
        bool isAlive;
};

#endif
