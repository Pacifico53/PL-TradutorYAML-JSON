all:
	flex -o lex.yy.c flex.l
	yacc -v -d yacc.y
	gcc -o o y.tab.c

clean:
	rm -f *.c *.h y.output o
