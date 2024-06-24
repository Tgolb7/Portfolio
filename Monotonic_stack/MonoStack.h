#ifndef MONOSTACK_H
#define MONOSTACK_H

#include <iostream>
#include <exception>

using namespace std;

template<typename T>
class MonoStack {
    public:
        MonoStack(); //default constructor
        MonoStack(int maxSize, char o); //max size, order(increasing/decreasing)
        ~MonoStack(); //destructor

        //core functions
        void push(T data);
        T pop(); // return and remove
        T peek(); //just returns DOES NOT remove

        //aux functions
        void clear();
        string print();
        bool isEmpty();
        bool isFull();
        int getSize();

    private:
        char o;
        int top;
        int mSize;
        T *myArray;
};

template<typename T>
MonoStack<T>::MonoStack() {
    mSize = 64; //default size of our stack
    top = -1;
    myArray = new T[mSize];
}

template<typename T>
MonoStack<T>::MonoStack(int maxSize, char o) {
    if (o != 'i' && o != 'd') {
        throw std::runtime_error("Invalid argument: o must be \'i\' for increasing or \'d\' for decreasing monotonic stack.");
    }
    mSize = maxSize;
    top = -1;
    this->o = o; //store orientation of stack in private variable
    myArray = new T[mSize];
}

template<typename T>
MonoStack<T>::~MonoStack() {
    delete[] myArray;
}

template<typename T>
void MonoStack<T>::push(T data) {
    //if full, resizing necessary...
    if (isFull()) {
        T *temp = new T[2 * mSize];
        for (int i = 0; i < mSize; ++i) {
            temp[i] = myArray[i]; //copy data from old array into new larger array
        }
        mSize *= 2;
        delete[] myArray;
        myArray = temp;
    }

    if (o == 'i') {
        while (!isEmpty() && (data >= peek())) {
            pop();
        }
    } else if (o == 'd') {
        while (!isEmpty() && (data <= peek())) {
            pop();
        }
    }

    myArray[++top] = data; //will be on top of stack either way, increasing or decreasing
}

template<typename T>
T MonoStack<T>::pop() {
    if (isEmpty()) {
        throw std::runtime_error("stack is empty, nothing to pop");
    }
    return myArray[top--];
}

template<typename T>
T MonoStack<T>::peek() {
    if (isEmpty()) {
        throw std::runtime_error("stack is empty, nothing to peek");
    }
    return myArray[top];
}

template<typename T>
bool MonoStack<T>::isEmpty() {
    return (top == -1);
}

template <typename T>
void MonoStack<T>::clear() {
    while (!isEmpty()){
        pop();
    }
}

template<typename T>
bool MonoStack<T>::isFull() {
    return (top == mSize - 1);
}

template <typename T>
string MonoStack<T>::print() {
    if (isEmpty()){
        return "";
    }

    string toStr = "";
    while(!isEmpty()){
        toStr += (to_string(pop()) + ", ");
    }
    toStr.erase(toStr.length()-2, toStr.length());// erase comma and space
    return toStr;
}

template <typename T>
int MonoStack<T>::getSize()
{
    return top + 1;
}

#endif
