#include "FileProcessor.h"

FileProcessor::FileProcessor(){}

FileProcessor::~FileProcessor(){}

void FileProcessor::readFile(string file){
    string line;
    int i = -1;
    ifstream inFile(file);

    if (!inFile.is_open()){
        std::cout << "\nFile not found. Ensure file path and name are correct and try again.\n" << endl;
        exit(1);
    }

    while(getline(inFile, line)) {
        fLine[++i] = stoi(line); //store lines in int[] array
    }
}

void FileProcessor::writeFile(string content, string fileName){
    ofstream outputFile(fileName);
    outputFile << content; //write content into outputFile
    outputFile.close();

}
