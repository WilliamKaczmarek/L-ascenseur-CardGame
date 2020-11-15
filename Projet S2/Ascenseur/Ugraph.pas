unit Ugraph;
{$mode objfpc}
interface
	uses sysutils,UBase,UCarte,gLib2D, SDL,SDL_TTF;

	procedure ReglesduJeu();//WK
	procedure Score(LesJoueur:TabJoueur);//WK et TJ
	procedure partiecours();//WK
	function NomsDesJoueurs(j:integer):string;//WK
	function choixIA(): integer; //WK
	function choixjoueurs(): integer;//WK
	function fenetreparam(): boolean;//WK
	function fenetremenu(): boolean;//WK
	function JouerUneCertaineCarte(Tete:Ptr_Noeud;Tableau:TabdynV2;LesJoueurs:TabJoueur;JoueurActuel:integer):integer;
	function Pli(PlisRestant:integer;LesJoueur:TabJoueur;JoueurActuel:integer;ATOUT1:string):integer;//Wk
	procedure RemportDePli(nom:string);	
implementation

(******************************************************************************Fenetre qui explique Toute les règles ****************************************************************************************************************)
procedure ReglesduJeu();
var BLACK: gColor = (r : 0;   g : 0;   b : 0;   a : 255);
	Regles: gImage;
	a:string;
	down1,check,Sortie:boolean;
begin
a:='./carte/regles.png';
Regles:=gTexLoad(a);//ecran Des regles
down1:=false;
check:=false;
Sortie:=false;
gBeginRects(Regles);
	gClear(BLACK);
	gBlit(0,0,Regles,800,600);
	gFlip();
WHILE true DO BEGIN
	if ((sdl_mouse_left_down) and (a='./carte/regles.png')) then down1:=true ;
	if ((sdl_mouse_left_up) and (down1)) then 
		Begin 
		a:='./carte/regles2.png';
		Regles:=gTexLoad(a);//ecran Des regles2
		gBeginRects(Regles);
		gBlit(0,0,Regles,800,600);
		gFlip();
		check:=true;
		End;
	if ((sdl_mouse_left_down) and (check)) then Sortie:=true;
WHILE (sdl_update = 1) DO
if (Sortie) then exit;

IF sdl_do_quit THEN exit;
END;
end;
(*************************************************DERNIERE FENETRE SCORE************************************************************************************************************************)
procedure Score(LesJoueur:TabJoueur);
var BLACK: gColor = (r : 0;   g : 0;   b : 0;   a : 255);
	SCORE, NomGagnant,NomDeuxieme,Nom3eme,Nom4eme,Nom5eme: gImage;
	ScoreGagnant,ScoreDeuxieme,Score3eme,Score4eme,Score5eme: gImage;
	Scorestring1,Scorestring2,Scorestring3,Scorestring4,Scorestring5 : string;
	i: integer;
	font : PTTF_Font; //police	
begin
SCORE:=gTexLoad('./carte/Score.png');//ecran partie en cours
font := TTF_OpenFont('fixedsys.ttf', 45);
for i:=1 to length(LesJoueur) do 
	Begin
	case i of 
		1:begin 
		NomGagnant:= gTextLoad(LesJoueur[0].Prenom, font);
		Scorestring1:=Inttostr(LesJoueur[0].Points);
		ScoreGagnant:= gTextLoad(Scorestring1, font);
		End;   
		2:begin
		NomDeuxieme:= gTextLoad(LesJoueur[1].Prenom, font);
		Scorestring2:=Inttostr(LesJoueur[1].Points);
		ScoreDeuxieme:= gTextLoad(Scorestring2, font);
		end; 
		3:begin 
		Nom3eme := gTextLoad(LesJoueur[2].Prenom, font);
		Scorestring3:=Inttostr(LesJoueur[2].Points);
		Score3eme := gTextLoad(Scorestring3, font);
		end; 
		4:begin 
		Nom4eme := gTextLoad(LesJoueur[3].Prenom, font);
		Scorestring4:=Inttostr(LesJoueur[3].Points);
		Score4eme := gTextLoad(Scorestring4, font);
		end; 
		5:begin 
		Nom5eme := gTextLoad(LesJoueur[4].Prenom, font); 
		Scorestring5:=Inttostr(LesJoueur[4].Points);
		Score5eme := gTextLoad(Scorestring5, font);
		end; 
	end;
end;		
WHILE true DO BEGIN
	gClear(BLACK);
	gBeginRects(SCORE);
	gBlit(0,0,SCORE,800,600);
{
	if sdl_mouse_left_down then
		begin
		writeln('x : ',sdl_get_mouse_x);
		writeln('y : ',sdl_get_mouse_y);
		end;
}
	// on affiche le nom des joueur qui ont deja fais un plis 							BILAN PLIS	

        gBeginRects(NomGagnant);//Nom  1er
        gSetCoordMode(G_CENTER);
        gSetCoord(300,202);
        gSetScaleWH(100,40);
        gSetColor(BLACK);
        gAdd();
		gEnd();
		
        gBeginRects(NomDeuxieme);//Nom  2eme
        gSetCoordMode(G_CENTER);
        gSetCoord(300,262);
		gSetScaleWH(100,40);
        gSetColor(BLACK);
        gAdd();
		gEnd();
		
		if (length(LesJoueur)>2) then
        Begin
        gBeginRects(Nom3eme);//Nom  3eme
        gSetCoordMode(G_CENTER);
        gSetCoord(300,322);
		gSetScaleWH(100,40);
        gSetColor(BLACK);
        gAdd();
		gEnd();
		End;
		
		if (length(LesJoueur)>3) then
        Begin
        gBeginRects(Nom4eme);//Nom  4eme
        gSetCoordMode(G_CENTER);
        gSetCoord(300,382);
		gSetScaleWH(100,40);
        gSetColor(BLACK);
        gAdd();
		gEnd();
		End;
		
		if (length(LesJoueur)>4) then
        Begin
        gBeginRects(Nom5eme);//Nom  5eme
        gSetCoordMode(G_CENTER);
        gSetCoord(300,442);
		gSetScaleWH(100,40);
        gSetColor(BLACK);
        gAdd();
		gEnd();
		End;
//SCORE
		gBeginRects(ScoreGagnant);//SCORE  1er
        gSetCoordMode(G_CENTER);
        gSetCoord(500,202);
        gSetScaleWH(50,60);
        gSetColor(BLACK);
        gAdd();
		gEnd();
		
        gBeginRects(ScoreDeuxieme);//SCORE  2eme
        gSetCoordMode(G_CENTER);
        gSetCoord(500,262);
		gSetScaleWH(50,60);
        gSetColor(BLACK);
        gAdd();
		gEnd();
		
		
        if (length(LesJoueur)>2) then
        Begin
        gBeginRects(Score3eme);//SCORE  3eme
        gSetCoordMode(G_CENTER);
        gSetCoord(500,322);
		gSetScaleWH(50,60);
        gSetColor(BLACK);
        gAdd();
		gEnd();
		End;
		
		if (length(LesJoueur)>3) then
        Begin
        gBeginRects(Score4eme);//SCORE  4eme
        gSetCoordMode(G_CENTER);
        gSetCoord(500,382);
		gSetScaleWH(50,60);
        gSetColor(BLACK);
        gAdd();
		gEnd();
		End;
		
		if (length(LesJoueur)>4) then
        Begin
        gBeginRects(Score5eme);//SCORE  5eme
        gSetCoordMode(G_CENTER);
        gSetCoord(500,442);
		gSetScaleWH(50,60);
        gSetColor(BLACK);
        gAdd();
		gEnd();
		End; 
			
		gFlip();
WHILE (sdl_update = 1) DO
if sdl_mouse_left_down then exit;
IF sdl_do_quit THEN exit;
END;
end;
(******************************************************************************5eme fenetre partie en cours ****************************************************************************************************************)

procedure partiecours();
var BLACK: gColor = (r : 0;   g : 0;   b : 0;   a : 255);
	partieencours: gImage;
begin
partieencours:=gTexLoad('./carte/partieencours.png');//ecran partie en cours
WHILE true DO BEGIN
	gClear(BLACK);
	gBeginRects(partieencours);
	gBlit(0,0,partieencours,800,600);
	//gFillRect(200, 220, 420, 130, WHITE);		
		gFlip();
		exit;
WHILE (sdl_update = 1) DO
IF sdl_do_quit THEN exit;
END;
end;
(****************************************************************************************4eme FENETRE NOMS DES JOUEURS ***************************************************************************************************************)
function NomsDesJoueurs(j:integer):string;
var
    PSEUDO,NUMJ, nomsdesJ : gImage;
    font : PTTF_Font;    
    nom,numero:string;
    i:integer;
begin
(* gClear : Juste pour lancer le mode graphique, et activer les polices *)
    gClear(BLACK);    
    font := TTF_OpenFont('fixedsys.ttf', 45);
    nom:=' ';
    i:=0;
    numero:= inttostr(j);    
    NUMJ := gTextLoad(numero, font);    //Textbox pour le numero du joueur
    PSEUDO := gTextLoad(nom, font);  //Textbox ou le joueur ecris son nom     
    nomsdesJ:=gTexLoad('./carte/nomsdesJ.png'); //FOND	
	WHILE true DO BEGIN           
        gClear(BLACK);        
        gBeginRects(nomsdesJ); //FOND
		gBlit(0,0,nomsdesJ,800,600); //on affiche le FOND 
        gBeginRects(NUMJ);	//NUMERO DU J
		gSetCoordMode(G_CENTER);
        gSetCoord(515,176);
        gSetColor(BLACK);
        gAdd();
		gEnd();  
        gBeginRects(PSEUDO);//PSEUDO
        gSetCoordMode(G_CENTER);
        gSetCoord(G_SCR_W div 2, G_SCR_H div 2);
        gSetColor(BLACK);
        gAdd();
		gEnd();   
		     
        gFlip();
        
        if (i<>0) then
			Begin
			inc(i);
			if (i=10) then i:=0;
			End; 
        if (i=0) then 
        Begin
        case sdl_get_keypressed of
                SDLK_BACKSPACE : if (length(nom)<>1) then begin delete(nom,length(nom),1); PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_SPACE : begin nom:=nom+' '; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_RETURN : begin 
										begin 
											writeln('sdl update : ');
											{NomsDesJoueurs:=nom; //on recupere le pseudo du joueurs
											nom:=' ';
											W:=0;}
											WHILE (sdl_update = 1) DO 
												begin
												delete(nom,1,1);
												exit(nom);
												end;
										end;
								end;
                SDLK_B : begin nom:=nom+'B'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_A : begin nom:=nom+'A'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_C : begin nom:=nom+'C'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_D : begin nom:=nom+'D'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_E : begin nom:=nom+'E'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_F : begin nom:=nom+'F'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_G : begin nom:=nom+'G'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_H : begin nom:=nom+'H'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_I : begin nom:=nom+'I'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_J : begin nom:=nom+'J'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_K : begin nom:=nom+'K'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_L : begin nom:=nom+'L'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_M : begin nom:=nom+'M'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_N : begin nom:=nom+'N'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_O : begin nom:=nom+'O'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_P : begin nom:=nom+'P'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_Q : begin nom:=nom+'Q'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_R : begin nom:=nom+'R'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_S : begin nom:=nom+'S'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_T : begin nom:=nom+'T'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_U : begin nom:=nom+'U'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_V : begin nom:=nom+'V'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_W : begin nom:=nom+'W'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_X : begin nom:=nom+'X'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_Y : begin nom:=nom+'Y'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                SDLK_Z : begin nom:=nom+'Z'; PSEUDO := gTextLoad(nom, font); inc(i); end;
                end; 
           	End;
	 
	WHILE (sdl_update = 1) DO
	IF sdl_do_quit THEN exit;
END; 
end;
(*************************************************Troisieme FENETRE NOMBRE D IA *****************************************************************)
function choixIA(): integer;
var  
    BLACK: gColor = (r : 0;   g : 0;   b : 0;   a : 255);   
	clic: boolean;
	x,y : real;
	nbrIA: gImage;
begin
clic:=false;
nbrIA:=gTexLoad('./carte/nbrIA.png');//ecran du choix des IA

	gClear(BLACK);
	gBeginRects(nbrIA);
	gBlit(0,0,nbrIA,800,600);
	gFlip();
WHILE true DO BEGIN
	//gFillRect(20, 300, 35, 35, WHITE);		
	If clic then
	begin
      x := sdl_get_mouse_x;
      y:= sdl_get_mouse_y;
      if ((20<x) and (x<60) and (300<y) and (y<340)) then //1 joueurs IA
		begin
			WHILE (sdl_update = 1) DO 
				begin
				exit(0);
				end;
		end;
	  if ((160<x) and (x<200) and (300<y) and (y<340)) then //1 joueurs IA
		begin
			WHILE (sdl_update = 1) DO 
				begin
				exit(1);
				end;
		end;
	 if ((300<x) and (x<340) and (300<y) and (y<340)) then //2 joueurs IA
		begin
			WHILE (sdl_update = 1) DO 
				begin
				exit(2);
				end;
		end;
	 if ((440<x) and (x<480) and (300<y) and (y<340)) then //3 joueurs IA
		begin
			WHILE (sdl_update = 1) DO 
				begin
				exit(3);
				end;
		end;
	if ((580<x) and (x<620) and (300<y) and (y<340)) then //4 joueurs IA
		begin
			WHILE (sdl_update = 1) DO 
				begin
				exit(4);
				end;
		end;
	if ((720<x) and (x<760) and (300<y) and (y<340)) then //5 joueurs IA
		begin
			WHILE (sdl_update = 1) DO 
				begin
				exit(5);
				end;
		end;	
	end;
WHILE (sdl_update = 1) DO
IF sdl_do_quit THEN exit;
IF sdl_mouse_left_down THEN clic:= true;
IF sdl_mouse_left_up THEN clic:= false;
END;
end;
(*************************************************deuxième FENETRE NOMBRE DE JOUEURS *****************************************************************)
function choixjoueurs(): integer;
var  
    BLACK: gColor = (r : 0;   g : 0;   b : 0;   a : 255);   
	clic: boolean;
	x,y : real;
	nbrjoueur: gImage;
begin
clic:=false;
nbrjoueur:=gTexLoad('./carte/nbrjoueur.png');//ecran du choix des joueurs

	gClear(BLACK);
	gBeginRects(nbrjoueur);
	gBlit(0,0,nbrjoueur,800,600);
	gFlip();
WHILE true DO BEGIN
	//gFillRect(575, 365, 40, 40, WHITE);		
	If clic then
	begin
      x := sdl_get_mouse_x;
      y:= sdl_get_mouse_y;
	  
	 if ((180<x) and (x<220) and (365<y) and (y<405)) then //2 joueurs humain
		begin
			//choixIA();
			WHILE (sdl_update = 1) DO 
				begin
				exit(2);
				end;
		end;
	 if ((300<x) and (x<340) and (365<y) and (y<405)) then //3 joueurs humain
		begin
			//choixIA();
			WHILE (sdl_update = 1) DO 
				begin
				exit(3);
				end;
		end;
	if ((450<x) and (x<490) and (365<y) and (y<405)) then //4 joueurs humain
		begin
			
			//choixIA();
			WHILE (sdl_update = 1) DO 
				begin
				exit(4);
				end;
		end;
	 if ((575<x) and (x<605) and (365<y) and (y<405)) then //5 joueurs humain
		begin		
			//choixIA();
			WHILE (sdl_update = 1) DO 
				begin
				exit(5);
				end;
		end;
		
	end;
WHILE (sdl_update = 1) DO
IF sdl_do_quit THEN exit;
IF sdl_mouse_left_down THEN clic:= true;
IF sdl_mouse_left_up THEN clic:= false;
END;
end;
(*************************************************PARAMAETRE FENETRE PARAMETRE *****************************************************************)
function fenetreparam(): boolean;
var BLACK: gColor = (r : 0;   g : 0;   b : 0;   a : 255);
	x,y : real;
	param: gImage;
begin
param:=gTexLoad('./carte/param.png'); //ecran si le fichier parametre est deja present

	gClear(BLACK);
	gBeginRects(param); 
	gBlit(0,0,param,800,600);
	gFlip();
WHILE true DO BEGIN
	//gFillRect(445, 370,  75, 65, WHITE);		
	If sdl_mouse_left_down then
	begin
		x := sdl_get_mouse_x;
		y:= sdl_get_mouse_y;
		if ((245<x) and (x<300) and (370<y) and (y<445)) then // CLiQUE SUR oui
		begin
			fenetreparam:=false;
			WHILE (sdl_update = 1) DO 
				begin
				exit;
				end;
		end;
		if ((445<x) and (x<525) and (370<y) and (y<445)) then // CLiQUE SUR NON
		begin
			fenetreparam:=true;
			WHILE (sdl_update = 1) DO 
				begin
				exit;
				end;
		end;
	end;
WHILE (sdl_update = 1) DO
IF sdl_do_quit THEN exit;
END;
end;
(*************************************************Premiere FENETRE JOUER *****************************************************************)
function fenetremenu(): boolean;
var BLACK: gColor = (r : 0;   g : 0;   b : 0;   a : 255);   
	clic: boolean;
	x,y : real;
	menu: gImage;
begin
clic:=false;
menu:=gTexLoad('./carte/menu.png'); //MENU
gClear(BLACK);
gBeginRects(menu); 
gBlit(0,0,menu,800,600);
gFlip();

WHILE true DO BEGIN
	//gFillRect(200, 220, 420, 130, WHITE);		
	If clic then
	begin
		x := sdl_get_mouse_x;
		y:= sdl_get_mouse_y;
		//Sdl_update;
		if ((200<x) and (x<620) and (220<y) and (y<350)) then
		begin
			fenetremenu:=true;
			WHILE (sdl_update = 1) DO 
				begin
				exit;
				end;
		end;
	end;
WHILE (sdl_update = 1) DO
IF sdl_do_quit THEN exit; 
IF sdl_mouse_left_down THEN clic:= true;
IF sdl_mouse_left_up THEN clic:= false;
END;
end;
(*************************************************Fenetre AFFICHAGE DES CARTE ET JEUX *****************************************************************)

function JouerUneCertaineCarte(Tete:Ptr_Noeud;Tableau:TabdynV2;LesJoueurs:TabJoueur;JoueurActuel:integer):integer;
var 
P1,P2,P3,P4,P5,Contrat5,Contrat4,Contrat3,Contrat2,Contrat1,J1,J2,J3,J4,J5,Atout,place1,place2,place3,place4,place5,TheName,fond,m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12,m13,m14,m15,m16,m17,m18,m19,m20,m21,m22,m23,m24,m25,m26:gImage;
x,i,renvoi:integer;
a,C1,C2,C3,C4,C5:string;
font:PTTF_Font;
Begin
font := TTF_OpenFont('fixedsys.ttf', 45); 
TheName:=gTextLoad(LesJoueurs[JoueurActuel].Prenom,font);
renvoi:=27;
gClear(BLACK);
{Chargement}
fond:=gTexLoad('./carte/JEU.png');
m1:=gTexLoad('./carte/back.png');
m2:=gTexLoad('./carte/back.png');
m3:=gTexLoad('./carte/back.png');
m4:=gTexLoad('./carte/back.png');
m5:=gTexLoad('./carte/back.png');
m6:=gTexLoad('./carte/back.png');
m7:=gTexLoad('./carte/back.png');
m8:=gTexLoad('./carte/back.png');
m9:=gTexLoad('./carte/back.png');
m10:=gTexLoad('./carte/back.png');
m11:=gTexLoad('./carte/back.png');
m12:=gTexLoad('./carte/back.png');
m13:=gTexLoad('./carte/back.png');
m14:=gTexLoad('./carte/back.png');
m15:=gTexLoad('./carte/back.png');
m16:=gTexLoad('./carte/back.png');
m17:=gTexLoad('./carte/back.png');
m18:=gTexLoad('./carte/back.png');
m19:=gTexLoad('./carte/back.png');
m20:=gTexLoad('./carte/back.png');
m21:=gTexLoad('./carte/back.png');
m22:=gTexLoad('./carte/back.png');
m23:=gTexLoad('./carte/back.png');
m24:=gTexLoad('./carte/back.png');
m25:=gTexLoad('./carte/back.png');
m26:=gTexLoad('./carte/back.png');
Atout:=gTexLoad('./carte/back.png');
place1:=gTexLoad('./carte/back.png');
place2:=gTexLoad('./carte/back.png');
place3:=gTexLoad('./carte/back.png');
place4:=gTexLoad('./carte/back.png');
place5:=gTexLoad('./carte/back.png');
{Partie affichage des cartes}
for i:=1 to longueur(Tete) do 
	Begin
	case i of 
		1:begin a:=CardToImg(NemeNoeud(Tete,i)); m1:=gTexLoad(a); End;
		2:begin a:=CardToImg(NemeNoeud(Tete,i)); m2:=gTexLoad(a); End;
		3:begin a:=CardToImg(NemeNoeud(Tete,i)); m3:=gTexLoad(a); End;
		4:begin a:=CardToImg(NemeNoeud(Tete,i)); m4:=gTexLoad(a); End;
		5:begin a:=CardToImg(NemeNoeud(Tete,i)); m5:=gTexLoad(a); End;
		6:begin a:=CardToImg(NemeNoeud(Tete,i)); m6:=gTexLoad(a); End;
		7:begin a:=CardToImg(NemeNoeud(Tete,i)); m7:=gTexLoad(a); End;
		8:begin a:=CardToImg(NemeNoeud(Tete,i)); m8:=gTexLoad(a); End;
		9:begin a:=CardToImg(NemeNoeud(Tete,i)); m9:=gTexLoad(a); End;
		10:begin a:=CardToImg(NemeNoeud(Tete,i)); m10:=gTexLoad(a); End;
		11:begin a:=CardToImg(NemeNoeud(Tete,i)); m11:=gTexLoad(a); End;
		12:begin a:=CardToImg(NemeNoeud(Tete,i)); m12:=gTexLoad(a); End;
		13:begin a:=CardToImg(NemeNoeud(Tete,i)); m13:=gTexLoad(a); End;
		14:begin a:=CardToImg(NemeNoeud(Tete,i)); m14:=gTexLoad(a); End;
		15:begin a:=CardToImg(NemeNoeud(Tete,i)); m15:=gTexLoad(a); End;
		16:begin a:=CardToImg(NemeNoeud(Tete,i)); m16:=gTexLoad(a); End;
		17:begin a:=CardToImg(NemeNoeud(Tete,i)); m17:=gTexLoad(a); End;
		18:begin a:=CardToImg(NemeNoeud(Tete,i)); m18:=gTexLoad(a); End;
		19:begin a:=CardToImg(NemeNoeud(Tete,i)); m19:=gTexLoad(a); End;
		20:begin a:=CardToImg(NemeNoeud(Tete,i)); m20:=gTexLoad(a); End;
		21:begin a:=CardToImg(NemeNoeud(Tete,i)); m21:=gTexLoad(a); End;
		22:begin a:=CardToImg(NemeNoeud(Tete,i)); m22:=gTexLoad(a); End;
		23:begin a:=CardToImg(NemeNoeud(Tete,i)); m23:=gTexLoad(a); End;
		24:begin a:=CardToImg(NemeNoeud(Tete,i)); m24:=gTexLoad(a); End;
		25:begin a:=CardToImg(NemeNoeud(Tete,i)); m25:=gTexLoad(a); End;
		26:begin a:=CardToImg(NemeNoeud(Tete,i)); m26:=gTexLoad(a); End;
		else writeln('Pas possible function jouerunecertainecarte');
	End;
End;
for i:=0 to high(Tableau) do 
	Begin
	if (Tableau[i]<>'') then 
		Begin
		case i of 
			0:begin a:=CardToImg(Tableau[i]); Atout:=gTexLoad(a); End;
			1:begin a:=CardToImg(Tableau[i]); place1:=gTexLoad(a); End;
			2:begin a:=CardToImg(Tableau[i]); place2:=gTexLoad(a); End;
			3:begin a:=CardToImg(Tableau[i]); place3:=gTexLoad(a); End;
			4:begin a:=CardToImg(Tableau[i]); place4:=gTexLoad(a); End;
			5:begin a:=CardToImg(Tableau[i]); place5:=gTexLoad(a); End;
		End;
		End;
	End;
	{Chargement du fond}
	gBeginRects(fond);
	gBlit(0,0,fond,800,600);
	
	{Chargement du Tableau des scores}
	if (length(LesJoueurs)>0) then 
		Begin
			//Prenom
			J1:=gTextLoad(LesJoueurs[0].Prenom,font);
			gBeginRects(J1);
				gSetCoordMode(G_CENTER);
				gSetCoord(255,33);
				gSetScaleWH(70,25);
				gSetColor(BLACK);
				gAdd();
				gEnd();
			//Contrat
				C1:=IntToStr(LesJoueurs[0].PliGagne)+'/'+IntToStr(LesJoueurs[0].Contrat);
			Contrat1:=gTextLoad(C1,font);
			gBeginRects(Contrat1);
				gSetCoordMode(G_CENTER);
				gSetCoord(255,73);
				gSetScaleWH(70,25);
				gSetColor(BLACK);
				gAdd();
				gEnd();
			//Points
			if (abs(LesJoueurs[0].Points)<10) then x:=30
			else x:=70;
			P1:=gTextLoad(IntToStr(LesJoueurs[0].Points),font);
			gBeginRects(P1);
				gSetCoordMode(G_CENTER);
				gSetCoord(255,120);
				gSetScaleWH(x,35);
				gSetColor(BLACK);
				gAdd();
				gEnd();
		End;
	if (length(LesJoueurs)>1) then 
		Begin
			//Prenom
			J2:=gTextLoad(LesJoueurs[1].Prenom,font);
			gBeginRects(J2);
				gSetCoordMode(G_CENTER);
				gSetCoord(342,33);
				gSetScaleWH(70,25);
				gSetColor(BLACK);
				gAdd();
				gEnd();
			//Contrat
				C2:=IntToStr(LesJoueurs[1].PliGagne)+'/'+IntToStr(LesJoueurs[1].Contrat);
			Contrat2:=gTextLoad(C2,font);
			gBeginRects(Contrat2);
				gSetCoordMode(G_CENTER);
				gSetCoord(342,73);
				gSetScaleWH(70,25);
				gSetColor(BLACK);
				gAdd();
				gEnd();
			//Points
			if (abs(LesJoueurs[1].Points)<10) then x:=30
			else x:=70;
			P2:=gTextLoad(IntToStr(LesJoueurs[1].Points),font);
			gBeginRects(P2);
				gSetCoordMode(G_CENTER);
				gSetCoord(342,120);
				gSetScaleWH(x,35);
				gSetColor(BLACK);
				gAdd();
				gEnd();
		End;
	if (length(LesJoueurs)>2) then 
		Begin
			//Prenom
			J3:=gTextLoad(LesJoueurs[2].Prenom,font);
			gBeginRects(J3);
				gSetCoordMode(G_CENTER);
				gSetCoord(429,33);
				gSetScaleWH(70,25);
				gSetColor(BLACK);
				gAdd();
				gEnd();
			//Contrat
				C3:=IntToStr(LesJoueurs[2].PliGagne)+'/'+IntToStr(LesJoueurs[2].Contrat);
			Contrat3:=gTextLoad(C3,font);
			gBeginRects(Contrat3);
				gSetCoordMode(G_CENTER);
				gSetCoord(429,73);
				gSetScaleWH(70,25);
				gSetColor(BLACK);
				gAdd();
				gEnd();
			//Points
			if (abs(LesJoueurs[2].Points)<10) then x:=30
			else x:=70;
			P3:=gTextLoad(IntToStr(LesJoueurs[2].Points),font);
			gBeginRects(P3);
				gSetCoordMode(G_CENTER);
				gSetCoord(429,120);
				gSetScaleWH(x,35);
				gSetColor(BLACK);
				gAdd();
				gEnd();
		End;
	if (length(LesJoueurs)>3) then 
		Begin
			//Prenom
			J4:=gTextLoad(LesJoueurs[3].Prenom,font);
			gBeginRects(J4);
				gSetCoordMode(G_CENTER);
				gSetCoord(521,33);
				gSetScaleWH(70,25);
				gSetColor(BLACK);
				gAdd();
				gEnd();
			//Contrat
				C4:=IntToStr(LesJoueurs[3].PliGagne)+'/'+IntToStr(LesJoueurs[3].Contrat);
			Contrat4:=gTextLoad(C4,font);
			gBeginRects(Contrat4);
				gSetCoordMode(G_CENTER);
				gSetCoord(521,73);
				gSetScaleWH(70,25);
				gSetColor(BLACK);
				gAdd();
				gEnd();
			//Points
			if (abs(LesJoueurs[3].Points)<10) then x:=30
			else x:=70;
			P4:=gTextLoad(IntToStr(LesJoueurs[3].Points),font);
			gBeginRects(P4);
				gSetCoordMode(G_CENTER);
				gSetCoord(521,120);
				gSetScaleWH(x,35);
				gSetColor(BLACK);
				gAdd();
				gEnd();
		End;
	if (length(LesJoueurs)>4) then 
		Begin
			//Prenom
			J5:=gTextLoad(LesJoueurs[4].Prenom,font);
			gBeginRects(J5);
				gSetCoordMode(G_CENTER);
				gSetCoord(613,33);
				gSetScaleWH(70,25);
				gSetColor(BLACK);
				gAdd();
				gEnd();
			//Contrat
				C5:=IntToStr(LesJoueurs[4].PliGagne)+'/'+IntToStr(LesJoueurs[4].Contrat);
			Contrat5:=gTextLoad(C5,font);
			gBeginRects(Contrat5);
				gSetCoordMode(G_CENTER);
				gSetCoord(613,73);
				gSetScaleWH(70,25);
				gSetColor(BLACK);
				gAdd();
				gEnd();
			//Points
			if (abs(LesJoueurs[4].Points)<10) then x:=30
			else x:=70;
			P5:=gTextLoad(IntToStr(LesJoueurs[4].Points),font);
			gBeginRects(P5);
				gSetCoordMode(G_CENTER);
				gSetCoord(613,120);
				gSetScaleWH(x,35);
				gSetColor(BLACK);
				gAdd();
				gEnd();
		End;
	{Chargement obligatoire de toutes les cartes}	
	gBeginRects(m1);
	gBlit(140,375,m1,55,75);//1
	gBeginRects(m2);
	gBlit(195,375,m2,55,75);//2
	gBeginRects(m3);
	gBlit(250,375,m3,55,75);//3
	gBeginRects(m4);
	gBlit(305,375,m4,55,75);//4
	gBeginRects(m5);
	gBlit(360,375,m5,55,75);//5
	gBeginRects(m6);
	gBlit(415,375,m6,55,75);//6
	gBeginRects(m7);
	gBlit(470,375,m7,55,75);//7
	gBeginRects(m8);
	gBlit(525,375,m8,55,75);//8
	gBeginRects(m9);
	gBlit(580,375,m9,55,75);//9
	gBeginRects(m10);
	gBlit(140,450,m10,55,75);//10
	gBeginRects(m11);
	gBlit(195,450,m11,55,75);//11
	gBeginRects(m12);
	gBlit(250,450,m12,55,75);//12
	gBeginRects(m13);
	gBlit(305,450,m13,55,75);//13
	gBeginRects(m14);
	gBlit(360,450,m14,55,75);//14
	gBeginRects(m15);
	gBlit(415,450,m15,55,75);//15
	gBeginRects(m16);
	gBlit(470,450,m16,55,75);//16
	gBeginRects(m17);
	gBlit(525,450,m17,55,75);//17
	gBeginRects(m18);
	gBlit(580,450,m18,55,75);//18
	gBeginRects(m19);
	gBlit(160,525,m19,55,75);//19
	gBeginRects(m20);
	gBlit(215,525,m20,55,75);//20
	gBeginRects(m21);
	gBlit(270,525,m21,55,75);//21
	gBeginRects(m22);
	gBlit(325,525,m22,55,75);//22
	gBeginRects(m23);
	gBlit(380,525,m23,55,75);//23
	gBeginRects(m24);
	gBlit(435,525,m24,55,75);//24
	gBeginRects(m25);
	gBlit(490,525,m25,55,75);//25
	gBeginRects(m26);
	gBlit(545,525,m26,55,75);//26
	
	 {Coordonnées des cartes du milieu de table}
	gBeginRects(Atout);	//			PLACE DE L atout
	gBlit(25,222,Atout,85,120);	
	gBeginRects(place1);	//			PLACE DE la carte du joueur 1
	gBlit(225,222,place1,73,110);	
	gBeginRects(place2);	//			PLACE DE la carte du joueur 2
	gBlit(310,222,place2,73,110);	
	gBeginRects(place3);	//			PLACE DE la carte du joueur 3
	gBlit(400,222,place3,73,110);	
	gBeginRects(place4);	//			PLACE DE la carte du joueur 4
	gBlit(485,222,place4,73,110);	
	gBeginRects(place5);	//			PLACE DE la carte du joueur 5
	gBlit(575,222,place5,73,110);

	gAdd;
	gEnd;
		
	gBeginRects(TheName);	//NUMERO DU J
		gSetCoordMode(G_CENTER);
        gSetCoord(400,175);
        gSetScaleWH(180,90);
        gSetColor(BLACK);
        gAdd();
		gEnd(); 
	gFlip;

while true do 
	Begin	
	{---Jouer une carte---}
	//writeln((sdl_get_mouse_x-140) div 55);
	if (sdl_mouse_left_down) then 
		Begin
		if ((sdl_get_mouse_y>374) and (sdl_get_mouse_y<450)) then 
			Begin
			case ((sdl_get_mouse_x-140) div 55) of 
				0:renvoi:=1;
				1:renvoi:=2;
				2:renvoi:=3;
				3:renvoi:=4;
				4:renvoi:=5;
				5:renvoi:=6;
				6:renvoi:=7;
				7:renvoi:=8;
				8:renvoi:=9;
				End;
			End
		else 
			Begin
			if ((sdl_get_mouse_y>449) and (sdl_get_mouse_y<525)) then 
				Begin
				case ((sdl_get_mouse_x-140) div 55) of 
				0:renvoi:=10;
				1:renvoi:=11;
				2:renvoi:=12;
				3:renvoi:=13;
				4:renvoi:=14;
				5:renvoi:=15;
				6:renvoi:=16;
				7:renvoi:=17;
				8:renvoi:=18;
				End;
				End
			else
				Begin
				if ((sdl_get_mouse_y>524) and (sdl_get_mouse_y<600)) then
					Begin
					case ((sdl_get_mouse_x-160) div 55) of 
					0:renvoi:=19;
					1:renvoi:=20;
					2:renvoi:=21;
					3:renvoi:=22;
					4:renvoi:=23;
					5:renvoi:=24;
					6:renvoi:=25;
					7:renvoi:=26;
					End;
					End;
				End;
			End;
		End;	
	{---Obligatoire pour quitter---}
	WHILE (sdl_update = 1) DO
	Begin
	if (renvoi<longueur(Tete)+1) then exit(renvoi);
	IF sdl_do_quit THEN exit(1);
	End;
	End;
End;

(*************************************************6eme FENETRE PLII *****************************************************************)
function Pli(PlisRestant:integer;LesJoueur:TabJoueur;JoueurActuel:integer;ATOUT1:string):integer;
var BLACK: gColor = (r : 0;   g : 0;   b : 0;   a : 255);   
	Sortie,i:integer;
	fond,ATOUT: gImage;	
	NumeroPlis:string; //plis restants	
	NumPlis,PSEUDO: gImage; //Nom en haut + plis restants
	m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12,m13,m14,m15,m16,m17,m18,m19,m20,m21,m22,m23,m24,m25,m26:gImage;
	NomBilan1, NomBilan2, NomBilan3 : gImage;
	CBilan1,CBilan2,CBilan3,a : string;
	ContratBilan1, ContratBilan2, ContratBilan3 : gImage;	
	font : PTTF_Font; //police		
begin
m1:=gTexLoad('./carte/back.png');
m2:=gTexLoad('./carte/back.png');
m3:=gTexLoad('./carte/back.png');
m4:=gTexLoad('./carte/back.png');
m5:=gTexLoad('./carte/back.png');
m6:=gTexLoad('./carte/back.png');
m7:=gTexLoad('./carte/back.png');
m8:=gTexLoad('./carte/back.png');
m9:=gTexLoad('./carte/back.png');
m10:=gTexLoad('./carte/back.png');
m11:=gTexLoad('./carte/back.png');
m12:=gTexLoad('./carte/back.png');
m13:=gTexLoad('./carte/back.png');
m14:=gTexLoad('./carte/back.png');
m15:=gTexLoad('./carte/back.png');
m16:=gTexLoad('./carte/back.png');
m17:=gTexLoad('./carte/back.png');
m18:=gTexLoad('./carte/back.png');
m19:=gTexLoad('./carte/back.png');
m20:=gTexLoad('./carte/back.png');
m21:=gTexLoad('./carte/back.png');
m22:=gTexLoad('./carte/back.png');
m23:=gTexLoad('./carte/back.png');
m24:=gTexLoad('./carte/back.png');
m25:=gTexLoad('./carte/back.png');
m26:=gTexLoad('./carte/back.png');
fond:=gTexLoad('./carte/PLI.png');//ecran DU JEU
if (ATOUT1='') then ATOUT:=gTexLoad('./carte/back.png')
else ATOUT:=gTexLoad(CardToImg(ATOUT1));

for i:=1 to longueur(LesJoueur[JoueurActuel].Cartes) do 
	Begin
	case i of 
		1:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m1:=gTexLoad(a); End;
		2:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m2:=gTexLoad(a); End;
		3:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m3:=gTexLoad(a); End;
		4:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m4:=gTexLoad(a); End;
		5:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m5:=gTexLoad(a); End;
		6:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m6:=gTexLoad(a); End;
		7:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m7:=gTexLoad(a); End;
		8:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m8:=gTexLoad(a); End;
		9:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m9:=gTexLoad(a); End;
		10:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m10:=gTexLoad(a); End;
		11:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m11:=gTexLoad(a); End;
		12:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m12:=gTexLoad(a); End;
		13:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m13:=gTexLoad(a); End;
		14:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m14:=gTexLoad(a); End;
		15:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m15:=gTexLoad(a); End;
		16:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m16:=gTexLoad(a); End;
		17:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m17:=gTexLoad(a); End;
		18:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m18:=gTexLoad(a); End;
		19:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m19:=gTexLoad(a); End;
		20:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m20:=gTexLoad(a); End;
		21:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m21:=gTexLoad(a); End;
		22:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m22:=gTexLoad(a); End;
		23:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m23:=gTexLoad(a); End;
		24:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m24:=gTexLoad(a); End;
		25:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m25:=gTexLoad(a); End;
		26:begin a:=CardToImg(NemeNoeud(LesJoueur[JoueurActuel].Cartes,i)); m26:=gTexLoad(a); End;
		else writeln('Pas possible function jouerunecertainecarte');
	End;
End;
 
font := TTF_OpenFont('fixedsys.ttf', 45);

NumeroPlis:= inttostr(PlisRestant);    
NumPlis := gTextLoad(NumeroPlis, font);    //Textbox pour le numero des plis restant
PSEUDO := gTextLoad(LesJoueur[JoueurActuel].Prenom, font);  //Textbox ou le joueur ecris son nom     

NomBilan1 := gTextLoad(LesJoueur[0].Prenom, font);  //Textbox ou il y a le nom du joueur 1 dans le bilan     
NomBilan2 := gTextLoad(LesJoueur[1].Prenom, font);  //Textbox ou il y a le nom du joueur 2 dans le bilan  
if (length(LesJoueur)>2) then NomBilan3 := gTextLoad(LesJoueur[2].Prenom, font)  //Textbox ou il y a le nom du joueur 3 dans le bilan 
else NomBilan3 := gTextLoad(' ', font);

if (LesJoueur[0].Contrat=-1) then CBilan1:='N/A'
else CBilan1:= inttostr(LesJoueur[0].Contrat);    //on convertit le Contrat du joueur 1 en string
if (LesJoueur[1].Contrat=-1) then CBilan2:='N/A'
else CBilan2:= inttostr(LesJoueur[1].Contrat);    //on convertit le Contrat du joueur 2 en string

if (length(LesJoueur)>2) then CBilan3:= inttostr(LesJoueur[2].Contrat)  //on convertit le Contrat du joueur 3 en string
else CBilan3:=' ';
if (CBilan3='-1') then CBilan3:='N/A';
ContratBilan1 := gTextLoad(CBilan1, font);  //Textbox ou il y a le Contrat du joueur 1 dans le bilan     
ContratBilan2 := gTextLoad(CBilan2, font);  //Textbox ou il y a le Contrat du joueur 2 dans le bilan     
ContratBilan3 := gTextLoad(CBilan3, font);  //Textbox ou il y a le Contrat du joueur 3 dans le bilan     
 
	gClear(BLACK);
	gBeginRects(fond);
	gBlit(0,0,fond,800,600);
	gBeginRects(ATOUT);	//			PLACE DE L atout
	gBlit(435,170,ATOUT,65,80);
	gBeginRects(m1);	//			Place de la main du joueur possible 27 cartes au max
	gBlit(245,262,m1,55,75);
	gBeginRects(m2);	//			1
	gBlit(265,262,m2,55,75);
	gBeginRects(m3);	//			2
	gBlit(285,262,m3,55,75);
	gBeginRects(m4);	//			3
	gBlit(305,262,m4,55,75);
	gBeginRects(m5);	//			4 
	gBlit(325,262,m5,55,75);
	gBeginRects(m6);	//			5 
	gBlit(345,262,m6,55,75);
	gBeginRects(m7);	//			6
	gBlit(365,262,m7,55,75);
	gBeginRects(m8);	//			7
	gBlit(385,262,m8,55,75);
	gBeginRects(m9);	//			8
	gBlit(405,262,m9,55,75);
	gBeginRects(m10);	//			9
	gBlit(425,262,m10,55,75);
	gBeginRects(m11);	//			10
	gBlit(445,262,m11,55,75);
	gBeginRects(m12);	//			11
	gBlit(465,262,m12,55,75);
	gBeginRects(m13);	//			12
	gBlit(485,262,m13,55,75);
	gBeginRects(m14);	//			13
	gBlit(505,262,m14,55,75);
	gBeginRects(m15);	//			14
	gBlit(525,262,m15,55,75);
	gBeginRects(m16);	//			15
	gBlit(265,337,m16,55,75);
	gBeginRects(m17);	//			16
	gBlit(285,337,m17,55,75);
	gBeginRects(m18);	//			17
	gBlit(305,337,m18,55,75);
	gBeginRects(m19);	//			18
	gBlit(325,337,m19,55,75);
	gBeginRects(m20);	//			19
	gBlit(345,337,m20,55,75);
	gBeginRects(m21);	//			20
	gBlit(365,337,m21,55,75);
	gBeginRects(m22);	//			21
	gBlit(385,337,m22,55,75);
	gBeginRects(m23);	//			22
	gBlit(405,337,m23,55,75);
	gBeginRects(m24);	//			23
	gBlit(425,337,m24,55,75);
	gBeginRects(m25);	//			24
	gBlit(445,337,m25,55,75);
	gBeginRects(m26);	//			25
	gBlit(465,337,m26,55,75);
	
	
	// on affiche le nom du joueur pour savoir qui joue	        
        gBeginRects(PSEUDO);//PSEUDO
        gSetCoordMode(G_CENTER);
        gSetCoord(400,145);
        gSetColor(BLACK);
        gAdd();
		gEnd(); 
		
	// on affiche le nombre de PLIS RESTANT
	    gBeginRects(NumPlis);	//NUMERO DU plis restant dans le tab a gauche
		gSetCoordMode(G_CENTER);
        gSetCoord(100,320);
        gSetScaleWH(70,120);
        gSetColor(BLACK);
        gAdd();
		gEnd();  
		
	// on affiche le nom des joueur qui ont deja fais un plis 							BILAN PLIS	
        gBeginRects(NomBilan1);//Nom  Bilan1
        gSetCoordMode(G_CENTER);
        gSetCoord(680,270);
        gSetScaleWH(100,40);
        gSetColor(BLACK);
        gAdd();
		gEnd();
		
        gBeginRects(NomBilan2);//Nom  Bilan2
        gSetCoordMode(G_CENTER);
        gSetCoord(680,330);
		gSetScaleWH(100,40);
        gSetColor(BLACK);
        gAdd();
		gEnd(); 
		
        gBeginRects(NomBilan3);//Nom  Bilan3
        gSetCoordMode(G_CENTER);
        gSetCoord(680,385);
        gSetScaleWH(100,40);
        gSetColor(BLACK);
        gAdd();
		gEnd();
		
	// on affiche le CONTRAT des joueur qui ont deja fais un plis 								BILAN PLIS	
        gBeginRects(ContratBilan1);//CONTRAT  Bilan1
        gSetCoordMode(G_CENTER);
        gSetCoord(770,270);
		gSetScaleWH(30,40);
        gSetColor(BLACK);
        gAdd();
		gEnd();
		
        gBeginRects(ContratBilan2);//CONTRAT  Bilan2
        gSetCoordMode(G_CENTER);
        gSetCoord(770,330);
        gSetScaleWH(30,40);
        gSetColor(BLACK);
        gAdd();
		gEnd(); 
		
        gBeginRects(ContratBilan3);//CONTRAT  Bilan3
        gSetCoordMode(G_CENTER);
        gSetCoord(770,385);
        gSetScaleWH(30,40);
        gSetColor(BLACK);
        gAdd();
		gEnd();  
	gFlip();
WHILE true DO BEGIN		
	// on s'occupe du choix du joueur
	Sortie:=PlisRestant+1;				
	if (sdl_mouse_left_down) then 
	Begin
		if ((sdl_get_mouse_y>425) and (sdl_get_mouse_y<460)) then 
			Begin
				case ((sdl_get_mouse_x-135) div 55) of 
				0:Sortie:=0;
				1:Sortie:=1;
				2:Sortie:=2;
				3:Sortie:=3;
				4:Sortie:=4;
				5:Sortie:=5;
				6:Sortie:=6;
				7:Sortie:=7;
				8:Sortie:=8;
				9:Sortie:=9;				
			End;
			End
			else 
			Begin
			if ((sdl_get_mouse_y>475) and (sdl_get_mouse_y<510)) then 
				Begin
				case ((sdl_get_mouse_x-135) div 55) of 
				0:Sortie:=10;
				1:Sortie:=11;
				2:Sortie:=12;
				3:Sortie:=13;
				4:Sortie:=14;
				5:Sortie:=15;
				6:Sortie:=16;
				7:Sortie:=17;
				8:Sortie:=18;
				9:Sortie:=19;
				End;
			end
		else
			Begin
			if ((sdl_get_mouse_y>525) and (sdl_get_mouse_y<560)) then
				Begin
				case ((sdl_get_mouse_x-190) div 55) of 
				0:Sortie:=20;
				1:Sortie:=21;
				2:Sortie:=22;
				3:Sortie:=23;
				4:Sortie:=24;
				5:Sortie:=25;
				6:Sortie:=26;
				7:Sortie:=27;
				End;
			end;
		End;
	End;
End;	
	{---Obligatoire pour quitter---}
	WHILE (sdl_update = 1) DO
	Begin
	if (Sortie<PlisRestant+1) then exit(Sortie);
	IF sdl_do_quit THEN exit(1);
End;
End;
end;
(*************************************************FENETRE REMPORTE PLII *****************************************************************)
	procedure RemportDePli(nom:string);
	var BLACK: gColor = (r : 0;   g : 0;   b : 0;   a : 255);
		fond,pseudo: gImage;
	font : PTTF_Font; //police
	i:integer;
	begin
	
	fond:=gTexLoad('./carte/victoire.png');//ecran partie en cours
	font := TTF_OpenFont('fixedsys.ttf', 45);
	pseudo:=gTextLoad(nom,font);
	i:=0;
	WHILE true DO BEGIN
		gClear(BLACK);
		gBeginRects(fond);
		gBlit(0,0,fond,800,600);
	gBeginRects(pseudo);//PSEUDO
        gSetCoordMode(G_UP_RIGHT);
        gSetCoord(340,263);
        gSetScaleWH(160,80);
        gSetColor(BLACK);
        gAdd();
		gEnd(); 
		gFlip;
		if (i>0) then inc(i);
		if (i>10) then exit;
	WHILE (sdl_update = 1) DO
	if sdl_mouse_left_down then inc(i);
	IF sdl_do_quit THEN exit;
	END;
	end;

END.
