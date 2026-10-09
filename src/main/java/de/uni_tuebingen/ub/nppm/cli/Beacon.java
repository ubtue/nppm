package de.uni_tuebingen.ub.nppm.cli;

import de.uni_tuebingen.ub.nppm.db.*;
import de.uni_tuebingen.ub.nppm.model.*;
import java.nio.file.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class Beacon extends AbstractBase {
    // CLI Arguments
    private static Path templatePath;
    private static Path outputPath;

    // Other internal class variables
    private final static SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");

    /**
     * Generate Beacon file
     *
     * For Example + Format Description, see:
     * https://de.wikipedia.org/wiki/Wikipedia:BEACON/Format
     */
    public static void main (String[] args) throws Exception {
        // Load Properties (DB access credentials, etc.)
        LoadProperties();

        // Process args
        switch (args.length) {
            case 2:
                templatePath = Path.of(args[0]);
                outputPath = Path.of(args[1]);
                break;
            default:
                Usage("Usage: Beacon template_path output_path");
        }

        // Parse template
        String output = Files.readString(templatePath).trim() + "\n";
        output += "#TIMESTAMP: " + dateFormatter.format(new Date()) + "\n";

        // Add Person-related data
        List<Person> persons = PersonDB.getListPublic();
        for (Person person : persons) {
            String gnd = person.getGnd();
            if (gnd != null) {
                output += gnd + "|" + person.getEinzelbeleg().size() + "\n";
            }
        }

        // Write output file
        Files.writeString(outputPath, output);

        // Exit successfully (we need this or the program will hang forever)
        System.exit(0);
    }

}
