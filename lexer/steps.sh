#!/bin/bash

lex first.l
yacc -d first_y.y
gcc y.tab.c -ll -ly -w
./a.out < test.txt
