ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_GenauigkeitVonTag FOREIGN KEY (GenauigkeitVonTag) REFERENCES selektion_datgenauigkeit(ID);
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_GenauigkeitVonMonat FOREIGN KEY (GenauigkeitVonMonat) REFERENCES selektion_datgenauigkeit(ID);
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_GenauigkeitVonJahr FOREIGN KEY (GenauigkeitVonJahr) REFERENCES selektion_datgenauigkeit(ID);
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_GenauigkeitVonJahrhundert FOREIGN KEY (GenauigkeitVonJahrhundert) REFERENCES selektion_datgenauigkeit(ID);
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_GenauigkeitBisTag FOREIGN KEY (GenauigkeitBisTag) REFERENCES selektion_datgenauigkeit(ID);
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_GenauigkeitBisMonat FOREIGN KEY (GenauigkeitBisMonat) REFERENCES selektion_datgenauigkeit(ID);
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_GenauigkeitBisJahr FOREIGN KEY (GenauigkeitBisJahr) REFERENCES selektion_datgenauigkeit(ID);
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_GenauigkeitBisJahrhundert FOREIGN KEY (GenauigkeitBisJahrhundert) REFERENCES selektion_datgenauigkeit(ID);

ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_GenauigkeitQuelleVonTag FOREIGN KEY (GenauigkeitQuelleVonTag) REFERENCES selektion_datgenauigkeit(ID);
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_GenauigkeitQuelleVonMonat FOREIGN KEY (GenauigkeitQuelleVonMonat) REFERENCES selektion_datgenauigkeit(ID);
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_GenauigkeitQuelleVonJahr FOREIGN KEY (GenauigkeitQuelleVonJahr) REFERENCES selektion_datgenauigkeit(ID);
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_GenauigkeitQuelleVonJahrhundert FOREIGN KEY (GenauigkeitQuelleVonJahrhundert) REFERENCES selektion_datgenauigkeit(ID);
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_GenauigkeitQuelleBisTag FOREIGN KEY (GenauigkeitQuelleBisTag) REFERENCES selektion_datgenauigkeit(ID);
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_GenauigkeitQuelleBisMonat FOREIGN KEY (GenauigkeitQuelleBisMonat) REFERENCES selektion_datgenauigkeit(ID);
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_GenauigkeitQuelleBisJahr FOREIGN KEY (GenauigkeitQuelleBisJahr) REFERENCES selektion_datgenauigkeit(ID);
ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_GenauigkeitQuelleBisJahrhundert FOREIGN KEY (GenauigkeitQuelleBisJahrhundert) REFERENCES selektion_datgenauigkeit(ID);

ALTER TABLE einzelbeleg ADD CONSTRAINT einzelbeleg_GeschlechtID FOREIGN KEY (GeschlechtID) REFERENCES selektion_geschlecht(ID);
