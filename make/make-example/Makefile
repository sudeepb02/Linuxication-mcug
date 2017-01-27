all: calc

# $^ means all the target files
calc: main.cpp add.cpp div.cpp mul.cpp sub.cpp
	g++ -o calc $^

clean: calc
	rm calc
