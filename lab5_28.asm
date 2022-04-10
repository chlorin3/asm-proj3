;zad5 - wczytywanie i wy�wietlanie liczb w kodzie dziesi�tnym
;176035 Kamila Jaszkowska lab 5 zadanie 28

dane SEGMENT
cyfrywe dw 6 ; maksymalna liczba cyfr wczytywanej liczby w kodzie dziesi�tnym
cyfrywy dw 6 ; maksymalna liczba cyfr wy�wietlanej liczby w kodzie dziesi�tnym
tab 	dw 64 dup (?) ; tablica do przechowywania wczytanych liczb (w kodzie binarnym)
wyniki 	dw 64 dup (?) ; tablica do przechowywania wczytanych liczb (w kodzie binarnym)
ltb  	dw 64 ; liczba wczytywanych element�w tablicy tab
;***do sprawdzenia na ma�ej tablicy***
;tab 	dw 10 dup (?) ; tablica do przechowywania wczytanych liczb (w kodzie binarnym)
;wyniki dw 10 dup (?) ; tablica do przechowywania wczytanych liczb (w kodzie binarnym)
;ltb  	dw 10 ; liczba wczytywanych element�w tablicy tab
NL db 13, 10, '$'
dane 	ENDS

rozkazy SEGMENT 'CODE' use16 ;segment rozkazu
	ASSUME cs:rozkazy, ds:dane

startuj:
	mov bx, SEG dane
	mov ds, bx	
	mov es, bx	; przypisanie segmentu danych do rejestru es 
			    ; z kt�rym wsp�pracuje rejestr di

	;wczytywanie ltb liczb w kodzie dziesi�tnym i zapisywanie ich wartosci
	;binarnych do element�w tablicy liczb 16 bitowych  tab  (podprogram WczyLiczbe10)
	;wraz z wy�wietlaniem wczytanych element�w tablicy w postaci liczb w kodzie 
	;dziesi�tnym (podprogram WyswLiczbe10)

	mov ax, ltb ;liczba wczytywanych element�w tablicy tab
	mov cx, ax	;liczba obieg�w p�tli wczytywania
	mov si, 0	;rejestr s�u��cy do wyznaczania offsetu kolejnych element�w tab

p_gl:	; P�tla g��wna, pocz�tek 
	;umieszcznie na stosie dw�ch parametr�w wywo�ania podprogramu  WczyLiczbe10
	mov ax, offset tab
	add ax, si	;zwiekszenie offsetu tablicy o 2*indeks elementu tablicy
	push ax		;przekazywanie na stos offsetu elementu tablicy
	mov ax, cyfrywe  ;liczba cyfr wczytywanej liczby w kodzie dziesi�tnym
	push ax			 ;przekazywanie na stos  cyfrywe
	call WczyLiczbe10  ;wczytanie liczby dziesi�tnej do wskazanego elementu tablicy
	pop ax			;zdj�cie ze stosu  
	pop ax			;dw�ch warto�ci

	inc si		;przyrost si o 2,
	inc si		;gdy� tablica tab zawiera liczby 2 bajtowe

loop p_gl  	; P�tla g��wna, koniec

	mov ax,ltb
	mov cx,ax
	mov si, 0
;***********************************************
zadanie: 
	mov ax, offset tab
	add ax, si
	push ax
	mov ax, offset wyniki;konktrety elenment wynik�w oraz odpowiadaj�cy mu element z tab
	add ax, si
	push ax
	call Wyszukaj
	pop ax
	pop ax
	inc si
	inc si
loop 	zadanie
;*******PRZED OPERACJAMI************************
mov ax, ltb ;liczba wczytywanych element�w tablicy tab
mov cx, ax	
mov si, 0

tablica_przed: 
	;umieszcznie na stosie dw�ch parametr�w wywo�ania podprogramu  WyswLiczbe10
	mov ax, offset tab
	add ax, si	;zwiekszenie offsetu tablicy o 2*indeks elementu tablicy
	push ax		;przekazywanie na stos offsetu elementu tablicy
	mov ax, cyfrywy  ;liczba cyfr wy�wietlanej liczby w kodzie dziesi�tnym
	push ax		;przekazywanie na stos  cyfrywy
	call WyswLiczbe10 ;wy�wietlenie liczby w kodzie dziesi�tnym
	pop ax			;zdj�cie ze stosu  
	pop ax			;dw�ch warto�ci

	inc si		;przyrost si o 2,
	inc si		;gdy� tablica tab zawiera liczby 2 bajtowe

	call NowaLinia

loop tablica_przed

;*****PO OPERACJACH****************************
call NowaLinia
mov ax, ltb ;liczba wczytywanych element�w tablicy tab
mov cx, ax	
mov si, 0

tablica_po:
	;umieszcznie na stosie dw�ch parametr�w wywo�ania podprogramu  WyswLiczbe10
	mov ax, offset wyniki
	add ax, si	;zwiekszenie offsetu tablicy o 2*indeks elementu tablicy
	push ax		;przekazywanie na stos offsetu elementu tablicy
	mov ax, cyfrywy  ;liczba cyfr wy�wietlanej liczby w kodzie dziesi�tnym
	push ax		;przekazywanie na stos  cyfrywy
	call WyswLiczbe10 ;wy�wietlenie liczby w kodzie dziesi�tnym
	pop ax			;zdj�cie ze stosu  
	pop ax			;dw�ch warto�ci

	inc si		;przyrost si o 2,
	inc si		;gdy� tablica tab zawiera liczby 2 bajtowe

	call NowaLinia

loop 	tablica_po

	call koniec
;***********************************************************
;***********************************************************
;***********************************************************

WczyLiczbe10 PROC near
	push bp
	mov bp, sp
	push cx	;zapisanie na stosie wszystkich rejestr�w u�ywanych przez podprogram
	push bx	;
	push dx	;
	push si	;

	mov si, [bp]+6 ;wczytanie do rej. si offset'u zmiennej wyj�ciowej - pierwszy param. procedury
	
	mov ax, 0       	  ;wpisanie warto�ci poczatkowej 0
	mov word PTR [si], ax ;do zmiennej wyj�ciowej

	mov cx, [bp]+4 ;liczba wczytywanych cyfr dziesi�tnych - drugi param. procedury
czn: 
	mov ah, 07H ;wczytanie z klawiatury do rej. AL znaku w kodzie ASCII
	int 21H 	;bez wy�wietlania !!!
	cmp al, 13
	je jest_enter ;skok gdy nacisnieto klawisz Enter
	sub al, 30H ;zamaiana kodu ASCII na wartosc cyfry
	mov bl, al ;przechowanie kolejnej cyfry w rej. BL
	mov bh, 0  ;zerowanie rejestru BH
		   ;algorytm Hornera - wyznaczenie za pomoc� cyfr liczby wejsciowej 
		   ;(dziesi�tnej) jej warto�ci binarnej	
	mov ax, 10 ;mnoznik = 10 bo wczytujemy cyfry w kodzie dziesi�tnym
	mul word PTR [si] 	;mnozenie dotychczas uzyskanego wyniku przez 10, 
				        ;iloczyn zostaje wpisany do rejestr�w DX:AX
	add ax, bx 	        ;dodanie do wyniku mno�enia aktualnie wczytanej cyfry
	mov word PTR [si], ax	;przes�anie wyniku obliczenia do zmiennej wyj�ciowej
	loop czn;
	jmp dalej		;je�li wczytano wszystkie okre�lone przez drugi param. podprogramu
					;omijamy oczyszczenie bufora klawiatury ze znaku enter.

jest_enter:
	mov ah, 06H 	;Oczyszczenie bufora klawiatury ze znaku enter.  
	mov dl, 255		;Zabieg ten jest niezb�dny przy przetwarzaniu wsadowym, gdy  
	int 21H 		;przekierowujemy do programu strumie� danych w postaci pliku tekstowego  
					;z liczbami oddzielonymi enterem (komenda:  piaty.exe < dane.txt). 
					;- zabieg oczyszcenia bufora uzyskamy wstawiaj�c
					;do rej. DL warto�� 255 i wywo�uj�c funkcj� 06H przerwania 21H. 
dalej:	
	pop si 	; przywr�cenie warto�ci poczatkowych wszystkich rejestr�w 
	pop dx	; u�ywanych przez podprogram
	pop bx	; UWAGA! w odwrotnej kolejno�ci ni� by�o w to komendach push!
	pop cx	;

	pop bp
	ret
WczyLiczbe10 ENDP

;**************************

WyswLiczbe10 PROC near
	push bp
	mov bp, sp
	push cx	;zapisanie na stosie wszystkich rejestr�w u�ywanych przez podprogram
	push bx	;
	push dx	;
	push si	;
	mov si, [bp]+6
	mov ax,word PTR [si]

	mov cx, 0 	;licznik cyfr 
	mov bx, 10 	;dzielnik 
p1: 	mov dx, 0 	;zerowanie starszej cz�ci dzielnej 
	div bx 		;dzielenie przez 10 � iloraz w AX, reszta w DX 
	add dx, 30H 	;zamiana reszty na kod ASCII 
	push dx 	;zapisanie cyfry na stosie 
	inc cx 		;inkrementacja licznika cyfr		
	cmp ax, 0 	;por�wnanie uzyskanego ilorazu 
	jnz p1 		;skok gdy iloraz jest r�ny od zera 
p2: 	pop dx 		;pobranie kodu ASCII kolejnej cyfry 
	mov ah, 2 
	int 21H 	;wy�wietlenie cyfry na ekranie 
	loop p2 	; sterowanie p�tl� wy�wietlania

	pop si 	; przywr�cenie warto�ci poczatkowych wszystkich rejestr�w 
	pop dx	; u�ywanych przez podprogram
	pop bx	; UWAGA! w odwrotnej kolejno�ci!
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
	push bx	;zapisanie na stosie wszystkich rejestr�w u�ywanych przez podprogram
	push cx
	push dx
	mov dx,0
	mov bx, [bp]+6 ; tablica
	
	mov ax,[bx]
	cmp ax,12000 	
	ja licz1 	;je�li >12000 skorzystaj ze wzoru licz1
	cmp ax,800 	
	jb licz2	;je�li <800 skorzystaj ze wzoru licz2
	jmp przepisz	;w przeciwnym wypadku przepisz dan�
	
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
