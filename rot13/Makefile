all: zad

zad: zad.o
	ld zad.o -o zad
zad.o: zad.s
	as zad.s -o zad.o
clean:
	rm zad.o zad
