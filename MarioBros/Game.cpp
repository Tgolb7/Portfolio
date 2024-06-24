#include "Game.h"

using namespace std;

Game::Game(){
    srand(time(0)); //set random seed for RNG
    isAlive = true;
    l = new Level();
    log = "\n\n ~ M ~ A ~ R ~ I ~ O ~ ";
    lives = l->V;
    level = 0;
    heroX = 0;
    heroY = 0;
    occObj = 'x';
    coins = 0;
    powLev = 0;
    killCount = 0;

    for(int i = 0; i < l->L; ++i){
        if (isAlive) {
            level = i+1; //indexing starts at 0, levels start at 1
            l->setLevel(); //coins, blanks, mushrooms, goombas, koopas
            setSpecialObjects(); //Mario, warp pipe, and boss (only 1 per level)
            playLevel();
        }
    }

    if (isAlive){ //if alive after levels complete
        log += "\n\nMario saved the princess!";
        log += "\nCONGRATULATIONS, YOU WIN!";
        log += "\n\n~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ \n\n";
    }

    //write file with log of game activity
    FileProcessor *fp = new FileProcessor();
    fp->writeFile(log, l->outputFileName);
    delete fp;

    delete l;
}

Game::~Game(){}

void Game::setSpecialObjects(){
    heroX = randNum(l->N); //set hero coordinates
    heroY = randNum(l->N);
    int warpX = heroX; //start at hero coords, change until not on top of H
    int warpY = heroY;
    int bossX = heroX;
    int bossY = heroY;

    if (level < l->L) { //if not final level, add warp pipe
        while (warpX==heroX && warpY==heroY) { //ensure unique placement
            warpX = randNum(l->N);
            warpY = randNum(l->N);
        }
    }

    while ((bossX==heroX && bossY==heroY) || (bossX==warpX && bossY==warpY)) { //ensure unique placement
        bossX = randNum(l->N);
        bossY = randNum(l->N);
    }

    
    occObj = l->grid[heroX][heroY];

    l->grid[heroX][heroY] = 'H'; //place hero
    l->grid[warpX][warpY] = 'w'; //place warp pipe 
    l->grid[bossX][bossY] = 'b'; //place boss

}


void Game::playLevel(){
    isAlive = true;

    while(isAlive){
        log += "\n\n~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~";
        log += "\n\nLevel: " + to_string(level);
        log += "\nMario is at position (" + to_string(heroX) + ", " + to_string(heroY) + ")";
        log += "\nLives remaining: " + to_string(lives);
        log += "\nCoins in wallet: " + to_string(coins);
        log += "\nPower Level: " + to_string(powLev);
        printGrid(l->N);

        move(); //perform next hero move

        if (killCount == 7) { //7 kills = extra life
            killCount = 0;
            lives++;
            log += "\n\nEXTRA LIFE (7 consecutive kills)";
        }

        if (coins == 20) { //20 coins = extra life
            coins = 0;
            lives++;
            log += "\n\nEXTRA LIFE (20 coins)";
        }


        switch(occObj){
            case 'x': //blank
                log += "\nMario moves on.";
            break;

            case 'c': //coin
                coins++;
                log += "\nMario picked up a coin! (" + to_string(coins) + ")";
            break;

            case 'g': //goomba
                while (isAlive){
                    if((randNum(100))<80){
                        log += "\nMario fought a goomba and won!";
                        killCount++;
                        break;
                    } else { //if mario loses, power level decreases if available, lives decrease if available, or game over.
                        if (powLev >=1){
                            powLev--;
                            log += "\nMario fought a goomba and lost. Power Level: " + to_string(powLev);
                            log += "\nMario will STAY PUT.";
                        } else if (lives > 1){
                            lives--;
                            powLev = 0;
                            killCount = 0;    
                            log += "\nMario fought a goomba and lost.";
                            log += "\n" + to_string(lives) + " lives remaining.";
                            log += "\nMario will STAY PUT.";
                        } else {
                            log += "\nMario fought a goomba and DIED.";
                            log += "\n\nGAME OVER\n\n";
                            isAlive = false;
                            break;
                        }
                    }
                }
            break;

            case 'k': //koopa
                while (isAlive){
                    if((randNum(100))<65){
                        log += "\nMario fought a koopa and won!";
                        killCount++;
                        break;
                    } else { //if mario loses, power level decreases if available, lives decrease if available, or game over.
                        if (powLev > 0){
                            powLev -= 1;
                            log += "\nMario fought a koopa and lost. Power Level: " + to_string(powLev);
                            log += "\nMario will STAY PUT.\n";
                        } else if (lives > 1){
                            lives--;
                            powLev = 0;
                            killCount = 0;    
                            log += "\nMario fought a koopa and lost.";
                            log += "\n" + to_string(lives) + " lives remaining.";
                            log += "\nMario will STAY PUT.\n";
                        } else {
                            log += "\nMario fought a koopa and DIED.";
                            log += "\n\nGAME OVER\n\n";
                            isAlive = false;
                            break;
                        }
                    }
                }
            break;

            case 'm': //mushroom
                powLev++;
                log += "\nMario ate a mushroom! (Power Level: " + to_string(powLev) + ")";
            break;

            case 'b': //level boss
                while (isAlive){
                    if((randNum(100))<50){
                        log += "\nMario fought the level boss and won!";
                        if (level < l->L) {
                            log += "\nMario will move on to the next level!";
                        }
                        return;
                    } else { //if mario loses, power level decreases if available, lives decrease if available, or game over.
                        if (powLev >=2){
                            powLev -= 2;
                            log += "\nMario fought the level boss and lost. Power Level: " + to_string(powLev);
                            log += "\nMario will STAY PUT.\n";
                        } else if (lives > 1) {
                            lives--;
                            powLev = 0;
                            killCount = 0;    
                            log += "\nMario fought the level boss and lost.";
                            log += "\n" + to_string(lives) + " lives remaining.";
                            log += "\nMario will STAY PUT.\n";
                        } else {
                            log += "\nMario fought the level boss and DIED.";
                            log += "\n\nGAME OVER\n\n";
                            isAlive = false;
                            break;
                        }
                    }
                }
            break;

            case 'w': //warp pipe
                log += "\nMario warped to next level!";
                return; //ends level
            break;

            default: //theoretically never happens, error handling
                log += "\n\n\n~~~ error occured ~~~\n\n\n";
                return;
            break;
        }
    }
}

void Game::move(){
    int direction = randNum(4);
    l->grid[heroX][heroY] = 'x'; //previous location now blank

    log += "\n\nMario will move ";
    switch(direction){
        case 0: //up
            log += "UP.";
            if(heroX == 0){ //wrap to bottom if on the top edge moving up
                heroX = (l->N)-1;
            } else {
                heroX--;
            }
        break;
        case 1: //down
            log += "DOWN.";
            if(heroX == (l->N)-1){ //wrap to top if on the bottom edge moving down
                heroX = 0;
            } else {
                heroX++;
            }
        break;
        case 2: //left
            log += "LEFT.";
            if(heroY == 0){ //wrap to right edge if on left edge moving left
                heroY = (l->N)-1;
            } else {
                heroY--;
            }
        break;
        case 3: //right
            log += "RIGHT";
            if(heroY == (l->N)-1){ //wrap to left edge if on right edge moving right
                heroY = 0;
            } else {
                heroY++;
            }
        break;
    }
    occObj = l->grid[heroX][heroY]; //occupied object = whatever he moves to on the level grid
    l->grid[heroX][heroY] = 'H'; //occupied space becomes 'H'
}


int Game::randNum(int bound){ //helper function
    return rand()%(bound);
}

void Game::printGrid(int n) { //print grid of n size
    log += "\n";
    for (int i = 0; i < n; ++i){
        log += "\n";
        for (int j = 0; j < n; ++j){
            log += l->grid[i][j];
            log += " ";
        }
    }
}
