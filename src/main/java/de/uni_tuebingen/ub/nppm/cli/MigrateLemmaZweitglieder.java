package de.uni_tuebingen.ub.nppm.cli;

import de.uni_tuebingen.ub.nppm.db.*;
import com.opencsv.*;
import java.io.FileReader;
import java.nio.file.Path;
import java.util.Map;

enum MigrationMode {
    TEST,
    LIVE
}

public class MigrateLemmaZweitglieder extends AbstractBase {

    private static Path csvPath;
    private static MigrationMode mode = MigrationMode.TEST;

    public static void main (String[] args) throws Exception {
        // Load Properties (DB access credentials, etc.)
        LoadProperties();

        // Process args
        switch (args.length) {
            case 2:
                csvPath = Path.of(args[0]);
                mode = MigrationMode.valueOf(args[1].toUpperCase());
                break;
            default:
                Usage("Usage: MigrateLemmaZweitglieder csv_path TEST|LIVE");
        }

        switch (mode) {
            case TEST:
                System.err.println("Running in TEST mode: DB will not be updated!");
                break;
            case LIVE:
                System.err.println("Running in LIVE mode: DB WILL be updated!!!");
                break;
        }

        try (FileReader fileReader = new FileReader(csvPath.toString())) {
            CSVParser parser = new CSVParserBuilder().withSeparator(';').withQuoteChar('"').build();
            CSVReaderHeaderAware reader = new CSVReaderHeaderAwareBuilder(fileReader).withCSVParser(parser).build();

            Map<String, String> row;
            while ((row = reader.readMap()) != null) {
                String zweitgliedAlt = row.get("ZweitgliedAlt");
                String zweitgliedNeu = row.get("ZweitgliedNeu");

                if (zweitgliedAlt == null || zweitgliedNeu == null) {
                    System.err.println("Skipping line due to missing columns: " + row.toString());
                } else {
                    System.err.println("Processing " + zweitgliedAlt + " => " + zweitgliedNeu);

                    // Get all existing lemmas to this Zweitglied (e.g. "berht" => "hroth~berth", "adal~berht" etc.)
                    for (var lemmaAlt : LemmaDB.getListByZweitglied(zweitgliedAlt)) {
                        System.err.println("Processing " + lemmaAlt.getDebugString() );

                        // Check whether target lemma already exists
                        String erstglied = lemmaAlt.getErstglied();
                        String lemmaNeuString = erstglied + "~" + zweitgliedNeu;

                        var lemmaNeu = LemmaDB.getByLemma(lemmaNeuString);
                        if (lemmaNeu == null) {
                            System.err.println("Target lemma does not exist: " + lemmaNeuString);
                            continue;
                        }

                        // Replace all relations from lemmaAlt to lemmaNeu
                        for (var einzelbeleg : lemmaAlt.getEinzelbelege()) {
                            System.err.println("Change lemma reference for einzelbeleg " + einzelbeleg.getDebugString() + " to " + lemmaNeu.getDebugString());

                            if (mode == MigrationMode.LIVE) {
                                EinzelbelegDB.deleteLemma(Integer.toString(einzelbeleg.getId()), Integer.toString(lemmaAlt.getId()));
                                EinzelbelegDB.insertLemma(Integer.toString(einzelbeleg.getId()), Integer.toString(lemmaNeu.getId()));
                            }
                        }

                        // Delete lemmaAlt
                        System.err.println("Deleting lemma " + lemmaAlt.getDebugString());
                        if (mode == MigrationMode.LIVE && !LemmaDB.deleteLemma(lemmaAlt.getId())) {
                            throw new Exception("Deleting lemma failed: " + lemmaAlt.getDebugString());
                        }
                    }
                }
            }
        }
    }
}
