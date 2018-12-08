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

CREATE OR REPLACE TYPE Aliment_t AS OBJECT(
	idAliment		number(5),
	nom				varchar2(25),
	region			varchar2(25),
	poids			float(2),
	typeAliment		varchar2(10),
	MAP MEMBER FUNCTION compAliment RETURN varchar2,
	PRAGMA RESTRICT_REFERENCES (compAliment, WNDS, WNPS, RNPS, RNDS)
);
/

Create or Replace type listRefAliments_t as table of ref Aliment_t;
/
Create or Replace type setAliments_t as table of Aliment_t;
/

CREATE OR REPLACE TYPE Crepe_t AS OBJECT(
	idCrepe			number(5),
	intitule		varchar2(25),
	recette			CLOB,
	listRefAli		listRefAliments_t,
	MAP MEMBER FUNCTION compCrepe RETURN varchar2,
	PRAGMA RESTRICT_REFERENCES (compCrepe, WNDS, WNPS, RNPS, RNDS)
)NOT FINAL;
/

CREATE OR REPLACE TYPE Crepe_salee_t UNDER Crepe_t(
	vegetarienne 	char(1),
	STATIC FUNCTION getAlimentsSa(idCrepe1 in number) return setAliments_t,
	member procedure addLinkListAliments(RefAlim1 REF Aliment_t)
);
/

CREATE OR REPLACE TYPE Crepe_sucree_t UNDER Crepe_t(
	STATIC FUNCTION getInfoAliment (idCrepe1 in number) return setAliments_t
);
/

CREATE OR REPLACE TYPE Fournisseur_t AS OBJECT(
	idFournisseur	number(5),
	nom				varchar2(25),
	adresse			varchar2(50),
	telephone		varchar2(14),
	MAP MEMBER FUNCTION compFournisseur RETURN varchar2,
	PRAGMA RESTRICT_REFERENCES (compFournisseur, WNDS, WNPS, RNPS, RNDS)
);
/

CREATE OR REPLACE TYPE Cidre_t AS OBJECT(
	idCidre			number(5),
	nom				varchar2(25),
	annee			number(4),
	region			varchar2(25),
	MAP MEMBER FUNCTION compCidre RETURN varchar2,
	PRAGMA RESTRICT_REFERENCES (compCidre, WNDS, WNPS, RNPS, RNDS)
);
/

CREATE OR REPLACE TYPE Menu_t AS OBJECT(
	idMenu			number(5),
	idCrepeSalee	number(5),
	idCrepeSucree	number(5),
	idCidre			number(5),
	intitule        varchar2(25),
	MAP MEMBER FUNCTION compMenu RETURN varchar2,
	PRAGMA RESTRICT_REFERENCES (compMenu, WNDS, WNPS, RNPS, RNDS)
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
    constraint chk_aliment_typeAliment check (typeAliment in ('fruit','légume', 'fromage', 'viande', 'condiment'))
);

CREATE TABLE Crepe_salee of Crepe_salee_t(
	constraint pk_crepe_salee_idCrepe primary key(idCrepe),
	constraint nl_crepe_salee_vegetarienne vegetarienne not null,
	constraint chk_crepe_salee_vegetarienne check (vegetarienne in ('Y','N'))
)
nested table ListRefAli store as storeListRefAliSa;

CREATE TABLE Crepe_sucree of Crepe_sucree_t(
	constraint pk_crepe_sucree_idCrepe primary key(idCrepe)
)
nested table ListRefAli store as storeListRefAliSu;

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
);

CREATE TABLE Menu of Menu_t(
	constraint pk_menu_idMenu primary key(idMenu),
	constraint fk_menu_idCrepeSalee foreign key(idCrepeSalee) REFERENCES Crepe_salee(idCrepe),
	constraint fk_menu_idCrepeSucree foreign key(idCrepeSucree) REFERENCES Crepe_sucree(idCrepe),
	constraint fk_menu_idCidre foreign key (idCidre) REFERENCES Cidre(idCidre),
	constraint nl_menu_intitule intitule not null
);

CREATE TABLE Date_menu of Date_menu_t(
	constraint pk_date_menu_dateJour primary key(dateJour)
);



/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

insert into Crepe_sucree VALUES(1, 'Nadine', null, null);
insert into Crepe_sucree VALUES(2, 'Amandine', null, null);
insert into Crepe_sucree VALUES(3, 'Hélène', null, null);

insert into Fournisseur VALUES(1, 'Roger et Fils', '3 rue des 4 vaches à lait 33500 Libourne', '05.51.23.67.84');
insert into Fournisseur VALUES(2, 'Oeufs et compagnie', '15 avenue richard boulit 40220 Tarnos', '05.64.87.61.63');
insert into Fournisseur VALUES(3, 'Bio et Co', '2 rue robespierre 64210 Biarritz', '05.59.47.65.24');

insert into Cidre VALUES(1, 'Cidre basque', 2010, 'Pays Basque');
insert into Cidre VALUES(2, 'Cidre basque', 2008, 'Pays Basque');
insert into Cidre VALUES(3, 'Cidre breton', 2015, 'Bretagne');

insert into Menu VALUES(1,1,1,1,'Menu basque');
insert into Menu VALUES(2,2,2,2,'Menu landais');
insert into Menu VALUES(3,3,3,3,'Menu breton');

insert into Date_menu VALUES('18/03/2014');
insert into Date_menu VALUES('04/11/2017');
insert into Date_menu VALUES('11/07/2015');

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

CREATE OR REPLACE TYPE BODY Aliment_t IS
	MAP MEMBER FUNCTION compAliment RETURN varchar2 IS
	BEGIN
		RETURN typeAliment||nom||region;
	END;
END;
/

CREATE OR REPLACE TYPE BODY Crepe_t IS
	MAP MEMBER FUNCTION compCrepe RETURN varchar2 IS
	BEGIN
		RETURN intitule;
	END;
END;
/

CREATE OR REPLACE TYPE BODY Crepe_salee_t IS
	STATIC FUNCTION getAlimentsSa(idCrepe1 in number) RETURN setAliments_t IS
		setAli setAliments_t:=setAliments_t();
	BEGIN
		SELECT cast(collect(value(al)) as setAliments_t) into setAli
		FROM Crepe_salee cs, table(cs.listRefAli) al
		WHERE cs.idCrepe = idCrepe1;
		RETURN setAli;
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
END;
/

CREATE OR REPLACE TYPE BODY Fournisseur_t IS
	MAP MEMBER FUNCTION compFournisseur RETURN varchar2 IS
	BEGIN
		RETURN nom;
	END;
END;
/

CREATE OR REPLACE TYPE BODY Cidre_t IS
	MAP MEMBER FUNCTION compCidre RETURN varchar2 IS
	BEGIN
		RETURN nom||annee;
	END;
END;
/

CREATE OR REPLACE TYPE BODY Menu_t IS
	MAP MEMBER FUNCTION compMenu RETURN varchar2 IS
	BEGIN
		RETURN intitule;
	END;
END;
/

CREATE OR REPLACE TYPE BODY Date_menu_t IS
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
	
begin
	-- insertion des crêpes 
	insert into Crepe_salee VALUES(crepe_salee_t(1, 'La Fromagère', EMPTY_CLOB(), listRefAliments_t(),'Y'));
	insert into Crepe_salee VALUES(crepe_salee_t(2, 'La Basquaise', EMPTY_CLOB(), listRefAliments_t() , 'N'));
	insert into Crepe_salee VALUES(crepe_salee_t(3, 'La Landaise', EMPTY_CLOB(), listRefAliments_t(), 'N'));
		
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
	
end;
/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

declare 
	crepesalee crepe_salee_t;
	alim aliment_t := aliment_t(15, 'Poivron rouge', 'Landes', 25, 'légume');
	
	refAlim REF Aliment_t;
	refCrepe REF Crepe_salee_t;
begin 
	select ref(cs), value(cs) into refCrepe, crepesalee
	from crepe_salee cs where cs.idCrepe=3 ;	
		
	insert into Aliment al
	values (alim) returning ref(al) into refAlim;
	
	crepesalee.addLinkListAliments(refAlim);
	
	EXCEPTION
		WHEN OTHERS THEN
			dbms_output.put_line('sqlcode= '||sqlcode);
			dbms_output.put_line('sqlerrm= '||sqlerrm);
	
end;
/




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
