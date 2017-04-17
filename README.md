Brainfuck interpreter written with makefiles.
This serves no useful purpose, I just wanted to push what you could do with make.

To run

    make

To enable input
    
    g++ -o echoin echoin.cpp

To edit the brainfuck program, change the source in program.makefile. Just make sure not to add the # symbol,
as make reads this as a comment and it breaks the program.
