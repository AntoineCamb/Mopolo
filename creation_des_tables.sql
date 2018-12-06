drop table Crepe_salee cascade constraint;
drop table Crepe_sucree cascade constraint;
drop table Aliment cascade constraint;
drop table Fournisseur cascade constraint;
drop table Cidre cascade constraint;
drop table Menu cascade constraint;
drop table Date_menu cascade constraint;
drop table Menu_realiser_date_menu cascade constraint;
drop table Aliment_composer_crepe_salee cascade constraint;
drop table Aliment_composer_crepe_sucree cascade constraint;
drop table Fournisseur_livrer_aliment cascade constraint;
drop table Fournisseur_fournir_cidre cascade constraint;

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
drop type Menu_realiser_date_menu_t force;
/
drop type Aliment_composer_crepe_salee_t force;
/
drop type Aliment_composer_crepe_suc_t force;
/
drop type Fournisseur_livrer_aliment_t force;
/
drop type Fournisseur_fournir_cidre_t force;
/

Create or Replace type Crepe_t;
/

Create or Replace type setCrepes_t as table of Crepe_t;
/

CREATE OR REPLACE TYPE Aliment_t AS OBJECT(
	idAliment		number(5),
	nom				varchar2(25),
	region			varchar2(25),
	poids			float(2),
	typeAliment		varchar2(10),
	STATIC FUNCTION getInfoCreSal (idAliment1 in number) return setCrepes_t,
	MAP MEMBER FUNCTION compAliment RETURN varchar2,
	PRAGMA RESTRICT_REFERENCES (compAliment, WNDS, WNPS, RNPS, RNDS)
);
/

Create or Replace type listRefAliments_t as table of Aliment_t;
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
	vegetarienne 	char(1)
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

CREATE OR REPLACE TYPE BODY Fournisseur_t IS
	MAP MEMBER FUNCTION compFournisseur RETURN varchar2 IS
	BEGIN
		RETURN nom;
	END;
END;
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

CREATE OR REPLACE TYPE BODY Cidre_t IS
	MAP MEMBER FUNCTION compCidre RETURN varchar2 IS
	BEGIN
		RETURN nom||annee;
	END;
END;
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

CREATE OR REPLACE TYPE BODY Menu_t IS
	MAP MEMBER FUNCTION compMenu RETURN varchar2 IS
	BEGIN
		RETURN intitule;
	END;
END;
/

CREATE OR REPLACE TYPE Date_menu_t AS OBJECT(
	dateJour		date,
	MAP MEMBER FUNCTION compDate RETURN date,
	PRAGMA RESTRICT_REFERENCES (compDate, WNDS, WNPS, RNPS, RNDS)
);
/

CREATE OR REPLACE TYPE BODY Date_menu_t IS
	MAP MEMBER FUNCTION compDate RETURN date IS
	BEGIN
		RETURN dateJour;
	END;
END;
/

CREATE OR REPLACE TYPE Menu_realiser_date_menu_t AS OBJECT(
	idMenu			number(5),
	dateJour		date,
	duJour			char(1),
	MAP MEMBER FUNCTION compMenuRealiser RETURN date,
	PRAGMA RESTRICT_REFERENCES (compMenuRealiser, WNDS, WNPS, RNPS, RNDS)
);
/

CREATE OR REPLACE TYPE BODY Menu_realiser_date_menu_t IS
	MAP MEMBER FUNCTION  compMenuRealiser RETURN date IS
	BEGIN
		RETURN dateJour;
	END;
END;
/

CREATE OR REPLACE TYPE Aliment_composer_crepe_salee_t AS OBJECT(
	refAliment		ref Aliment_t,
	refCrepeSalee	ref Crepe_salee_t
);
/

CREATE OR REPLACE TYPE Aliment_composer_crepe_suc_t AS OBJECT(
	idAliment		number(5),
	idCrepeSucree	number(5),
	MAP MEMBER FUNCTION compAlimentComposerSucree RETURN number,
	PRAGMA RESTRICT_REFERENCES (compAlimentComposerSucree, WNDS, WNPS, RNPS, RNDS)
);
/

CREATE OR REPLACE TYPE BODY Aliment_composer_crepe_suc_t IS
	MAP MEMBER FUNCTION compAlimentComposerSucree RETURN number IS
	BEGIN
		RETURN idCrepeSucree;
	END;
END;
/

CREATE OR REPLACE TYPE Fournisseur_livrer_aliment_t AS OBJECT(
	idFournisseur	number(5),
	idAliment		number(5),
	dateLivraison	date,
	MAP MEMBER FUNCTION compFournisseurLivrer RETURN varchar2,
	PRAGMA RESTRICT_REFERENCES (compFournisseurLivrer, WNDS, WNPS, RNPS, RNDS)
);
/

CREATE OR REPLACE TYPE BODY Fournisseur_livrer_aliment_t IS
	MAP MEMBER FUNCTION compFournisseurLivrer RETURN varchar2 IS
	BEGIN
		RETURN dateLivraison||idFournisseur;
	END;
END;
/

CREATE OR REPLACE TYPE Fournisseur_fournir_cidre_t AS OBJECT(
	idFournisseur	number(5),
	idCidre			number(5),
	dateLivraison	date,
	MAP MEMBER FUNCTION compFournisseurFournir RETURN varchar2,
	PRAGMA RESTRICT_REFERENCES (compFournisseurFournir, WNDS, WNPS, RNPS, RNDS)
);
/

CREATE OR REPLACE TYPE BODY Fournisseur_fournir_cidre_t IS
	MAP MEMBER FUNCTION compFournisseurFournir RETURN varchar2 IS
	BEGIN
		RETURN dateLivraison||idFournisseur;
	END;
END;
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
nested table ListeRefAli store as storeListRefAli;

CREATE TABLE Crepe_sucree of Crepe_sucree_t(
	constraint pk_crepe_sucree_idCrepe primary key(idCrepe)
);

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

insert into Aliment VALUES(1, 'Oeufs', 'Landes', 250, 'viande');
insert into Aliment VALUES(2, 'Gruyère', 'Pyrenees-Orientales', 200, 'fromage');
insert into Aliment VALUES(3, 'Sucre', 'Pays Basque', 150, 'condiment');
insert into Aliment VALUES(4, 'Farine de Sarrazin', 'Bretagne', 500, 'condiment');
insert into Aliment VALUES(5, 'Tomates', 'Landes', 250, 'fruit');
insert into Aliment VALUES(6, 'Lardons', 'Gironde', 75, 'viande');
insert into Aliment VALUES(7, 'Jambon sec', 'Pays Basque Espagnol', 200, 'viande');
insert into Aliment VALUES(8, 'Fromage de brebis', 'Pyrénées Orientales', 75, 'fromage');
insert into Aliment VALUES(9, 'Fromage de chèvre', 'Pyrénées Atlantique', 75, 'fromage');
insert into Aliment VALUES(10, 'Poires', 'Var', 50, 'fruit');
insert into Aliment VALUES(11, 'Pignons de pin', 'Landes', 15, 'condiment');
insert into Aliment VALUES(12, 'Chorizo', 'Pays Basque Espagnol', 25, 'viande');
insert into Aliment VALUES(13, 'Salade', 'Pyrénées Atlantique', 50, 'légume');
insert into Aliment VALUES(14, 'Oignons', 'Landes', 30, 'légume'); 


insert into Crepe_salee VALUES(1, 'La Fromagère', null , 'Y');
insert into Crepe_salee VALUES(2, 'La Basquaise', null , 'N');
insert into Crepe_salee VALUES(3, 'La Landaise', null, 'N');

insert into Crepe_sucree VALUES(1, 'Nadine', null);
insert into Crepe_sucree VALUES(2, 'Amandine', null);
insert into Crepe_sucree VALUES(3, 'Hélène', null);

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

insert into Menu_realiser_date_menu VALUES(1,'21/11/2018','Y');
insert into Menu_realiser_date_menu VALUES(2,'25/11/2018','N');
insert into Menu_realiser_date_menu VALUES(3,'25/11/2018','Y');

insert into Aliment_composer_crepe_salee VALUES(1,1);
insert into Aliment_composer_crepe_salee VALUES(1,2);
insert into Aliment_composer_crepe_salee VALUES(3,3);

insert into Aliment_composer_crepe_sucree VALUES(3,1);
insert into Aliment_composer_crepe_sucree VALUES(3,2);
insert into Aliment_composer_crepe_sucree VALUES(3,3);

insert into Fournisseur_livrer_aliment VALUES(1,1,'18/11/2018');
insert into Fournisseur_livrer_aliment VALUES(2,2,'22/11/2018');
insert into Fournisseur_livrer_aliment VALUES(3,3,'30/11/2018');

insert into Fournisseur_fournir_cidre VALUES(1,1,'19/11/2018');
insert into Fournisseur_fournir_cidre VALUES(2,2,'21/11/2018');
insert into Fournisseur_fournir_cidre VALUES(3,3,'30/11/2018');


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

CREATE OR REPLACE TYPE BODY Aliment_t IS
	STATIC FUNCTION getInfoCrep (idAliment1 in number) RETURN setCrepes_t IS
		setCrep setCrepes_t:=setCrepes_t();
	BEGIN
		SELECT CAST(collect(value(cs)) as setCrepes_t) into setCrep
		FROM Crepe_salee cs WHERE cs.listRefAli.idCrepe = idCrepe1;
		return setAlim;
		EXCEPTION	
			WHEN NO_DATA_FOUND THEN
				raise;
	END;
END;
/


