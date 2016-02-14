#!/bin/bash

rm Parser.java Lexer.java
rm *.class
jflex -d . jflex/minic.jflex
java -jar cup/java-cup-11b.jar -locations -interface -parser Parser -xmlactions cup/minic.cup
javac -cp cup/java-cup-11b-runtime.jar:. *.java
java -cp cup/java-cup-11b-runtime.jar:. Parser input.c output/simple.xml /
open /Applications/Google\ Chrome.app --args --allow-file-access-from-files '/Users/damianodistefano/Documents/mini_c_compiler/output/svg.html'
