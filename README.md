# Interpreter-Implementation-Using-Lex-And-Yacc
My interpreter implementation homework for Programming Languages Homework, used lex and yacc for implementation

To compile and run the code, follow these steps:
Firstly, you need cmake, you can install in ubuntu using these command

```
sudo apt install cmake
```
After that, you need to clone my project to your computer(On this example, the code below will download the code to your desktop, in the directory named Interpreter)

```
git clone https://github.com/BurakDmb/Interpreter-Implementation-Using-Lex-And-Yacc.git ~/Desktop/Interpreter
cd ~/Desktop/Interpreter
```
After that, create a temporary build folder to build project. Then, enter that folder
```
mkdir cmake-build-debug
cd cmake-build-debug
```
Lastly, run these commands to build and run the interpreter
```
cmake ..
make
./Interpreter
```
Or if you are using [CLion, A cross-platform IDE for C and C++](https://www.jetbrains.com/clion/) You can simply use the Import Project from Sources and run project from ide. You can easily build and run the project from the CLion
