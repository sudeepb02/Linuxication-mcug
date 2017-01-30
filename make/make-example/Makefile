all: calc

calc:	add.o sub.o mul.o div.o main.o
	g++ add.o sub.o mul.o div.o main.o -o calc

add.o:	add.cpp
	g++ -c add.cpp

sub.o:	sub.cpp
	g++ -c sub.cpp

mul.o:	mul.cpp
	g++ -c mul.cpp

div.o:	div.cpp
	g++ -c div.cpp

main.o:	main.cpp
	g++ -c main.cpp

clean: 
	rm calc *.o
