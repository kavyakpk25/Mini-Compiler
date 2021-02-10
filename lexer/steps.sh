#!/bin/bash

lex first.l
yacc -d first_y.y
gcc lex.yy.c y.tab.h -ll 
./a.out < test.txt
