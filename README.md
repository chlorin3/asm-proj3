# asm-proj3
My assembly language mini-projects (university assignments)
### lab5_28.asm
Zdefiniuj tablicę 64 liczbową **we** =[ x0, x1,... , x63] (liczby typu WORD - dw), wypełnij ją przypadkowymi 
liczbami naturalnymi ≤ 24000 (Dec). 
Napisz program w assemblerze zawierający podprogram wyszukujący w wektorze we wartości xi, gdzie i=0,...,63, większe od 12000 (Dec) 
i zastępujący je liczbami yi=xi/3−400 oraz wartości xi, mniejsze od 800 (Dec) zastępując je liczbami yi=3⋅xi+ 400. Wskaźnik
do tablicy **we** oraz długość tablicy przekaż do podprogramu za pomocą stosu. 
Wyświetl na ekranie tablicę **we** przed i po operacji zamiany liczb stosując kod szesnastkowy lub dziesiętny.
