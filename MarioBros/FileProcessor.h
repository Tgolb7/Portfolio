#ifndef FILEPROCESSOR_H
#define FILEPROCESSOR_H

#include <fstream>
#include <iostream>
#include <string>

using namespace std;

class FileProcessor {
    public:
        FileProcessor();
        ~FileProcessor();
        void readFile(string fileName);
        void writeFile(string content, string fileName);

        int fLine[8]; //int array of file lines
};

#endif
