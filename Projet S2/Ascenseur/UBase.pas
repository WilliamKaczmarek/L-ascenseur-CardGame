unit UBase;

interface
	uses sysutils;
	const Couleurs = 'CDHS';
	//C -> Clubs = Trefle
	//D -> Diamonds = Carreau
	//H -> Hearts = Coeur
	//S -> Spades = Pique
	type 
		Statut = (Humain,IA); //Sera utilise pour la deuxieme partie avec une Intelligence Artificielle
		Tabdyn = array of integer; //Basique
		TabdynV2 = array of string; //Basique aussi
		Card = record
			distribution : (Restante,Distribuee);
			Valeurrr : string;
		End;
		PaquetDeCarte = array of Card;
		Ptr_Noeud = ^Noeud;
		Joueur = record  //Il y aura autant de cette variable que de joueur (IA et Humain)
			Prenom : string; //Permet d'identifier les joueurs
			Cartes : Ptr_Noeud; //Liste representant les differentes cartes en main du joueur
			Points : integer; //Points total du joueur
			Contrat : integer; //Ici faut initialiser a -1 /!\ IMPORTANT //Nombre de pli que le joueur a prevu de gagner
			PliGagne : integer; //Nombre de pli que le joueur gagne durant la manche actuelle
			Player : Statut; //Humain ou IA
		End;
		TabJoueur = array of Joueur;
		Noeud = record //On utilisera une liste pour les cartes de chaque joueur
			valeur : string; 
			suivant : ^Noeud; //Permet la liaison avec les autres cartes ainsi la tete est importante
		End;
			TabChargCarte = array [0..51] of string; 
	
Const TabVariable:TabChargCarte=('C1',
							   'C2',
							   'C3',
							   'C4',
							   'C5',
							   'C6',
							   'C7',
							   'C8',
							   'C9',
							   'C10',
							   'C11',
							   'C12',
							   'C13',
							   'D1',
							   'D2',
							   'D3',
							   'D4',
							   'D5',
							   'D6',
							   'D7',
							   'D8',
							   'D9',
							   'D10',
							   'D11',
							   'D12',
							   'D13',
							   'H1',
							   'H2',
							   'H3',
							   'H4',
							   'H5',
							   'H6',
							   'H7',
							   'H8',
							   'H9',
							   'H10',
							   'H11',
							   'H12',
							   'H13',
							   'S1',
							   'S2',
							   'S3',
							   'S4',
							   'S5',
							   'S6',
							   'S7',
							   'S8',
							   'S9',
							   'S10',
							   'S11',
							   'S12',
							   'S13'
							   );

Const TabFile:TabChargCarte=('./carte/1-1.png',
							   './carte/1-2.png',
							   './carte/1-3.png',
							   './carte/1-4.png',
							   './carte/1-5.png',
							   './carte/1-6.png',
							   './carte/1-7.png',
							   './carte/1-8.png',
							   './carte/1-9.png',
							   './carte/1-10.png',
							   './carte/1-11.png',
							   './carte/1-12.png',
							   './carte/1-13.png',
							   './carte/4-1.png',
							   './carte/4-2.png',
							   './carte/4-3.png',
							   './carte/4-4.png',
							   './carte/4-5.png',
							   './carte/4-6.png',
							   './carte/4-7.png',
							   './carte/4-8.png',
							   './carte/4-9.png',
							   './carte/4-10.png',
							   './carte/4-11.png',
							   './carte/4-12.png',
							   './carte/4-13.png',
							   './carte/3-1.png',
							   './carte/3-2.png',
							   './carte/3-3.png',
							   './carte/3-4.png',
							   './carte/3-5.png',
							   './carte/3-6.png',
							   './carte/3-7.png',
							   './carte/3-8.png',
							   './carte/3-9.png',
							   './carte/3-10.png',
							   './carte/3-11.png',
							   './carte/3-12.png',
							   './carte/3-13.png',
							   './carte/2-1.png',
							   './carte/2-2.png',
							   './carte/2-3.png',
							   './carte/2-4.png',
							   './carte/2-5.png',
							   './carte/2-6.png',
							   './carte/2-7.png',
							   './carte/2-8.png',
							   './carte/2-9.png',
							   './carte/2-10.png',
							   './carte/2-11.png',
							   './carte/2-12.png',
							   './carte/2-13.png'
							   );
		
		function CreationTableauCarte():PaquetDeCarte;//TJ
		procedure InfoJoueurs(LesJoueur : TabJoueur);//TJ
		Function IdPrenom(LesJoueurs:TabJoueur;Prenom:string):integer;//TJ
		function CardToImg(Carte:string):string;//TJ
	implementation 
	
	
		(*==============================================================================    
		* Procedure modele qui creer un tableau avec les 52 cartes du jeu en les 
		* nommant et definissant s'il sont dans le packet ou s'ils sont distribuees a des
		* joueurs 
		* Ici je fais 13 cartes pour Trefle,Carreau,Coeur et Pique
		* (pos(c,Couleurs)*13+i) mod 52 est une operation qui permet de ranger les cartes
		* selon leur couleur
		* Particularite : 
		* - H13 (Roi de Coeur) correspond a la case 0 car c'est la carte 52 mod 52 donc 
		* ca revient a 0
		* -"for c in Couleurs" signifie : pour chaque lettre dans la constante couleurs
		* -on est obliger d'utiliser l'operation precedente afin d'optimiser le nombre de ligne
		* mais ca reviendrait a faire une boucle de 0 a 51 avec des conditions pour definir
		* la couleur de la carte et la valeur serai (i mod 12 + 1) ou un truc du genre
		* 
		===============================================================================*)
		function CreationTableauCarte():PaquetDeCarte;
		var 
		i : integer;
		c : char;
		Begin
		setlength(CreationTableauCarte,52);
		for c in Couleurs do
			Begin
			for i:=1 to 13 do 
				Begin
				CreationTableauCarte[(pos(c,Couleurs)*13+i) mod 52].distribution:=Distribuee;
				CreationTableauCarte[(pos(c,Couleurs)*13+i) mod 52].valeurrr:=c+inttostr(i);
				//Affichage des cartes
				writeln(CreationTableauCarte[(pos(c,Couleurs)*13+i) mod 52].valeurrr,' : ',CreationTableauCarte[(pos(c,Couleurs)*13+i) mod 52].distribution, ' Case ',(pos(c,Couleurs)*13+i) mod 52);
				End;
			End;
		End;
		
		
		
		(*==============================================================================    
		* Simple procedure qui affiche toutes les informations sur tout les joueurs
		===============================================================================*)
		procedure InfoJoueurs(LesJoueur : TabJoueur);
		var 
		i:integer;
		Begin
		for i:=0 to high(LesJoueur) do 
			Begin
			writeln('----Joueur ',i+1,'----');
			writeln('Prénom : ',LesJoueur[i].Prenom);
			writeln('Points : ',LesJoueur[i].Points);
			writeln('Contrat : ',LesJoueur[i].Contrat);
			writeln('Pli gagnés : ',LesJoueur[i].PliGagne);
			writeln('Statut : ',LesJoueur[i].Player);
			End;
		End;
		
		(*==============================================================================    
		* Faudrait faire des fonctions qui permettent de gerer les cartes (grace aux noeuds) 
		* plus facilement, pour ce cas on se ficher de l'ordre des listes dans la liste chainee
		* Genre fonction affichage des cartes, ajouter une carte, creer une liste chainee
		* pour un joueur lorsqu'il pioche, supprimer une carte lorsqu'il la pose
		* faire un algorithme qui melange les cartes
		* Remplir le fichier des parametres de la partie si il est vide sinon, il faut pouvoir
		* le reutiliser pour parametrer la partie
		* NE PAS OUBLIER DE DESALLOUER LES TABDYN 
		===============================================================================*)
		Function IdPrenom(LesJoueurs:TabJoueur;Prenom:string):integer;
		var 
		i:integer;
		Begin
		IdPrenom:=0;
		for i:=0 to high(LesJoueurs) do
			if (Prenom=LesJoueurs[i].Prenom) then exit(i);
		End;
		
		
		function CardToImg(Carte:string):string;
		var 
		i:integer;
		Begin
		for i:=0 to 51 do 
			Begin
			if (TabVariable[i]=Carte) then exit(TabFile[i]);
			End;
		End;
End.
