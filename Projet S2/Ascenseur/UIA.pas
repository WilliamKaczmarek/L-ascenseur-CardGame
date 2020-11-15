unit UIA;
//Base de la base on estime que le statut IA correspond au random

interface
	uses sysutils,UBase,crt,UCarte;
	

	Function NiveauDifficilePli(Paquet:PaquetDeCarte;Tete:Ptr_Noeud;MancheMaximum:boolean;PliRestant:integer):integer;
	Function Generalisation(LesJoueurs:TabJoueur;PliRestant,Joueur:integer;Pli:string;Paquet:PaquetDeCarte;MancheMaximum:boolean):integer;

Implementation
	
	Function NiveauDifficilePli(Paquet:PaquetDeCarte;Tete:Ptr_Noeud;MancheMaximum:boolean;PliRestant:integer):integer; //Tete= cartes du joueurs
	var
	i:integer;
	point:Ptr_Noeud;
	Carte:string;
	Begin
	NiveauDifficilePli:=0;
	Point:=Tete;
	if (not MancheMaximum) then
		Begin
		for i:=1 to longueur(Tete) do 
			Begin
			Carte:=Point^.valeur;
			if (Carte[1]=Paquet[51].Valeurrr[1]) then NiveauDifficilePli:=NiveauDifficilePli+1
			else 
				Begin
				if ((Carte[2]='1') and ((length(Carte)=2) or (Carte[3]<>'0'))) then NiveauDifficilePli:=NiveauDifficilePli+1;
				End;
			Point:=Point^.suivant;
			End;
		End
	else
		Begin
		if ((Carte[2]='1') and ((length(Carte)=2) or (Carte[3]<>'0'))) then NiveauDifficilePli:=NiveauDifficilePli+1;
		End;
		if (NiveauDifficilePli>PliRestant) then NiveauDifficilePli:=PliRestant;
	End;


	Function Generalisation(LesJoueurs:TabJoueur;PliRestant,Joueur:integer;Pli:string;Paquet:PaquetDeCarte;MancheMaximum:boolean):integer; //La variable Pli est 'Pli' pour la prevision de pli et 'Carte' pour la carte a jouer
	Begin
	
	if (LesJoueurs[Joueur].Player=IA) then //CAS RANDOM
		Begin
		if (Pli='Pli') then exit(NiveauDifficilePli(Paquet,LesJoueurs[Joueur].Cartes,MancheMaximum,PliRestant))//exit(random(PliRestant+1))
		else exit(random(longueur(LesJoueurs[Joueur].Cartes))+1);
		End;

	End;



End.
