drop table Crepe_salee cascade constraint;
drop table Crepe_sucree cascade constraint;
drop table Aliment cascade constraint;
drop table Fournisseur cascade constraint;
drop table Cidre cascade constraint;
drop table Menu cascade constraint;
drop table Date_menu cascade constraint;

drop type Crepe_t force;
/
drop type Crepe_salee_t force;
/
drop type Crepe_sucree_t force;
/
drop type Aliment_t force;
/
drop type Fournisseur_t force;
/
drop type Cidre_t force;
/
drop type Menu_t force;
/
drop type Date_menu_t force;
/
drop type listRefMenus_t force;
/
drop type listRefAliments_t force;
/

CREATE OR REPLACE TYPE Crepe_salee_t;
/

CREATE OR REPLACE TYPE Crepe_sucree_t;
/

CREATE OR REPLACE TYPE Cidre_t;
/

CREATE OR REPLACE TYPE Menu_t AS OBJECT(
	idMenu			number(5),
	intitule        varchar2(25),
	refCrepeSal		ref Crepe_salee_t,
	refCrepeSuc		ref Crepe_sucree_t,
	refCidre		ref Cidre_t,
	STATIC FUNCTION getMenu(idMenu1 IN NUMBER) return Menu_t,
	MAP MEMBER FUNCTION compMenu RETURN varchar2,
	PRAGMA RESTRICT_REFERENCES (compMenu, WNDS, WNPS, RNPS, RNDS)
);
/

Create or Replace type listRefMenus_t as table of ref Menu_t;
/


CREATE OR REPLACE TYPE Aliment_t AS OBJECT(
	idAliment		number(5),
	nom				varchar2(25),
	region			varchar2(25),
	poids			float(2),
	typeAliment		varchar2(10),
	STATIC FUNCTION getAliment(idAliment1 IN NUMBER) return Aliment_t,
	MAP MEMBER FUNCTION compAliment RETURN varchar2,
	PRAGMA RESTRICT_REFERENCES (compAliment, WNDS, WNPS, RNPS, RNDS)
);
/

Create or Replace type listRefAliments_t as table of ref Aliment_t;
/
Create or Replace type setAliments_t as table of Aliment_t;
/
Create or Replace type setMenus_t as table of Menu_t;
/

CREATE OR REPLACE TYPE Crepe_t AS OBJECT(
	idCrepe			number(5),
	intitule		varchar2(25),
	recette			CLOB,
	listRefAli		listRefAliments_t,
	listRefMenu		listRefMenus_t,
	MAP MEMBER FUNCTION compCrepe RETURN varchar2,
	PRAGMA RESTRICT_REFERENCES (compCrepe, WNDS, WNPS, RNPS, RNDS)
)NOT FINAL;
/

CREATE OR REPLACE TYPE Crepe_salee_t UNDER Crepe_t(
	vegetarienne 	char(1),
	STATIC FUNCTION getCrepeSa(idCrepe1 IN NUMBER) return Crepe_salee_t,
	STATIC FUNCTION getAlimentsSa(idCrepe1 in number) return setAliments_t,
	STATIC FUNCTION getMenusSa(idCrepe1 in number) return setMenus_t,
	member procedure addLinkListAliments(RefAlim1 REF Aliment_t),
	member procedure addLinkListMenus(RefMenu1 REF Menu_t)
);
/

CREATE OR REPLACE TYPE Crepe_sucree_t UNDER Crepe_t(
	STATIC FUNCTION getCrepeSu(idCrepe1 IN NUMBER) return Crepe_sucree_t,
	STATIC FUNCTION getAlimentsSu(idCrepe1 in number) return setAliments_t,
	STATIC FUNCTION getMenusSu(idCrepe1 in number) return setMenus_t,
	member procedure addLinkListAliments(RefAlim1 REF Aliment_t),
	member procedure addLinkListMenus(RefMenu1 REF Menu_t)
);
/

CREATE OR REPLACE TYPE Fournisseur_t AS OBJECT(
	idFournisseur	number(5),
	nom				varchar2(25),
	adresse			varchar2(50),
	telephone		varchar2(14),
	STATIC FUNCTION getFournisseur(idFournisseur1 IN NUMBER) return Fournisseur_t,
	MAP MEMBER FUNCTION compFournisseur RETURN varchar2,
	PRAGMA RESTRICT_REFERENCES (compFournisseur, WNDS, WNPS, RNPS, RNDS)
);
/

CREATE OR REPLACE TYPE Cidre_t AS OBJECT(
	idCidre			number(5),
	nom				varchar2(25),
	annee			number(4),
	region			varchar2(25),
	listRefMenu		listRefMenus_t,
	STATIC FUNCTION getCidre(idCidre1 IN NUMBER) return Cidre_t,
	MAP MEMBER FUNCTION compCidre RETURN varchar2,
	PRAGMA RESTRICT_REFERENCES (compCidre, WNDS, WNPS, RNPS, RNDS),
	STATIC FUNCTION getMenusCi(idCidre1 in number) return setMenus_t,
	member procedure addLinkListMenus(RefMenu1 REF Menu_t)
);
/

CREATE OR REPLACE TYPE Date_menu_t AS OBJECT(
	dateJour		date,
	MAP MEMBER FUNCTION compDate RETURN date,
	PRAGMA RESTRICT_REFERENCES (compDate, WNDS, WNPS, RNPS, RNDS)
);
/

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

CREATE TABLE Aliment of Aliment_t(
	constraint pk_aliment_idAliment primary key(idAliment),
	constraint nl_aliment_nom nom not null,
	constraint nl_aliment_typeAliment typeAliment not null,
    constraint chk_aliment_typeAliment check (typeAliment in ('fruit','légume', 'fromage', 'viande', 'condiment')),
	constraint uc_aliment UNIQUE (nom)
);

CREATE TABLE Crepe_salee of Crepe_salee_t(
	constraint pk_crepe_salee_idCrepe primary key(idCrepe),
	constraint nl_crepe_salee_vegetarienne vegetarienne not null,
	constraint chk_crepe_salee_vegetarienne check (vegetarienne in ('Y','N'))
)
nested table ListRefAli store as storeListRefAliSa,
nested table ListRefMenu store as storeListRefMenuSa;

CREATE TABLE Crepe_sucree of Crepe_sucree_t(
	constraint pk_crepe_sucree_idCrepe primary key(idCrepe)
)
nested table ListRefAli store as storeListRefAliSu,
nested table ListRefMenu store as storeListRefMenuSu;

CREATE TABLE Fournisseur of Fournisseur_t(
	constraint pk_fournisseur_idFournisseur primary key(idFournisseur),
	constraint nl_fournisseur_nom nom not null,
	constraint nl_fournisseur_telephone telephone not null
);

CREATE TABLE Cidre of Cidre_t(
	constraint pk_cidre_idCidre primary key(idCidre),
	constraint nl_cidre_nom nom not null,
	constraint nl_cidre_annee annee not null,
	constraint nl_cidre_region region not null	
)
nested table ListRefMenu store as storeListRefMenuCidre;

CREATE TABLE Menu of Menu_t(
	constraint pk_menu_idMenu primary key(idMenu),
	constraint nl_menu_intitule intitule not null
);

CREATE TABLE Date_menu of Date_menu_t(
	constraint pk_date_menu_dateJour primary key(dateJour)
);



/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */


insert into Fournisseur VALUES(1, 'Roger et Fils', '3 rue des 4 vaches à lait 33500 Libourne', '05.51.23.67.84');
insert into Fournisseur VALUES(2, 'Oeufs et compagnie', '15 avenue richard boulit 40220 Tarnos', '05.64.87.61.63');
insert into Fournisseur VALUES(3, 'Bio et Co', '2 rue robespierre 64210 Biarritz', '05.59.47.65.24');

insert into Date_menu VALUES('18/03/2014');
insert into Date_menu VALUES('04/11/2017');
insert into Date_menu VALUES('11/07/2015');

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

CREATE OR REPLACE TYPE BODY Aliment_t AS
	MAP MEMBER FUNCTION compAliment RETURN varchar2 IS
	BEGIN
		RETURN typeAliment||nom||region;
	END;
	
	STATIC FUNCTION getAliment(idAliment1 IN number) return Aliment_t IS
			alim aliment_t:=null;
		begin
			select value(al) into alim from Aliment al where al.idAliment=idAliment1;
			return alim;
			EXCEPTION	
				WHEN NO_DATA_FOUND THEN
					raise;
		end;
END;
/

CREATE OR REPLACE TYPE BODY Crepe_t AS
	MAP MEMBER FUNCTION compCrepe RETURN varchar2 IS
	BEGIN
		RETURN intitule;
	END;
END;
/

CREATE OR REPLACE TYPE BODY Crepe_salee_t AS
	STATIC FUNCTION getCrepeSa(idCrepe1 IN number) return Crepe_salee_t IS
			crepesa crepe_salee_t:=null;
		begin
			select value(cs) into crepesa from Crepe_salee cs where cs.idCrepe=idCrepe1;
			return crepesa;
			EXCEPTION	
				WHEN NO_DATA_FOUND THEN
					raise;
		end;
	
	STATIC FUNCTION getAlimentsSa(idCrepe1 in number) RETURN setAliments_t IS
		setAli setAliments_t:=null;
	BEGIN
		SELECT cast(collect(value(al)) as setAliments_t) into setAli
		FROM Crepe_salee cs, table(cs.listRefAli) al
		WHERE cs.idCrepe = idCrepe1;
		RETURN setAli;
		EXCEPTION	
			WHEN NO_DATA_FOUND THEN
				raise;
	END;
	
	STATIC FUNCTION getMenusSa(idCrepe1 in number) RETURN setMenus_t IS
		setMenu setMenus_t:=setMenus_t();
	BEGIN
		SELECT cast(collect(value(me)) as setMenus_t) into setMenu
		FROM menu me
		WHERE me.refCrepeSal.idCrepe = idCrepe1;
		RETURN setMenu;
		EXCEPTION	
			WHEN NO_DATA_FOUND THEN
				raise;
	END;
	
	member procedure addLinkListAliments(RefAlim1 REF Aliment_t) IS
		begin
			insert into
			table(select cs.listRefAli from Crepe_salee cs where cs.idCrepe=self.idCrepe) 
			values (refAlim1);
			EXCEPTION 
				WHEN OTHERS THEN
				raise;
		end;
	
	member procedure addLinkListMenus(RefMenu1 REF Menu_t) IS
		begin
			insert into
			table(select cs.listRefMenu from Crepe_salee cs where cs.idCrepe=self.idCrepe) 
			values (refMenu1);
			EXCEPTION 
				WHEN OTHERS THEN
				raise;
		end;
END;
/

CREATE OR REPLACE TYPE BODY Crepe_sucree_t AS
	STATIC FUNCTION getCrepeSu(idCrepe1 IN number) return Crepe_sucree_t IS
			crepesu crepe_sucree_t:=null;
		begin
			select value(cs) into crepesu from Crepe_sucree cs where cs.idCrepe=idCrepe1;
			return crepesu;
			EXCEPTION	
				WHEN NO_DATA_FOUND THEN
					raise;
		end;
	
	STATIC FUNCTION getAlimentsSu(idCrepe1 in number) RETURN setAliments_t IS
		setAli setAliments_t:=setAliments_t();
	BEGIN
		SELECT cast(collect(value(al)) as setAliments_t) into setAli
		FROM Crepe_sucree cs, table(cs.listRefAli) al
		WHERE cs.idCrepe = idCrepe1;
		RETURN setAli;
		EXCEPTION	
			WHEN NO_DATA_FOUND THEN
				raise;
	END;
	
	STATIC FUNCTION getMenusSu(idCrepe1 in number) RETURN setMenus_t IS
		setMenu setMenus_t:=setMenus_t();
	BEGIN
		SELECT cast(collect(value(me)) as setMenus_t) into setMenu
		FROM menu me
		WHERE me.refCrepeSuc.idCrepe = idCrepe1;
		RETURN setMenu;
		EXCEPTION	
			WHEN NO_DATA_FOUND THEN
				raise;
	END;
	
	member procedure addLinkListAliments(RefAlim1 REF Aliment_t) IS
		begin
			insert into
			table(select cs.listRefAli from Crepe_sucree cs where cs.idCrepe=self.idCrepe) 
			values (refAlim1);
			EXCEPTION 
				WHEN OTHERS THEN
				raise;
		end;
	
	member procedure addLinkListMenus(RefMenu1 REF Menu_t) IS
		begin
			insert into
			table(select cs.listRefMenu from Crepe_sucree cs where cs.idCrepe=self.idCrepe) 
			values (refMenu1);
			EXCEPTION 
				WHEN OTHERS THEN
				raise;
		end;
END;
/

CREATE OR REPLACE TYPE BODY Fournisseur_t AS
	MAP MEMBER FUNCTION compFournisseur RETURN varchar2 IS
	BEGIN
		RETURN nom;
	END;
	
	STATIC FUNCTION getFournisseur(idFournisseur1 IN number) return Fournisseur_t IS
			fourni Fournisseur_t:=null;
		begin
			select value(fs) into fourni from Fournisseur fs where fs.idFournisseur=idFournisseur1;
			return fourni;
			EXCEPTION	
				WHEN NO_DATA_FOUND THEN
					raise;
		end;
	
END;
/

CREATE OR REPLACE TYPE BODY Cidre_t AS
	STATIC FUNCTION getCidre(idCidre1 IN number) return Cidre_t IS
			cidre Cidre_t:=null;
		begin
			select value(cd) into cidre from Cidre cd where cd.idCidre=idCidre1;
			return cidre;
			EXCEPTION	
				WHEN NO_DATA_FOUND THEN
					raise;
		end;
	
	MAP MEMBER FUNCTION compCidre RETURN varchar2 IS
	BEGIN
		RETURN nom||annee;
	END;
	
	STATIC FUNCTION getMenusCi(idCidre1 in number) RETURN setMenus_t IS
		setMenu setMenus_t:=setMenus_t();
	BEGIN
		SELECT cast(collect(value(me)) as setMenus_t) into setMenu
		FROM menu me
		WHERE me.refCidre.idCidre = idCidre1;
		RETURN setMenu;
		EXCEPTION	
			WHEN NO_DATA_FOUND THEN
				raise;
	END;
	
	member procedure addLinkListMenus(RefMenu1 REF Menu_t) IS
		begin
			insert into
			table(select c.listRefMenu from Cidre c where c.idCidre=self.idCidre) 
			values (refMenu1);
			EXCEPTION 
				WHEN OTHERS THEN
				raise;
		end;
END;
/

CREATE OR REPLACE TYPE BODY Menu_t AS
	STATIC FUNCTION getMenu(idMenu1 IN number) return Menu_t IS
			men Menu_t:=null;
		begin
			select value(me) into men from Menu me where me.idMenu=idMenu1;
			return men;
			EXCEPTION	
				WHEN NO_DATA_FOUND THEN
					raise;
		end;
	
	MAP MEMBER FUNCTION compMenu RETURN varchar2 IS
	BEGIN
		RETURN intitule;
	END;
END;
/

CREATE OR REPLACE TYPE BODY Date_menu_t AS
	MAP MEMBER FUNCTION compDate RETURN date IS
	BEGIN
		RETURN dateJour;
	END;
END;
/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
declare
	refAlim1 REF Aliment_t;
	refAlim2 REF Aliment_t;
	refAlim3 REF Aliment_t;
	refAlim4 REF Aliment_t;
	refAlim5 REF Aliment_t;
	refAlim6 REF Aliment_t;
	refAlim7 REF Aliment_t;
	refAlim8 REF Aliment_t;
	refAlim9 REF Aliment_t;
	refAlim10 REF Aliment_t;
	refAlim11 REF Aliment_t;
	refAlim12 REF Aliment_t;
	refAlim13 REF Aliment_t;
	refAlim14 REF Aliment_t;
	refAlim15 REF Aliment_t;
	refAlim16 REF Aliment_t;
	refAlim17 REF Aliment_t;
	refAlim18 REF Aliment_t;
	refAlim19 REF Aliment_t;
	
	refCrepSa1 REF Crepe_salee_t;
	refCrepSa2 REF Crepe_salee_t;
	refCrepSa3 REF Crepe_salee_t;
	
	refCrepSu1 REF Crepe_sucree_t;
	refCrepSu2 REF Crepe_sucree_t;
	refCrepSu3 REF Crepe_sucree_t;
	
	refCidre1 REF Cidre_t;
	refCidre2 REF Cidre_t;
	refCidre3 REF Cidre_t;
	
	refMenu1 REF Menu_t;
	refMenu2 REF Menu_t;
	refMenu3 REF Menu_t;
begin
	-- insertion des crêpes salées
	insert into Crepe_salee cs VALUES(crepe_salee_t(1, 'La Fromagère', EMPTY_CLOB(), listRefAliments_t(), listRefMenus_t(),'Y'))
	returning ref(cs) into refCrepSa1;
	insert into Crepe_salee cs VALUES(crepe_salee_t(2, 'La Basquaise', EMPTY_CLOB(), listRefAliments_t(), listRefMenus_t(), 'N'))
	returning ref(cs) into refCrepSa2;
	insert into Crepe_salee cs VALUES(crepe_salee_t(3, 'La Landaise', EMPTY_CLOB(), listRefAliments_t(), listRefMenus_t(), 'N'))
	returning ref(cs) into refCrepSa3;
	
	-- insertion des crêpes sucrées
	insert into Crepe_sucree cs VALUES(crepe_sucree_t(1, 'Nadine', EMPTY_CLOB(), listRefAliments_t(), listRefMenus_t()))
	returning ref(cs) into refCrepSu1;
	insert into Crepe_sucree cs VALUES(crepe_sucree_t(2, 'Amandine', EMPTY_CLOB(), listRefAliments_t(), listRefMenus_t()))
	returning ref(cs) into refCrepSu2;
	insert into Crepe_sucree cs VALUES(crepe_sucree_t(3, 'Hélène', EMPTY_CLOB(), listRefAliments_t(), listRefMenus_t()))
	returning ref(cs) into refCrepSu3;
	
	-- insertion des aliments
	insert into Aliment al VALUES(Aliment_t(1, 'Oeufs', 'Landes', 250, 'viande'))
	returning ref(al) into refAlim1;
	insert into Aliment al VALUES(Aliment_t(2, 'Gruyère', 'Pyrenees-Orientales', 200, 'fromage'))
	returning ref(al) into refAlim2;
	insert into Aliment al VALUES(Aliment_t(3, 'Sucre', 'Pays Basque', 150, 'condiment'))
	returning ref(al) into refAlim3;
	insert into Aliment al VALUES(Aliment_t(4, 'Farine de Sarrazin', 'Bretagne', 500, 'condiment'))
	returning ref(al) into refAlim4;
	insert into Aliment al VALUES(Aliment_t(5, 'Tomates', 'Landes', 250, 'fruit'))
	returning ref(al) into refAlim5;
	insert into Aliment al VALUES(Aliment_t(6, 'Lardons', 'Gironde', 75, 'viande'))
	returning ref(al) into refAlim6;
	insert into Aliment al VALUES(Aliment_t(7, 'Jambon sec', 'Pays Basque Espagnol', 200, 'viande'))
	returning ref(al) into refAlim7;
	insert into Aliment al VALUES(Aliment_t(8, 'Fromage de brebis', 'Pyrénées Orientales', 75, 'fromage'))
	returning ref(al) into refAlim8;
	insert into Aliment al VALUES(Aliment_t(9, 'Fromage de chèvre', 'Pyrénées Atlantique', 75, 'fromage'))
	returning ref(al) into refAlim9;
	insert into Aliment al VALUES(Aliment_t(10, 'Poires', 'Var', 50, 'fruit'))
	returning ref(al) into refAlim10;
	insert into Aliment al VALUES(Aliment_t(11, 'Pignons de pin', 'Landes', 15, 'condiment'))
	returning ref(al) into refAlim11;
	insert into Aliment al VALUES(Aliment_t(12, 'Chorizo', 'Pays Basque Espagnol', 25, 'viande'))
	returning ref(al) into refAlim12;
	insert into Aliment al VALUES(Aliment_t(13, 'Salade', 'Pyrénées Atlantique', 50, 'légume'))
	returning ref(al) into refAlim13;
	insert into Aliment al VALUES(Aliment_t(14, 'Oignons', 'Landes', 30, 'légume'))
	returning ref(al) into refAlim14;
	insert into Aliment al VALUES(Aliment_t(15, 'Chocolat', 'Suisse', 20, 'condiment'))
	returning ref(al) into refAlim15;
	insert into Aliment al VALUES(Aliment_t(16, 'Glâce chocoloat', 'Bayonne', 10, 'condiment'))
	returning ref(al) into refAlim16;
	insert into Aliment al VALUES(Aliment_t(17, 'Glâce vanille', 'Bayonne', 10, 'condiment'))
	returning ref(al) into refAlim17;
	insert into Aliment al VALUES(Aliment_t(18, 'Chantilly', 'Bordeaux', 15, 'condiment'))
	returning ref(al) into refAlim18; 
	insert into Aliment al VALUES(Aliment_t(19, 'Amandes', 'Bordeaux', 10, 'condiment'))
	returning ref(al) into refAlim19;

	-- insertion des cidres
	insert into Cidre c VALUES(Cidre_t(1, 'Cidre basque', 2010, 'Pays Basque', listRefMenus_t()))
	returning ref(c) into refCidre1;
	insert into Cidre c VALUES(Cidre_t(2, 'Cidre basque', 2008, 'Pays Basque', listRefMenus_t()))
	returning ref(c) into refCidre2;
	insert into Cidre c VALUES(Cidre_t(3, 'Cidre breton', 2015, 'Bretagne', listRefMenus_t()))
	returning ref(c) into refCidre3;
	
	-- insertion des menus
	insert into Menu me VALUES(Menu_t(1, 'Le gourmand', refCrepSa1, refCrepSu1, refCidre1))
	returning ref(me) into refMenu1;
	insert into Menu me VALUES(Menu_t(2, 'Le petit basque', refCrepSa2, refCrepSu2, refCidre2))
	returning ref(me) into refMenu2;
	insert into Menu me VALUES(Menu_t(3, 'Le voyageur', refCrepSa3, refCrepSu3, refCidre3))
	returning ref(me) into refMenu3;
		
	-- mise à jour de la liste des références vers les aliments de chaque crêpes salées
	insert into 
	table(Select cs.listRefAli from Crepe_salee cs where cs.idCrepe=1)
	values (refAlim2);
	insert into 
	table(Select cs.listRefAli from Crepe_salee cs where cs.idCrepe=1)
	values (refAlim8);
	insert into 
	table(Select cs.listRefAli from Crepe_salee cs where cs.idCrepe=1)
	values (refAlim9);
	
	insert into 
	table(Select cs.listRefAli from Crepe_salee cs where cs.idCrepe=2)
	values (refAlim5);
	insert into 
	table(Select cs.listRefAli from Crepe_salee cs where cs.idCrepe=2)
	values (refAlim11);
	insert into 
	table(Select cs.listRefAli from Crepe_salee cs where cs.idCrepe=2)
	values (refAlim12);
	insert into 
	table(Select cs.listRefAli from Crepe_salee cs where cs.idCrepe=2)
	values (refAlim14);
	
	-- mise à jour de la liste des références vers les menus de chaque crêpes salées
	insert into 
	table(Select cs.listRefMenu from Crepe_salee cs where cs.idCrepe=1)
	values (refMenu1);
	insert into 
	table(Select cs.listRefMenu from Crepe_salee cs where cs.idCrepe=2)
	values (refMenu2);
	insert into 
	table(Select cs.listRefMenu from Crepe_salee cs where cs.idCrepe=3)
	values (refMenu3);
	
	-- mise à jour de la liste des références vers les aliments de chaque crêpes sucrées
	insert into 
	table(Select cs.listRefAli from Crepe_sucree cs where cs.idCrepe=3)
	values (refAlim15);
	insert into 
	table(Select cs.listRefAli from Crepe_sucree cs where cs.idCrepe=3)
	values (refAlim10);
	insert into 
	table(Select cs.listRefAli from Crepe_sucree cs where cs.idCrepe=3)
	values (refAlim18);
	
	insert into 
	table(Select cs.listRefAli from Crepe_sucree cs where cs.idCrepe=2)
	values (refAlim17);
	insert into 
	table(Select cs.listRefAli from Crepe_sucree cs where cs.idCrepe=2)
	values (refAlim19);
	insert into 
	table(Select cs.listRefAli from Crepe_sucree cs where cs.idCrepe=2)
	values (refAlim18);
	
	-- mise à jour de la liste des références vers les menus de chaque crêpes sucrées
	insert into 
	table(Select cs.listRefMenu from Crepe_sucree cs where cs.idCrepe=1)
	values (refMenu1);
	insert into 
	table(Select cs.listRefMenu from Crepe_sucree cs where cs.idCrepe=2)
	values (refMenu2);
	insert into 
	table(Select cs.listRefMenu from Crepe_sucree cs where cs.idCrepe=3)
	values (refMenu3);
	
	-- mise à jour de la liste des références vers les menus de chaque cidre
	insert into 
	table(Select c.listRefMenu from Cidre c where c.idCidre=1)
	values (refMenu1);
	insert into 
	table(Select c.listRefMenu from Cidre c where c.idCidre=2)
	values (refMenu2);
	insert into 
	table(Select c.listRefMenu from Cidre c where c.idCidre=3)
	values (refMenu3);	
end;
/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- test des fonctions ADDLINK
declare 
	crepesalee crepe_salee_t;
	crepesucree crepe_sucree_t;
	alimSu aliment_t := aliment_t(21, 'Pommes', 'Pyrenees-Orientales', 20, 'fruit');
	alimSa aliment_t := aliment_t(20, 'Poivron rouge', 'Landes', 25, 'légume');
	
	refAlim REF Aliment_t;
	refCrepeSa REF Crepe_salee_t;
	refCrepeSu REF Crepe_sucree_t;
begin 
	select ref(cs), value(cs) into refCrepeSa, crepesalee
	from crepe_salee cs where cs.idCrepe = 3;	
		
	insert into Aliment al
	values (alimSa) returning ref(al) into refAlim;
	
	crepesalee.addLinkListAliments(refAlim);
	
	select ref(cs), value(cs) into refCrepeSu, crepesucree
	from crepe_sucree cs where cs.idCrepe = 1;	
		
	insert into Aliment al
	values (alimSu) returning ref(al) into refAlim;
	
	crepesucree.addLinkListAliments(refAlim);
	
	EXCEPTION
		WHEN OTHERS THEN
			dbms_output.put_line('sqlcode= '||sqlcode);
			dbms_output.put_line('sqlerrm= '||sqlerrm);
	
end;
/

-- test des fonctions GET
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
			/* Aliment 3
			Nom = Sucre
			Stock = 200kg
			Région = Pays Basque
			Type = condiment

			Crèpe salée 1
			Intitulé = La Fromagère
			Recette = 
			Végétarienne = Y

			Crèpe sucrée 2
			Intitulé = Amandine
			Recette = 

			Fournisseur 3
			Nom = Bio et Co
			Adresse = 2 rue robespierre 64210 Biarritz
			Téléphone = 05.59.47.65.24

			Cidre 1
			Nom = Cidre basque
			Année = 2010
			Région = Pays Basque

			Menu 2
			Intitulé = Le petit basque

			Crèpe salée 2 > Menus
			Intitulé = Le petit basque

			Crèpe sucrée 1 > Menus
			Intitulé = Le gourmand

			Cidre 1 > Menus
			Intitulé = Le gourmand



			Procédure PL/SQL terminée. */




/*CREATE OR REPLACE TYPE BODY Aliment_t IS
	STATIC FUNCTION getInfoCrep (idAliment1 in number) RETURN setCrepes_t IS
		setCrep setCrepes_t:=setCrepes_t();
	BEGIN
		SELECT CAST(collect(value(cs)) as setCrepes_t) into setCrep
		FROM Crepe_salee cs, table(cs.listRefAli) la WHERE cs.idCrepe = idCrepe1;
		return setAlim;
		EXCEPTION	
			WHEN NO_DATA_FOUND THEN
				raise;
	END;
END;
/*/
