;zad5 - wczytywanie i wyœwietlanie liczb w kodzie dziesiêtnym
;176035 Kamila Jaszkowska lab 5 zadanie 28

dane SEGMENT
cyfrywe dw 6 ; maksymalna liczba cyfr wczytywanej liczby w kodzie dziesiêtnym
cyfrywy dw 6 ; maksymalna liczba cyfr wyœwietlanej liczby w kodzie dziesiêtnym
tab 	dw 64 dup (?) ; tablica do przechowywania wczytanych liczb (w kodzie binarnym)
wyniki 	dw 64 dup (?) ; tablica do przechowywania wczytanych liczb (w kodzie binarnym)
ltb  	dw 64 ; liczba wczytywanych elementów tablicy tab
;***do sprawdzenia na ma³ej tablicy***
;tab 	dw 10 dup (?) ; tablica do przechowywania wczytanych liczb (w kodzie binarnym)
;wyniki dw 10 dup (?) ; tablica do przechowywania wczytanych liczb (w kodzie binarnym)
;ltb  	dw 10 ; liczba wczytywanych elementów tablicy tab
NL db 13, 10, '$'
dane 	ENDS

rozkazy SEGMENT 'CODE' use16 ;segment rozkazu
	ASSUME cs:rozkazy, ds:dane

startuj:
	mov bx, SEG dane
	mov ds, bx	
	mov es, bx	; przypisanie segmentu danych do rejestru es 
			    ; z którym wspó³pracuje rejestr di

	;wczytywanie ltb liczb w kodzie dziesiêtnym i zapisywanie ich wartosci
	;binarnych do elementów tablicy liczb 16 bitowych  tab  (podprogram WczyLiczbe10)
	;wraz z wyœwietlaniem wczytanych elementów tablicy w postaci liczb w kodzie 
	;dziesiêtnym (podprogram WyswLiczbe10)

	mov ax, ltb ;liczba wczytywanych elementów tablicy tab
	mov cx, ax	;liczba obiegów pêtli wczytywania
	mov si, 0	;rejestr s³u¿¹cy do wyznaczania offsetu kolejnych elementów tab

p_gl:	; Pêtla g³ówna, pocz¹tek 
	;umieszcznie na stosie dwóch parametrów wywo³ania podprogramu  WczyLiczbe10
	mov ax, offset tab
	add ax, si	;zwiekszenie offsetu tablicy o 2*indeks elementu tablicy
	push ax		;przekazywanie na stos offsetu elementu tablicy
	mov ax, cyfrywe  ;liczba cyfr wczytywanej liczby w kodzie dziesiêtnym
	push ax			 ;przekazywanie na stos  cyfrywe
	call WczyLiczbe10  ;wczytanie liczby dziesiêtnej do wskazanego elementu tablicy
	pop ax			;zdjêcie ze stosu  
	pop ax			;dwóch wartoœci

	inc si		;przyrost si o 2,
	inc si		;gdy¿ tablica tab zawiera liczby 2 bajtowe

loop p_gl  	; Pêtla g³ówna, koniec

	mov ax,ltb
	mov cx,ax
	mov si, 0
;***********************************************
zadanie: 
	mov ax, offset tab
	add ax, si
	push ax
	mov ax, offset wyniki;konktrety elenment wyników oraz odpowiadaj¹cy mu element z tab
	add ax, si
	push ax
	call Wyszukaj
	pop ax
	pop ax
	inc si
	inc si
loop 	zadanie
;*******PRZED OPERACJAMI************************
mov ax, ltb ;liczba wczytywanych elementów tablicy tab
mov cx, ax	
mov si, 0

tablica_przed: 
	;umieszcznie na stosie dwóch parametrów wywo³ania podprogramu  WyswLiczbe10
	mov ax, offset tab
	add ax, si	;zwiekszenie offsetu tablicy o 2*indeks elementu tablicy
	push ax		;przekazywanie na stos offsetu elementu tablicy
	mov ax, cyfrywy  ;liczba cyfr wyœwietlanej liczby w kodzie dziesiêtnym
	push ax		;przekazywanie na stos  cyfrywy
	call WyswLiczbe10 ;wyœwietlenie liczby w kodzie dziesiêtnym
	pop ax			;zdjêcie ze stosu  
	pop ax			;dwóch wartoœci

	inc si		;przyrost si o 2,
	inc si		;gdy¿ tablica tab zawiera liczby 2 bajtowe

	call NowaLinia

loop tablica_przed

;*****PO OPERACJACH****************************
call NowaLinia
mov ax, ltb ;liczba wczytywanych elementów tablicy tab
mov cx, ax	
mov si, 0

tablica_po:
	;umieszcznie na stosie dwóch parametrów wywo³ania podprogramu  WyswLiczbe10
	mov ax, offset wyniki
	add ax, si	;zwiekszenie offsetu tablicy o 2*indeks elementu tablicy
	push ax		;przekazywanie na stos offsetu elementu tablicy
	mov ax, cyfrywy  ;liczba cyfr wyœwietlanej liczby w kodzie dziesiêtnym
	push ax		;przekazywanie na stos  cyfrywy
	call WyswLiczbe10 ;wyœwietlenie liczby w kodzie dziesiêtnym
	pop ax			;zdjêcie ze stosu  
	pop ax			;dwóch wartoœci

	inc si		;przyrost si o 2,
	inc si		;gdy¿ tablica tab zawiera liczby 2 bajtowe

	call NowaLinia

loop 	tablica_po

	call koniec
;***********************************************************
;***********************************************************
;***********************************************************

WczyLiczbe10 PROC near
	push bp
	mov bp, sp
	push cx	;zapisanie na stosie wszystkich rejestrów u¿ywanych przez podprogram
	push bx	;
	push dx	;
	push si	;

	mov si, [bp]+6 ;wczytanie do rej. si offset'u zmiennej wyjœciowej - pierwszy param. procedury
	
	mov ax, 0       	  ;wpisanie wartoœci poczatkowej 0
	mov word PTR [si], ax ;do zmiennej wyjœciowej

	mov cx, [bp]+4 ;liczba wczytywanych cyfr dziesiêtnych - drugi param. procedury
czn: 
	mov ah, 07H ;wczytanie z klawiatury do rej. AL znaku w kodzie ASCII
	int 21H 	;bez wyœwietlania !!!
	cmp al, 13
	je jest_enter ;skok gdy nacisnieto klawisz Enter
	sub al, 30H ;zamaiana kodu ASCII na wartosc cyfry
	mov bl, al ;przechowanie kolejnej cyfry w rej. BL
	mov bh, 0  ;zerowanie rejestru BH
		   ;algorytm Hornera - wyznaczenie za pomoc¹ cyfr liczby wejsciowej 
		   ;(dziesiêtnej) jej wartoœci binarnej	
	mov ax, 10 ;mnoznik = 10 bo wczytujemy cyfry w kodzie dziesiêtnym
	mul word PTR [si] 	;mnozenie dotychczas uzyskanego wyniku przez 10, 
				        ;iloczyn zostaje wpisany do rejestrów DX:AX
	add ax, bx 	        ;dodanie do wyniku mno¿enia aktualnie wczytanej cyfry
	mov word PTR [si], ax	;przes³anie wyniku obliczenia do zmiennej wyjœciowej
	loop czn;
	jmp dalej		;jeœli wczytano wszystkie okreœlone przez drugi param. podprogramu
					;omijamy oczyszczenie bufora klawiatury ze znaku enter.

jest_enter:
	mov ah, 06H 	;Oczyszczenie bufora klawiatury ze znaku enter.  
	mov dl, 255		;Zabieg ten jest niezbêdny przy przetwarzaniu wsadowym, gdy  
	int 21H 		;przekierowujemy do programu strumieñ danych w postaci pliku tekstowego  
					;z liczbami oddzielonymi enterem (komenda:  piaty.exe < dane.txt). 
					;- zabieg oczyszcenia bufora uzyskamy wstawiaj¹c
					;do rej. DL wartoœæ 255 i wywo³uj¹c funkcjê 06H przerwania 21H. 
dalej:	
	pop si 	; przywrócenie wartoœci poczatkowych wszystkich rejestrów 
	pop dx	; u¿ywanych przez podprogram
	pop bx	; UWAGA! w odwrotnej kolejnoœci ni¿ by³o w to komendach push!
	pop cx	;

	pop bp
	ret
WczyLiczbe10 ENDP

;**************************

WyswLiczbe10 PROC near
	push bp
	mov bp, sp
	push cx	;zapisanie na stosie wszystkich rejestrów u¿ywanych przez podprogram
	push bx	;
	push dx	;
	push si	;
	mov si, [bp]+6
	mov ax,word PTR [si]

	mov cx, 0 	;licznik cyfr 
	mov bx, 10 	;dzielnik 
p1: 	mov dx, 0 	;zerowanie starszej czêœci dzielnej 
	div bx 		;dzielenie przez 10 – iloraz w AX, reszta w DX 
	add dx, 30H 	;zamiana reszty na kod ASCII 
	push dx 	;zapisanie cyfry na stosie 
	inc cx 		;inkrementacja licznika cyfr		
	cmp ax, 0 	;porównanie uzyskanego ilorazu 
	jnz p1 		;skok gdy iloraz jest ró¿ny od zera 
p2: 	pop dx 		;pobranie kodu ASCII kolejnej cyfry 
	mov ah, 2 
	int 21H 	;wyœwietlenie cyfry na ekranie 
	loop p2 	; sterowanie pêtl¹ wyœwietlania

	pop si 	; przywrócenie wartoœci poczatkowych wszystkich rejestrów 
	pop dx	; u¿ywanych przez podprogram
	pop bx	; UWAGA! w odwrotnej kolejnoœci!
	pop cx	;

	pop bp
	ret
WyswLiczbe10 ENDP

;**************************

NowaLinia PROC near
	push dx
	mov dx, offset NL
	mov ah, 9 
	int 21H
	pop dx
	ret
NowaLinia ENDP

;**************************

Wyszukaj PROC near
	push bp
	mov bp, sp
	push bx	;zapisanie na stosie wszystkich rejestrów u¿ywanych przez podprogram
	push cx
	push dx
	mov dx,0
	mov bx, [bp]+6 ; tablica
	
	mov ax,[bx]
	cmp ax,12000 	
	ja licz1 	;jeœli >12000 skorzystaj ze wzoru licz1
	cmp ax,800 	
	jb licz2	;jeœli <800 skorzystaj ze wzoru licz2
	jmp przepisz	;w przeciwnym wypadku przepisz dan¹
	
licz1:	
	mov bx, 3
	div bx
	sub ax,400
	jmp przepisz
licz2:	
	mov bx, 3
	mul bx
	add ax,400

przepisz:
	mov bx, [bp]+4 ;wyniki
	mov [bx],ax

	pop dx
	pop cx
	pop bx
	pop bp
	ret
	ret
Wyszukaj ENDP

;**************************

koniec PROC near
	mov al, 0
	mov ah, 4CH
	int 21H
koniec ENDP

;**************************

rozkazy ENDS

stosik SEGMENT stack
	dw 128 dup(?)
stosik ENDS
END startuj
