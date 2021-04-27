# C++ Mini-Compiler 

This project is a Mini compiler developed for C-like object oriented programming language,  C++. The compiler designed takes care of basic syntax and semantics, along with if construct and switch construct.

The aim of this project is to generate an optimized intermediate code for a given C++ input source code.

The phases of the project are as follows:
1. Lexical Analysis
2. Semantic Analysis
3. Construction of Symbol table
4. Generating Three Address Code, and Quadruple format TAC
5. Code Optimization

The Grammar folder contains the context free grammar used in this project.

The project has been developed using LEX, YACC and Python3.

To run the project, follow the steps:

1. Clone the repo
2. cd Demo
3. lex lexer.l
4. yacc -d parser.y
5. gcc y.tab.c -ll -ly 
6. ./a.out < input_file.cpp 
7. python3 optimization.py

Outputs : icg.txt, quadruple.txt, optimized_icg.txt