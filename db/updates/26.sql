ALTER TABLE einzelbeleg ADD CONSTRAINT FK_EinzelbelegKontext_1 FOREIGN KEY (KontextID) REFERENCES selektion_kontext(ID);
