#!/bin/bash

rm Parser.java Lexer.java
rm *.class
jflex minic.jflex
java -jar java-cup-11b.jar -locations -interface -parser Parser -xmlactions minic.cup
javac -cp java-cup-11b-runtime.jar:. *.java
java -cp java-cup-11b-runtime.jar:. Parser input.c simple.xml /
