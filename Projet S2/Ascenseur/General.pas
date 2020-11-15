program Ascenseur;
uses UBase,UCarte,UPartie, Ugraph;

var
LesJoueur:TabJoueur;
Begin
randomize; //Obligatoire pour le melange des cartes
	ReglesduJeu();
	InitialisationPartie(LesJoueur); 	
	LancementPartie(LesJoueur);

End.
