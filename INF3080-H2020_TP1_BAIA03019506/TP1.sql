SET ECHO ON

-- Req 1
SELECT distinct sigle, titre , codeSession, P.nom, P.prenom
FROM  Cours natural join GroupeCours natural join Etudiant natural join Inscription,Professeur P
where Etudiant.nom = 'Duguay' and Etudiant.prenom = 'Roger' and
      P.codeProfesseur = GroupeCours.codeProfesseur
;

--Req2
SELECT distinct codeProfesseur,nom
FROM  Professeur natural join GroupeCours
where (GroupeCours.sigle = 'INF1130' or GroupeCours.sigle = 'INF1110' and
      GroupeCours.codeSession = '32003') or
      (GroupeCours.sigle = 'INF3180' and GroupeCours.sigle = 'INF2110' and
      GroupeCours.codeSession = '12004')
;

--Req3
SELECT  Inscription.note, Inscription.sigle, Inscription.codePermanent ,I2.codePermanent, Inscription.codeSession
FROM    Inscription, Inscription I2
where   Inscription.note = I2.note and
        Inscription.sigle = I2.sigle and
        Inscription.codeSession = I2.codeSession and
        Inscription.codePermanent != I2.codePermanent
        ;

--Req4
SELECT Etudiant.codePermanent, Etudiant.nom, Etudiant.prenom, Etudiant.datenaissance
FROM  Etudiant natural join GroupeCours natural join Inscription natural join Professeur
where Inscription.sigle = 'INF%' and
      Professeur.nom = 'TREMBLAY' and
      Inscription.codeSession = '32003' or Inscription.codeSession = '12004'
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
