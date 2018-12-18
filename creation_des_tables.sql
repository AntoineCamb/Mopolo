set serveroutput on
declare 
	alim aliment_t;
	crepeSa crepe_salee_t;
	crepeSu crepe_sucree_t;
	fourn fournisseur_t;
	cid cidre_t;
	men menu_t;
	setMenu setMenus_t;
begin
	dbms_output.put_line('Aliment 3');
	alim := aliment_t.getAliment(3);
	dbms_output.put_line('Nom = ' || alim.nom);
	dbms_output.put_line('Stock = ' || alim.poids || 'kg');
	dbms_output.put_line('Région = ' || alim.region);
	dbms_output.put_line('Type = ' || alim.typeAliment);
	DBMS_OUTPUT.NEW_LINE; 
	
	dbms_output.put_line('Crèpe salée 1');
	crepeSa := crepe_salee_t.getCrepeSa(1);
	dbms_output.put_line('Intitulé = ' || crepeSa.intitule);
	dbms_output.put_line('Recette = ' || crepeSa.recette);
	dbms_output.put_line('Végétarienne = ' || crepeSa.vegetarienne);
	DBMS_OUTPUT.NEW_LINE;
		
	dbms_output.put_line('Crèpe sucrée 2');
	crepeSu := crepe_sucree_t.getCrepeSu(2);
	dbms_output.put_line('Intitulé = ' || crepeSu.intitule);
	dbms_output.put_line('Recette = ' || crepeSu.recette);
	DBMS_OUTPUT.NEW_LINE;
	
	dbms_output.put_line('Fournisseur 3');
	fourn := fournisseur_t.getFournisseur(3);
	dbms_output.put_line('Nom = ' || fourn.nom);
	dbms_output.put_line('Adresse = ' || fourn.adresse);
	dbms_output.put_line('Téléphone = ' || fourn.telephone);
	DBMS_OUTPUT.NEW_LINE;
	
	dbms_output.put_line('Cidre 1');
	cid := cidre_t.getCidre(1);
	dbms_output.put_line('Nom = ' || cid.nom);
	dbms_output.put_line('Année = ' || cid.annee);
	dbms_output.put_line('Région = ' || cid.region);
	DBMS_OUTPUT.NEW_LINE;
	
	dbms_output.put_line('Menu 2');
	men := menu_t.getMenu(2);
	dbms_output.put_line('Intitulé = ' || men.intitule);
	DBMS_OUTPUT.NEW_LINE;
	
	dbms_output.put_line('Crèpe salée 2 > Menus');
	setMenu:=crepe_salee_t.getMenusSa(2);
	For i IN setMenu.FIRST..setMenu.LAST LOOP
		dbms_output.put_line('Intitulé = ' || setMenu(i).intitule);
	END LOOP;
	DBMS_OUTPUT.NEW_LINE; 
	
	dbms_output.put_line('Crèpe sucrée 1 > Menus');
	setMenu:=crepe_sucree_t.getMenusSu(1);
	For j IN setMenu.FIRST..setMenu.LAST LOOP
		dbms_output.put_line('Intitulé = ' || setMenu(j).intitule);
	END LOOP;
	DBMS_OUTPUT.NEW_LINE; 
	
	dbms_output.put_line('Cidre 1 > Menus');
	setMenu:=Cidre_t.getMenusCi(1);
	For k IN setMenu.FIRST..setMenu.LAST LOOP
		dbms_output.put_line('Intitulé = ' || setMenu(k).intitule);
	END LOOP;
	DBMS_OUTPUT.NEW_LINE; 
	
	EXCEPTION 
		WHEN NO_DATA_FOUND then
		dbms_output.put_line('Pas d''employés avec ce numéro');
		dbms_output.put_line('sqlcode= '||sqlcode);
		dbms_output.put_line('sqlerrm= ' ||sqlerrm);
	
	
end;
/
