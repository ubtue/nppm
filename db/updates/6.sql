#Update the Column Seite to fit to the new URLs
UPDATE datenbank_mapping SET Seite = REPLACE(Seite, '.jsp', '');
