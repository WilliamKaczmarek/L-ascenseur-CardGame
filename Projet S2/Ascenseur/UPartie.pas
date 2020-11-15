unit UPartie;
{$mode objfpc}
interface
	uses sysutils,UBase,crt,UCarte,UIA,Ugraph;



	procedure AffichageTableauPrevision(LesJoueurs:TabJoueur;Manche:integer;var acc:integer);//TJ
	procedure PrevisionPli(var LesJoueurs:TabJoueur;Manche:integer;atout:string;Paquet:PaquetDeCarte;MancheMaximum:boolean);//TJ
	Procedure DefineParam();//TJ
	Procedure InitialisationPartie(var LesJoueurs : TabJoueur);//TJ
	Procedure CreationPartie(var LesJoueurs : TabJoueur);//TJ
	function QueLeMeilleurGagne(Tab:TabdynV2;atout:boolean):integer;//TJ
	Function PremierAJouer(LesJoueurs:TabJoueur;n:integer):TabJoueur;//TJ
	Procedure MancheParManche(NumManche:integer;MaxManche:boolean;var LesJoueurs:TabJoueur);//TJ
	function JoueurPlusUn(LesJoueurs:TabJoueur;first:string;acc:integer):TabJoueur;//TJ
	Procedure LancementPartie(var LesJoueurs:TabJoueur);//TJ
	
implementation

	(*==============================================================================    
		* -Procedure auxilliaire de PrevisionPli(), qui va permettre de gerer l'affichage
		* en temps réel des contrats et qui va calculer le nombre actuel de contrat en total
		* -Utile afin que la somme de tout les contrats fassent le nombre de la manche+1
		*-lorsque le contrat n'est pas encore effectue ou alors s'il a ete fait dans de 
		* mauvaise condition, sa valeur est -1
		===============================================================================*)
	procedure AffichageTableauPrevision(LesJoueurs:TabJoueur;Manche:integer;var acc:integer); //Affiche 
	var 
	i:integer;
	Begin
	clrscr; //Affichage plus clair
	acc:=0;	//Accumulateur du nombre de contrat acutelle initialise a 0
	writeln('Tableau des plis gagnant pariés par les joueurs');
	writeln('Il faut un total de : ',Manche+1,' plis gagnant');
	for i:=0 to high(LesJoueurs) do //Ici on calcul le nombre de contrat qu'il y a actuellement
		Begin
		if ((LesJoueurs[i].contrat<>-1) and (LesJoueurs[i].Contrat<=Manche+1-acc)) then acc:=acc+LesJoueurs[i].Contrat; //Peut etre on peut enlever le 'and' et ce qu'il y a apres (a voir)
		End;	
	writeln(Manche+1-acc,' plis à miser restant(s) '); //Information pour celui qui va donner le nombre de son contrat
	writeln;
	for i:=0 to high(LesJoueurs) do //Affichage des contrat jusqu'au contrat pas encore fait
		Begin
		if (LesJoueurs[i].Contrat = -1) then Break; //Si le contrat n'est pas encore fait, on arrete la boucle
		writeln(LesJoueurs[i].Prenom,' : ',LesJoueurs[i].Contrat); //Sinon on affiche le contrat effectue par le joueur i
		End;	
	End;
 
 
 
	
	(*==============================================================================    
		* -Procedure qui va prendre en compte le contrat de tout les joueurs dans l'ordre
		* du tableau des joueurs de 0 a high(Tableau des Joueurs)
		* -On met -1 lorsque le contrat n'est pas valide
		* -Tant que le contrat vaut -1, on continu de demander un contrat
		* -Fini par afficher un bilan avec tout les contrats qui ont ete fait
		===============================================================================*)
		
	procedure PrevisionPli(var LesJoueurs:TabJoueur;Manche:integer;atout:string;Paquet:PaquetDeCarte;MancheMaximum:boolean); //A utiliser lorsque l'on veut creer les contrats
	var 
	i,acc:integer;
	Begin
	acc:=0;//Inutile mais permet la compilation sans warning
	for i:=0 to high(LesJoueurs)-1 do //Ici on prend le contrat de chaque joueur sauf le dernier qui sera pris automatiquement
		Begin
		LesJoueurs[i].Contrat:=-1; //Initialisation du contrat du joueur a -1
		while (LesJoueurs[i].Contrat=-1) do	//Tant que le contrat n'est pas fait/valide, on le demande
			Begin
			AffichageTableauPrevision(LesJoueurs,Manche,acc);//Procedure auxilliaire
			if (Atout='') then writeln('Pas d''atout pour cette manche.')
			else writeln('Atout : ',ValeurToCarte(atout));
			Affichage(LesJoueurs[i].Cartes);
			write('Votre contrat (',LesJoueurs[i].Prenom,') : ');//Pour la saisie du contrat
			
			
			
			
			if (LesJoueurs[i].Player=Humain) then LesJoueurs[i].Contrat:=Pli(Manche+1-acc,LesJoueurs,i,atout)//readln(LesJoueurs[i].Contrat)
			
			
			
			
			
			
			else LesJoueurs[i].Contrat:=Generalisation(LesJoueurs,Manche+1-acc,i,'Pli',Paquet,MancheMaximum); // ICI ON INJECTE LA FONCTION DE L'IA POUR PREVISION DES PLIS
			if ((LesJoueurs[i].Contrat>Manche+1-acc) or (LesJoueurs[i].Contrat<0)) then LesJoueurs[i].Contrat:=-1; //Lorsque le contrat rend la somme > a manche+1 ou est negatif
			End;
			AffichageTableauPrevision(LesJoueurs,Manche,acc);//Permet la mise a jour de l'accumulateur mais inutil pour l'affichage
		End;
	LesJoueurs[high(LesJoueurs)].Contrat:=Manche+1-acc; //Prise automatique du contrat pour le dernier joueur
	clrscr; //Rend la console plus lisible
	Writeln('Bilan des contrats');
	for i:=0 to high(LesJoueurs) do //Ici on affiche le bilan des contrats (la somme doit faire manche+1)
		Begin
		writeln(LesJoueurs[i].Prenom,' : ',LesJoueurs[i].Contrat);
		End;
	End;

	(*==============================================================================    
		* -Procedure qui va creer ou modifier le fichier dans lequel les parametres sont
		* stocké
		* Le fichier va se présenter comme ça : 
		* 5 //Nombre de joueurs
		* 0 //Nombre d'IA
		* William*Alexandre*Alexander*Théo //Différents prénom avec * comme separateur
		* 
		===============================================================================*)
		
	Procedure DefineParam();
	var 
	name:string;
	i,j,k:integer;
	Fichier : TextFile;
	Begin
	writeln('--Paramètres de la partie-- ');
	{$I+}
	AssignFile(Fichier, 'ParamPartie.txt'); //On ouvre un fichier en ecriture (on ecrase ce que il y avait avant)
	rewrite(Fichier);
	//delay(300);//pour eviter de cliquer par erreur sur le nombre de joueurs
	i:=choixjoueurs();//on lance la fenetre pour le choix du nombre D IA
	Repeat
		writeln('Nombre de joueur (2 à 5 joueurs, IA comprise) : ');
	until ((i>1) and (i<6));// 1<Le nombre de joueur<6
	writeln(Fichier,i); //La premiere ligne du fichier indique le nombre de joueur
		
	j:=choixIA();//on lance la fenetre pour le choix du nombre D IA
	
	writeln(Fichier,j);//La deuxieme ligne correspond au nombre de IA
	writeln('On va maintenant rentrer les prénoms, veuillez mettre que des lettres de l''alphabet (accent compris) on est pas responsable du bon déroulement du programme si vous mettez autre chose xD');
	for k:=1 to i-j do //Ici on demande de saisir juste le nombre de joueur humain, les autres sont predefinis
		Begin
		write('Joueur ',k,' : '); 
		name:='';
		name:=NomsDesJoueurs(k);
		writeln(name);
		//readln(name); //On demander a l utilisateur de saisir le nom du joueur k
		name:=name+'*'; //On ajout * qui indiquera que le prenom du joueur est fini
		write(Fichier,name); //La troisieme ligne indique les prenoms des joueurs separee par *
		End;
	for i:=1 to j do  //On donne un prenom aux IA
		Begin
		case i of 
			1:write(Fichier,'Edison*'); //Pour IA numero 1
			2:write(Fichier,'Newton*');//Pour IA numero 2
			3:write(Fichier,'Einstein*');//Pour IA numero 3
			4:write(Fichier,'Frankenstein*');//Pour IA numero 4
			5:write(Fichier,'PasDePrenom*');//Pour IA numero 5
			else 
			writeln('Y a pas de else');
			End;
		End;
	close(Fichier);//On ferme bien le fichier
	End;
	
	
	
	
	(*==============================================================================    
		* -Procedure d'initialisation de la partie, cela va permettre de mettre en 
		* place les parametres predefini dans un fichier
		* La procedure permet essentiellement de determiner si un fichier est deja present
		* ou si on doit en creer un/le modifier
		===============================================================================*)
	Procedure InitialisationPartie(var LesJoueurs : TabJoueur);
	var 
	i:integer;
	Fichier : TextFile;
	Begin
	i:=0;
	if ((fenetremenu) and (i=0))then
		begin
			AssignFile(Fichier, 'ParamPartie.txt');
			{$I-} //On neglige les exceptions
			reset(Fichier);//ici on va juste ouvrir en lecture car on veut savoir si il existe ou pas
			{$I+} //Utilise les exceptions
			if (IOresult<>0) then //On regarde si un fichier existe,si non on renvoie l'utilisateur redefinir les parametres
				Begin
				DefineParam; //Definition des parametres par l'utilisateur
				End
			else 
				Begin //Detection de la presence d'un fichier mais pas que le contenu du fichier est legal /!\
				if fenetreparam then DefineParam; //On propose a l'utilisateur de pouvoir modifier les parametre
				End;
			Inc(i);
			CreationPartie(LesJoueurs);//Lancement de la procedure qui lit les parametre
			End;
		END;


		(*==============================================================================    
		* -Procedure d'initialisation de la partie numero 2
		* On va lire le fichier avec les parametre prealablement cree et on va 
		* creer la partie en fonction de ces parametres (en esperant que il ne sont pas 
		* corrompu)
		* PRE-REQUIS : Fichier avec les parametres
		===============================================================================*)
		
		Procedure CreationPartie(var LesJoueurs : TabJoueur);
		var 
		i,InA,NbNom:integer;
		Fichier : TextFile;
		ligne,name:string;
		Begin
		{$I-} //On neglige les exceptions
		AssignFile(Fichier, 'ParamPartie.txt');
		{$I+}
		try
			reset(Fichier); //Ouverture du fichier uniquement en mode lecture car on veut que recuperer des informations
			for i:=1 to 3 do //3 car il y a trois ligne dans le fichier 
			//A TESTER je pense qu'en enlever le 'case i of' ca devrait fonctionner pareil sans ligne en plus
				Begin
				case i of
					1:Begin
					readln(Fichier,ligne); //Premiere ligne qui est le nombre de joueur
					setlength(LesJoueurs,StrToInt(ligne));//Creation d'un tableau du nombre de joueur qui joue on transforme la chaine en entier et on met dans une variable pour reutiliser 'ligne'
					End;
					2:Begin
					readln(Fichier,ligne);//Deuxieme ligne qui est le nombre d'IA
					InA:=StrToInt(ligne);//On transforme la chaine en entier et on met dans une variable pour reutiliser 'ligne'
					End;
					3:readln(Fichier,ligne);//Derniere ligne qui contient les nom, on garde la variable
					else writeln('Y a pas de else non plus');
					End;
				End;
			NbNom:=0; //Joueur que on configure actuellement
			name:=''; //Nom qui contient rien au debut
			for i:=1 to length(ligne) do 
				Begin
				if (ligne[i]='*') then  //Des que un prenom entier est identifier on initialise le joueur
					Begin 
					LesJoueurs[NbNom].Prenom:=name;
					name:='';//On reset le nom pour qu'il prenne le nom d'apres
					LesJoueurs[NbNom].Points:=0;
					LesJoueurs[NbNom].Contrat:=-1;
					LesJoueurs[NbNom].PliGagne:=0;
					NbNom:=NbNom+1; //On augmente le numero du joueur a configurer
					End
				else name:=name+ligne[i]; //Si on a pas de * alors le nom n'est pas finit
				End;
				for i:=0 to high(LesJoueurs) do  //Ici on initialise le statut(IA ou humain) des joueur 
					Begin
					if (i<length(LesJoueurs)-InA) then LesJoueurs[i].Player:=Humain
					else  LesJoueurs[i].Player:=IA;
					End;
		except 
			on E: EInOutError do Writeln('Une erreur de manipulation de fichier s''est produite. Détails: '+E.ClassName+'/'+E.Message); //Dans le cas d'une erreur avec le fichier
			on E: EConvertError do writeln('Une erreur s''est produite lors du report des infos du fichier dans le programme. Détails:  '+E.ClassName+'/'+E.Message);//Dans le cas d'une erreur de conversion(string to integer)
		End;
		End;
	
	
	
	(*==============================================================================    
		* Fonction dont le but est de renvoyer le joueur ayant pose la meilleure carte
		* Cette fonction va donc comparer les cartes en prenant en compte la couleur,la 
		* valeur et la position du joueur (dans le cas d'une egalite) 
		* Faire un cas special dans le cas où il n'y a pas d atout car la premiere carte
		* pourra etre la meilleure
		* Pour l'instant j ai fais que lorsque le joueur joue un atout aussi 
		* il faut voir si le joueur ne joue pas d'atout et aussi si aucun joueur
		* ne joue pas d'atout alors c la premiere couleur qui est atout
		===============================================================================*)
	function QueLeMeilleurGagne(Tab:TabdynV2;atout:boolean):integer;
	var 
	i:integer;
	Best,Carte,LeAtout,Compare1,Compare2:string;
	Begin 
		LeAtout:=Tab[0];//On initialise le atout
		Best:='';//Pour le moment il n y a aucune carte meilleure que les autres
		if (LeAtout<>'') then writeln(ValeurToCarte(Tab[0])); //On indique le atout 
		if (LeAtout='') then  //Pour la manche ou il y a le plus de carte il y a pas d'atout
			Begin
			QueLeMeilleurGagne:=0; //Le premier deviens donc le meilleur joueur car la comparaison ne prend pas en compte si les cartes sont égales
			//Il ne peut pas y avoir deux cartes identiques dans le paquet
			LeAtout:=Tab[1];//L'atout devient donc la carte du premier joueur
			Best:=Tab[1]; //Et la meilleure carte est donc maintenant celle du premier joueur
			End;
		for i:=1 to high(Tab) do //On compare toutes les cartes
			Begin
			Carte:=Tab[i]; //On prend la valeur de la carte actuelle
			writeln(ValeurToCarte(Carte)); //On le marque pour verifier la fonction apres
			if (Carte[1]=LeAtout[1]) then //Dans le cas ou il y a une carte de meme couleur que l'atout, elle est susceptible de gagner
				Begin
				if (Best='') then  //Si c'est la seule carte de meme couleur que l'atout, elle gagne
					Begin
					Best:=Carte;
					QueLeMeilleurGagne:=i-1;
					if ((Best[2]='1') and (length(Best)=2)) then exit(i-1); //Le joueur qui joue un as, gagne directement)//Ici on met i-1 car le 0 correspond a l'atout donc ce sera la carte 1 qui correspond au joueur 0
					End
				else 
					Begin
					Compare1:=Best;
					Compare2:=Carte;
					Delete(Compare1,1,1);
					Delete(Compare2,1,1);
					if (StrToInt(Compare2)=1) then exit(i-1); //Le joueur qui joue un as, gagne directement)
					if (StrToInt(Compare2)>StrToInt(Compare1)) then 
						Begin
						QueLeMeilleurGagne:=i-1;//Ici on met i-1 car le 0 correspond a l'atout donc ce sera la carte 1 qui correspond au joueur 0
						Best:=Carte;
						End;
					 //Si la carte est meilleur que la precedent on la definie comme meilleure
					 //Et on indique que le meilleur joueur actuelle est le meilleur
					//Sinon on touche a rien, la carte actuellement meilleure reste la meilleure
					End;
				End;
			End;
			if (Best<>'') then exit(QueLeMeilleurGagne)//On fait gagner du temps au programme s'il y a deja un meilleur joueur
			else
				Begin
				Best:=Tab[1];
				if ((Best[2]='1') and (length(Best)=2)) then exit(0);
				for i:=2 to high(Tab) do
					Begin
					Carte:=Tab[i];
					writeln(ValeurToCarte(Carte)); 
					if (Carte[1]=Best[1]) then //Dans le cas ou il y a une carte de meme couleur que l'atout, elle est susceptible de gagner
						Begin
						Compare1:=Best;
						Compare2:=Carte;
						Delete(Compare1,1,1);
						Delete(Compare2,1,1);
						if (StrToInt(Compare2)=1) then exit(i-1); //Le joueur qui joue un as, gagne directement)
						if (StrToInt(Compare2)>StrToInt(Compare1)) then 
							Begin
							QueLeMeilleurGagne:=i-1;//Ici on met i-1 car le 0 correspond a l'atout donc ce sera la carte 1 qui correspond au joueur 0
							Best:=Carte;
							End;
						 //Si la carte est meilleur que la precedent on la definie comme meilleure
						 //Et on indique que le meilleur joueur actuelle est le meilleur
						//Sinon on touche a rien, la carte actuellement meilleure reste la meilleure
						End;
					End;
				End;	
	//readln;
	End;
		
	(*==============================================================================    
		* -NON TESTER ET NON UTILISE POUR L'INSTANT
		* Fonction qui decal le tableau pour que le n ieme joueur soit premier 
		===============================================================================*)
//MTN il faut une procedure qui creer la partie et renvoie un tableau de joueurs initialise
		Function PremierAJouer(LesJoueurs:TabJoueur;n:integer):TabJoueur;
		var 
		i,acc:integer;
		Begin
		setlength(PremierAJouer,length(LesJoueurs));//On renvoie un tableau de la meme taille que celui recu, logique
		n:=n mod length(LesJoueurs); //On evite les erreurs potentielles
		acc:=0;
		for i:=n to high(LesJoueurs) do  //On place les joueurs dans l'ordre mais decale pour que le joueur gagnant soit premier
			Begin
			PremierAJouer[acc]:=LesJoueurs[i];
			Inc(acc);
			End;
		for i:=0 to n-1 do  //Puis on met ceux du debut du tableau a la suite 
			Begin
			PremierAJouer[acc]:=LesJoueurs[i];
			Inc(acc);
			End;		
		End;
		(*==============================================================================    
		* -Procedure qui va organiser les plis par manche et la distribution des cartes 
		*	Je veux une autre procedure qui identifie les cartes jouables et interdites
		===============================================================================*)
		Procedure MancheParManche(NumManche:integer;MaxManche:boolean;var LesJoueurs:TabJoueur);
		var 
		i,j,x:integer;
		Paquet:PaquetDeCarte;
		Atout:string;
		Tab:TabdynV2;
		Begin
		//Une seule fois par manche
		Atout:='';
		Paquet:=CreationTableauCarte(); //Creation du tableau contenant les cartes triees
		Paquet:=Melange(Paquet); //On melange le paquet de carte
		Distribution(Paquet,LesJoueurs,NumManche); //On distribue les cartes
		if ((Paquet[51].distribution = restante) and (not MaxManche)) then begin Atout:=Paquet[51].Valeurrr; Paquet[51].distribution:=Distribuee end;//On tire l'atout avant la prevision des plis
		if MaxManche then Atout:='';
		for i:=0 to 51 do writeln(Paquet[i].Valeurrr,' : ',Paquet[i].Distribution);
		PrevisionPli(LesJoueurs,NumManche,Atout,Paquet,MaxManche); //On fait en sorte de prevoir les plis
		for i:=NumManche downto 1 do
			Begin
			//////////////////////////////////////
			
					//Ici j'ai rajouter le setlength a chaque fois
			
			/////////////////////////////////////
			setlength(Tab,0);
			setlength(Tab,length(LesJoueurs)+1);//On creer un tableau de la taille du nombre de joueur +1 car on mettra dans ce tableau: tout les cartes jouee + l'atout quand y en a un
			Tab[0]:=Atout;//La premiere case correspond a l'atout ou a '' si il n'y en a pas
			for j:=0 to high(LesJoueurs) do //On fait jouer tout les joueurs
				Begin
				x:=-1; //On initialise la variable a -1 pour rentrer la boucle repeat
				repeat
					ClrScr; //On efface pour faciliter le jeu
					if (Atout<>'') then writeln('Atout : ',ValeurToCarte(Atout)); //On indique l'atout en premier
					Affichage(LesJoueurs[j].Cartes); //On affiche les cartes du joueurs
					writeln('Pli gagné(s)/Contrat : ',LesJoueurs[j].PliGagne,'/',LesJoueurs[j].Contrat);
					write('Jouer la carte (',LesJoueurs[j].Prenom ,') :'); //On demande au joueur de jouer un carte en particulier
					if (LesJoueurs[j].Player=Humain) then x:=JouerUneCertaineCarte(LesJoueurs[j].Cartes,Tab,LesJoueurs,j)//Readln(x) //Ici le joueur choisis la carte a jouer
					else x:=Generalisation(LesJoueurs,0,j,'Carte',Paquet,MaxManche);
				Until (x>0) and (x<longueur(LesJoueurs[j].Cartes)+1); //Verification que la carte jouer correspond a un entier positif qui correspond a une carte
				Tab[j+1]:=SupprCarte(LesJoueurs[j].Cartes,x);//On met en j+1 ieme case la carte jouer et donc supprimee de la main du joueur
				
				//Verif que ca marche 
				//Purement une verification si le code marche (je crois que le reste de la fonction ne sert a rien)
				Affichage(LesJoueurs[j].Cartes); //On afficher les cartes du joueur et les cartes jouees durant le pli 
				for x:=0 to high(Tab) do writeln(Tab[x]);
				x:=-1;
				//readln; //Permet a l'utilisateur de lire tranquillement et de passer une fois fini
				//ENd Verif que ca marche 
				
				End;
				//La on doit trier et dire qui est le meilleur et il doit commencer le prochain pli en attribuant le premier joueur et 1 PliGagne au gagnant
				
				
			//ICI je veux un affichage optimal pour le joueur
			//Ici c trop complique pour definir le joueur qui commence alors vu que je suis ingenieur 
			//je solutionne le probleme en faisant un autre tableau pcq je suis pas con
			//Un tableau qui garde le meme ordre mais qui admet comme joueur 0 celui qui a 
			//gagne le dernier pli 
			//Ne pas oublier de changer le premier joueur (+1) a chaque debut de MANCHE et UTILISER LA FONCTION AU DESSUS POUR LE JOUEUR GAGNANT
			LesJoueurs[QueLeMeilleurGagne(Tab,not MaxManche)].PliGagne:=LesJoueurs[QueLeMeilleurGagne(Tab,not MaxManche)].PliGagne+1;
			writeln(LesJoueurs[QueLeMeilleurGagne(Tab,not MaxManche)].Prenom,' à gagné ce pli');
			LesJoueurs:=PremierAJouer(LesJoueurs,QueLeMeilleurGagne(Tab,not MaxManche));
			RemportDePli(LesJoueurs[0].Prenom);
			//readln;
			End;
			ClrScr;
		for i:=1 to length(LesJoueurs) do  //Ici on attibue les points de ceux qui ont perdu et de ceux qui on gagnee
			Begin
			if (LesJoueurs[i-1].PliGagne <> LesJoueurs[i-1].Contrat) then LesJoueurs[i-1].Points:=LesJoueurs[i-1].Points-abs(LesJoueurs[i-1].Contrat-LesJoueurs[i-1].PliGagne)*5
			else LesJoueurs[i-1].Points:=LesJoueurs[i-1].Points+LesJoueurs[i-1].PliGagne*5;
			writeln(LesJoueurs[i-1].Prenom,' : ',LesJoueurs[i-1].PliGagne, '/',LesJoueurs[i-1].Contrat,' donc à un total de ',LesJoueurs[i-1].Points,' points.');
			LesJoueurs[i-1].Contrat:=-1;
			LesJoueurs[i-1].PliGagne:=0;
			End;
			//readln;
		End;
		
		(*==============================================================================    
		* -Procedure qui va faire en sorte que ce sois le joueurs+1 de jouer en 
		* gardant une ancre qui sera le prenom du premier joueur pour situé à
		* qui s'est de jouer pcq lors d'un pli, le joueur gagnant devient le premier
		===============================================================================*)
		function JoueurPlusUn(LesJoueurs:TabJoueur;first:string;acc:integer):TabJoueur;
		var
		i:integer;
		Begin
		JoueurPlusUn:=LesJoueurs;
		for i:=0 to high(LesJoueurs) do	
				if (LesJoueurs[i].Prenom=first) then exit(PremierAJouer(LesJoueurs,i+acc));
		End;
		
		
		(*==============================================================================    
		* -Procedure qui va gerer la partie, les manches, et le nombre de manche 
		* IL FAUT GERER LE PREMIER JOUEUR QUI TOURNE
		===============================================================================*)
		Procedure LancementPartie(var LesJoueurs:TabJoueur);
		var
		i,MaxManche,AQuiDeJouer:integer;
		OnEstPasMaxNous : boolean; //Pour savoir si c'est la derniere manche ou pas pour l'atout
		first:string; //repère pour le joueur qui sera premier a jouer
		Begin
		first:=LesJoueurs[0].Prenom;
		AQuiDeJouer:=0; //On tourne dans le sens des aiguille d'une montre pour le premier joueur a chaque manche
		case length(LesJoueurs) of  //On etablit le nombre de manche qu'il y aura en fonction du nombre de joueur
			2:MaxManche:=26;
			3:MaxManche:=17;
			4:MaxManche:=13;
			5:MaxManche:=10;
			else writeln('Très gros problème dans la procedure LancementPartie pcq c pas possible normalement');
		End;
		OnEstPasMaxNous:=false; //La manche maximal n'est pas arrivee
		for i:=1 to MaxManche do //On fait la montee
			Begin
			writeln('Manche ',i); //On écrit le num de la manche mais je crois que ca sert a rien
			if (i=MaxManche) then OnEstPasMaxNous:=true; //Lorsque on est a la derniere manche (max) on le precise pour l atout
			MancheParManche(i,OnEstPasMaxNous,LesJoueurs); //On lance la procedure pour une manche
			AQuiDeJouer:=(AQuiDeJouer+1) mod length(LesJoueurs); //car le joueur est +1 a chaque manche et de depend pas du gagnant du dernier pli
			LesJoueurs:=JoueurPlusUn(LesJoueurs,first,AQuiDeJouer); //On decale de 1 le premier joueur mais independement de celui qui a gagne le pli precedemment
			End;
		for i:=MaxManche downto 1 do //on fait la descente
			Begin
			MancheParManche(i,OnEstPasMaxNous,LesJoueurs);//On lance la procedure pour une manche
			if (i=MaxManche) then OnEstPasMaxNous:=false;//Une fois la derniere manche passee on remet a false
			AQuiDeJouer:=(AQuiDeJouer+1) mod length(LesJoueurs);
			LesJoueurs:=JoueurPlusUn(LesJoueurs,first,AQuiDeJouer); //On decale de 1 le premier joueur mais independement de celui qui a gagne le pli precedemment
			End;
		ClrScr;
		for i:=1 to length(LesJoueurs) do  writeln(LesJoueurs[i-1].Prenom,' : ',LesJoueurs[i-1].PliGagne, '/',LesJoueurs[i-1].Contrat,' donc à un total de ',LesJoueurs[i-1].Points,' points.');
				
		Score(LesJoueurs);

		End;
		//RESTE A FAIRE L'OBLIGATION DE JOUER UNE CERTAINE COULEUR SI LE JOUEUR L'A PUIS METTRE DANS LES VERIFICATION DE LA CARTE JOUEE
		
End.	
		
		
		
		
		
		
		
		
		
