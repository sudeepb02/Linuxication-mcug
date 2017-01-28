cc=g++
cflag = -c

all :	hello

hello: main.o function1.o function2.o
		$(cc) main.o function1.o function2.o -o hello

main.o : main.cpp
		$(cc) $(cflag) main.cpp

function1.o: function1.cpp
		$(cc) $(cflag) function1.cpp

function2.o: function2.cpp
		$(cc) $(cflag) function2.cpp

clean:
		rm -rf *o hello
		


