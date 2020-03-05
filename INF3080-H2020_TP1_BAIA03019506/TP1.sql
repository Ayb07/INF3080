SET ECHO ON

-- Req 1
--Donnez les informations sans répétition des sigles, titres des cours, pris par l’étudiant dont
--le nom et prénom sont « Duguay Roger », ainsi que le code de la session, les noms et prénoms des professeurs qui donnent ces cours.
SELECT distinct sigle, titre , codeSession, P.nom, P.prenom
FROM  Cours natural join GroupeCours natural join Etudiant natural join Inscription,Professeur P
where Etudiant.nom = 'Duguay' and Etudiant.prenom = 'Roger' and
      P.codeProfesseur = GroupeCours.codeProfesseur
;

--Req2
--Donner les code et noms des professeurs, sans répétition, qui ont enseigné à la fois les cours INF3180 et INF2110, durant la session dont le code est 12004.
--Aussi, les code et noms des professeurs, sans répétition, qui ont enseigné les cours INF1130 ou INF1110, durant la session dont le code est 32003.
SELECT distinct codeProfesseur,nom
FROM  Professeur natural join GroupeCours
where (GroupeCours.sigle = 'INF1130' or GroupeCours.sigle = 'INF1110' and
      GroupeCours.codeSession = '32003') or
      (GroupeCours.sigle = 'INF3180' and GroupeCours.sigle = 'INF2110' and
      GroupeCours.codeSession = '12004')
;

--Req3
--Donner les informations sur différents étudiants qui ont reçu la même note pour le même cours (sigle) à la même session (codesession).
--Le résultat doit être affiché avec les attributs suivants (code permanent 1, code permanent 2, sigle, codesession, note).
SELECT  Inscription.note, Inscription.sigle, Inscription.codePermanent ,I2.codePermanent, Inscription.codeSession
FROM    Inscription, Inscription I2
where   Inscription.note = I2.note and
        Inscription.sigle = I2.sigle and
        Inscription.codeSession = I2.codeSession and
        Inscription.codePermanent != I2.codePermanent
        ;

--Req4
--On cherche les codes permanents, noms et prénoms et dates de naissances des étudiants inscrits aux cours dont les sigles commencent par les lettres ‘Inf’,
--enseignés par le professeur dont le nom est 'TREMBLAY' pendant les sessions 32003 ou 12004.
SELECT Etudiant.codePermanent, Etudiant.nom, Etudiant.prenom, Etudiant.datenaissance
FROM  Etudiant natural join GroupeCours natural join Inscription natural join Professeur
where Inscription.sigle = 'INF%' and
      Professeur.nom = 'TREMBLAY' and
      Inscription.codeSession = '32003' or Inscription.codeSession = '12004'
      ;


--Req5
--On cherche les codes et noms des professeurs, sans répétition, qui ont enseigné au plus
--un cours offert à la session 32003 et au moins un cours offert aux deux sessions
--(toutes les deux) dont les codes sont 12004 et 22005.
SELECT  distinct codeProfesseur,nom
FROM  Professeur natural join GroupeCours
where codeProfesseur =
                      (SELECT codeProfesseur
                      FROM professeur natural join GroupeCours
                      where GroupeCours.codeSession = '32003'
                      group by codeProfesseur
                      having count(*) <=1
                      and GroupeCours.codeSession = '12004' and GroupeCours.codeSession = '22005')
;


--Req6
--Donner les codes permanents, noms et prénoms des étudiants dont le nom commence par la lettre ‘B‘ et contient au moins les lettres ‘a’ et ‘z’ quelques soit leurs positions.
--Le prénom doit se terminer par la lettre ‘c’ et contenir trois lettres au maximum.
SELECT codePermanent, nom, prenom
FROM  Etudiant E
where E.nom like 'B%a%z%c' and LENGTH(nom) <= 3
;


--Req7
--Retourner les sigles des cours non encore enseignés par les professeurs dont les noms
--sont 'Casse' et 'Sauve'.
SELECT sigle
FROM  Cours
where not exists
                (SELECT nom
                 FROM Professeur P, GroupeCours GC
                 where P.codeProfesseur = GC.codeProfesseur and
                 (P.nom like 'Casse' and P.nom like 'Sauve'))
                 ;



--Req8
--Donner le code de la session ainsi que les noms et prénoms de tous les professeurs
--qui n’ont enseigné aucun cours durant cette session.
SELECT  distinct SU.codeSession, nom, prenom
FROM  Professeur P, GroupeCours GC, SessionUQAM SU
where not exists
                (SELECT codeProfesseur
                FROM GroupeCours
                where  P.codeProfesseur = GC.codeProfesseur and
                GC.codeSession = SU.codeSession)
                ;



--Req9
--Donnez les noms et prénoms des professeurs qui n’ont jamais enseigné le cours dont
--le sigle est ‘INF3080’.
SELECT  distinct nom, prenom
FROM  Professeur P, GroupeCours GC
where not exists
                (SELECT codeProfesseur
                 FROM GroupeCours
                 where  P.codeProfesseur = GC.codeProfesseur and
                 GC.sigle like 'INF3080')
                 ;

--Req10
--Pour chaque code session et sigle d’un cours, retourner le sigle du cours et son titre
--et la différence entre la meilleure et la plus mauvaise note pour un cours donné.
SELECT sigle,titre, MAX(I.note) - MIN(I.note) diff
FROM  Inscription I natural join Cours natural join GroupeCours
group by sigle, titre
;


--Req11
--Donner les sigles et titres des cours ayant un nombre maximum d’inscriptions
--supérieur à 50. Les titres des cours seront triés par ordre ascendant.
SELECT  distinct GroupeCours.sigle, titre
FROM    GroupeCours, Cours
where   GroupeCours.sigle = Cours.sigle and maxInscriptions > 50
order by titre asc
;


--Req12
--Donner les codes, noms et prénoms des professeurs ayant enseigné au moins un cours
--dans toutes les sessions.
SELECT distinct codeProfesseur, nom, prenom
FROM  Professeur natural join GroupeCours natural join SessionUQAM
;

--Req 13
-- Créer une vue nomée NB_prof_agree qui donne le nombre de professeurs qui est agrege.
CREATE VIEW NB_prof_agree AS
Select COUNT(titreprofesseur) as nb_prof_agrege
From professeur
Where titreProfesseur = 'profagrege';


--Req 14
-- Supprime les colonnes dateAbandon et maxInscriptions des la tables
-- concernée. Afficher les contenus des tables concernées.
ALTER TABLE inscription DROP COLUMN dateAbandon ;
ALTER TABLE groupecours DROP COLUMN maxinscriptions;
SELECT * FROM inscription natural join groupecours;

-- req 15
-- impossble de supprimer la colonne car elle est une clé parrant. 
