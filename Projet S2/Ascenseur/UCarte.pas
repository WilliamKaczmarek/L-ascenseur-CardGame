unit UCarte;

interface
	uses UBase;
	
	procedure CreationTeteCarte(joueur,NbCartes:integer;var acc:integer;var LesJoueurs:TabJoueur;var Paquet:PaquetDeCarte);//TJ
	procedure Distribution(var Paquet : PaquetDeCarte;var LesJoueurs:TabJoueur;NbCartes:integer);//TJ
	function ValeurToCarte(Carte:string):string;//TJ
	Function Melange(Paquet:PaquetDeCarte):PaquetDeCarte;//WK
	Function SupprCarte(var tete : Ptr_Noeud;pos:integer):string;//TJ
	procedure Affichage(tete:ptr_noeud);//TJ
	function longueur(tete:ptr_noeud):integer;//TJ
	function NemeNoeud(tete:ptr_Noeud;i:integer):string;

implementation 
	(*==============================================================================    
		* Procedure qui va creer la Tete des files avec les cartes en main du joueur
		* on distribue le nombre de carte necessaire et on augmente l'accumulateur
		* de +1 a chaque fois ce qui signifie qu'on distribue les cartes dans l'ordre 
		* il faut donc que les cartes soient melanges auparavant
		===============================================================================*)
	procedure CreationTeteCarte(joueur,NbCartes:integer;var acc:integer;var LesJoueurs:TabJoueur;var Paquet:PaquetDeCarte);
	var 
	Tete,Precedent,Point: Ptr_Noeud;
	i:integer;
	Begin
	new(Tete);
	Tete^.valeur:=Paquet[acc].Valeurrr; //La premiere carte representera la tete de la file
	Paquet[acc].Distribution:=Distribuee;//On indique que la carte dans la main du joueur est distribuee
	acc:=acc+1; //Signifie l'emplacement de la carte suivante a distribuer
	Precedent:=Tete;
	for i:=2 to NbCartes do //On distribue le nombre de carte qui correspond a la manche
		Begin
		new(point);
		point^.valeur:=Paquet[acc].Valeurrr;
		precedent^.suivant:=point;
		precedent:=point;
		Paquet[acc].Distribution:=Distribuee;
		acc:=acc+1;
		End;
		precedent^.suivant:=NIL;//On redirige la queue vers rien
		LesJoueurs[joueur].Cartes:=Tete; //On indique la tete de la carte du joueur
	End;
	
	(*==============================================================================    
		* Procedure essentielle pour chaque debut de manche car elle distribue le 
		* paquet DEJA MELANGE dans la main de tout les joueurs
		===============================================================================*)
	
	procedure Distribution(var Paquet : PaquetDeCarte;var LesJoueurs:TabJoueur;NbCartes:integer);
	var
	i,acc:integer;
	Begin
		acc:=0;//Permet de se reperer dans le paquet melange
		for i:=1 to length(LesJoueurs) do //On distribue a tout les joueurs
			Begin
			CreationTeteCarte(i-1,NbCartes,acc,LesJoueurs,Paquet);
			End;
	End;
	
	(*==============================================================================    
		* Cette fonction va transformer la valeur de la carte dans le paquet (tableau)
		* en une valeur lisible par l'utilisateur par exemple:
		* H1 -> As de Coeur
		===============================================================================*)
		
	function ValeurToCarte(Carte:string):string;
	var
		Chiffre : string;
	Begin
		if (length(Carte)=2) then //Si c'est un nombre, on le laisse tel quel sauf si c'est un As
			Begin
			if (Carte[2]<>'1') then ValeurToCarte:=Carte[2]+' ' //Si ce n'est pas un As, on garde le chiffre
			else ValeurToCarte:='As ';
			End
		else
			Begin //Ici il y a forcemenbt 2chiffre apres la couleur de la carte donc c'est soit un 10 soit une tete
			Chiffre:=Carte[2]+Carte[3];//On isole le chiffre de la valeur puis on le transforme en 10, Valet, Dame ou Roi
			case Chiffre of 
				'10':ValeurToCarte:='10 ';
				'11':ValeurToCarte:='Valet ';
				'12':ValeurToCarte:='Dame ';
				'13':ValeurToCarte:='Roi ';
				else 
				writeln('Probleme dans la transformation des valeurs en carte (ValeurToCarte Unit UCarte) 1 ')//Erreur potentielle (on indique la fonction qui pose probleme)
				End;
			End;
		case Carte[1] of //Ici on va attribué la couleur a une carte, On transforme la 1ere lettre en Coeur, Pique, Carreau ou Trefle
		'H':ValeurToCarte:=ValeurToCarte+'de Coeur';
		'S':ValeurToCarte:=ValeurToCarte+'de Pique';
		'D':ValeurToCarte:=ValeurToCarte+'de Carreau';
		'C':ValeurToCarte:=ValeurToCarte+'de Trefle';//Je met pas d'accent expres
		else 
		writeln('Probleme dans la transformation des valeurs en carte (ValeurToCarte Unit UCarte) 2 ');//Erreur potentielle (on indique la fonction qui pose probleme)
		End;
	End;
	
	
	(*==============================================================================    
		* Cette fonction a pour but de melanger le tableau de carte qui est trie
		* Cette etape est essentielle pour la distribution des cartes
		* On creer un tableau d'entier aleatoire unique compris en tre 0 et 51 
		* puis on attibue a la case du tableau la valeur du tableau de carte a la 
		* case de valeur aleatoire generer
		===============================================================================*)
	
	
	
	Function Melange(Paquet:PaquetDeCarte):PaquetDeCarte;
	var 
		i : integer;
		RandTab : Tabdyn;
	Begin
	setlength(RandTab,52); //on creer un tab aleatoire d'entier entre 0 et 51 
	for i:=0 to 51 do
		Begin
		RandTab[i]:= random(52); //choisie une valeur aleatoire entre 0 et 51
		if Paquet[RandTab[i]].Distribution=Restante then //on verifie si elle est deja prise grace a notre tab de boolean
			Begin
			While Paquet[RandTab[i]].Distribution=Restante do //si la valeur est deja prise on parcours le tableau jusqu'a une valeur non utilisé
				Begin
				RandTab[i]:=(RandTab[i]+1) mod 52;
				End;
			End;
		Paquet[RandTab[i]].Distribution:=Restante;// si la valeur choisie n'etait pas utilise on passe la case du tab de boolean afin de pas reutiliser cette valeur
		End;
	setlength(Melange,52);
	for i:=0 to 51 do
		Begin
		Melange[i]:=Paquet[RandTab[i]];
		End;
	End;
	
	(*==============================================================================    
		* Procedure permettant de defausser une carte, tres utile lorsque l'on voudra 
		* jouer un carte car il faudra la supprimer une fois qu'elle sera posee
		* On prend en variable la tete de la file puis on se deplace au noeud suivant 
		* jusqu'a ce que l'on arrive à la position precise de la carte a retirer de 
		* la main du joueur
		* POUR EVITER LES ERREUR ON DOIT VERIFIER QUE LA CARTE EST COMPRIS ENTRE 1 
		* ET LONGUEUR(tete) puis qu'il y ait au moin une carte en main
		* Cette fonction doit renvoyer la carte supprimée
		===============================================================================*)
		Function SupprCarte(var tete : Ptr_Noeud;pos:integer):string;
		var 
			p,P_Supp: Ptr_Noeud;
			i: integer;
		Begin
		if (tete<>Nil) then //On verifie que la liste ne soit pas vide
			Begin
			if (pos=1) then //Si c'est la tête bah on enleve la tete
				Begin
				P_Supp := tete;
				tete := tete^.suivant;
				SupprCarte:=P_Supp^.valeur;
				dispose(P_Supp);
				End
			Else
				Begin //Sinon on se deplace jusqu'a la position demandée 
				i:= 1;//Je commence a 1 car le joueur n'aura pas de carte 0, c'est illogique
				p:= tete;
				while ((p^.suivant <> Nil) and (i < pos-1)) do 
					Begin
					p := p^.suivant;
					Inc(i);
					End;
				if (p^.suivant <> Nil) then	//Puis on supprime le noeud a la position demander
					Begin
					P_Supp := p^.suivant;
					p^.suivant := p^.suivant^.suivant;
					SupprCarte:=P_Supp^.valeur;
					dispose(P_Supp);
					End;
				End;
			End;//Ici c'est bizarre faut voir si on aura pas a verifier si c'est la queue et ajouter 'nil' si ça l'est 
				//Car je pensais que ça allait poser probleme 
		End;
	
	(*==============================================================================    
		* Procedure permettant l'affichage de toute les cartes d'un joueur, il prend comme
		* parametre la tete de la main du joueur puis affiche l'ordre des cartes et 
		* la valeur de leur carte, ceci sera utile lorsque l'on voudra selectionner
		* une carte a jouer (on pourra l'identifier par un numéro)
		===============================================================================*)
	
	procedure Affichage(tete:ptr_noeud);
	var
	i:integer;
	point:ptr_noeud;
	Begin
	point:=tete;
	for i:=1 to longueur(tete) do //On affiche a partir de la premiere carte a la derniere
		Begin
		writeln('Carte ',i,' : ',ValeurToCarte(point^.valeur)); //On indique l'indice de la carte et sa valeur
		point:=point^.suivant;
		End;
		writeln;
	End;
	
	(*==============================================================================    
		* Fonction permettant de compter le nombre de carte dans la main d'un joueur
		* C'est une fonction auxilliaire de Affichage
		===============================================================================*)
	
	function longueur(tete:ptr_noeud):integer;
	var
	tmp:ptr_noeud;
	Begin
	longueur:=0;
	tmp:=tete;
	while (tmp<>nil) do //Tant que ce n'est pas la derniere carte on ajoute +1 au compteur et on passe a la suivante
		Begin
		longueur:=longueur+1;
		tmp := tmp^.suivant;	
		End;
	End;
	
	function NemeNoeud(tete:ptr_Noeud;i:integer):string;
	var 
	j:integer;
	point:ptr_noeud;
	Begin
	point:=tete;
	for j:=1 to i-1 do point:=point^.suivant;
	NemeNoeud:=point^.valeur;	
	End;
	
End.
