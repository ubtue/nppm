

1) Liste mir alle Zeugenlisten aus Urkunden eines Bestimmten Zeitraums auf
   (in der Reihenfolge, in der die Zeugen in den Urkunden stehen)

SELECT urkunde_betreff.Betreff, person.ID, person.Standardname, selektion_funktion.Bezeichnung, einzelbeleg_hatfunktion.Nummer
FROM urkunde LEFT JOIN urkunde_betreff ON urkunde.ID=urkunde_betreff.UrkundeID LEFT JOIN einzelbeleg ON urkunde.QuelleID=einzelbeleg.QuelleID INNER JOIN einzelbeleg_hatperson ON einzelbeleg.ID=einzelbeleg_hatperson.EinzelbelegID LEFT JOIN person ON person.ID=einzelbeleg_hatperson.PersonID LEFT JOIN einzelbeleg_hatfunktion ON einzelbeleg.ID=einzelbeleg_hatfunktion.EinzelbelegID LEFT JOIN selektion_funktion ON selektion_funktion.ID=einzelbeleg_hatfunktion.FunktionID
WHERE selektion_funktion.Bezeichnung LIKE "Zeug%"
ORDER BY urkunde_betreff.Betreff ASC, einzelbeleg_hatfunktion.Nummer ASC, person.Standardname ASC






5) Liste mir alle Varianten zu allen Personennamen aus ein und derselben Hanschrift auf
   (egal um welche Quelle es sich dabei handelt)

SELECT handschrift.Bibliothekssignatur, einzelbeleg.Belegform, einzelbeleg_textkritik.Variante
FROM handschrift LEFT JOIN handschrift_ueberlieferung ON handschrift.ID=handschrift_ueberlieferung.HandschriftID INNER JOIN einzelbeleg ON einzelbeleg.QuelleID=handschrift_ueberlieferung.QuelleID INNER JOIN einzelbeleg_textkritik ON einzelbeleg.ID=einzelbeleg_textkritik.EinzelbelegID
WHERE handschrift.ID = 29
ORDER BY handschrift.Bibliothekssignatur ASC