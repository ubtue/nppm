package de.uni_tuebingen.ub.nppm.cli;

import java.util.Properties;
import java.io.FileInputStream;

public class AbstractBase {
    /**
     * Note: The properties are stored in a separate file right now.
     *       Later on we might try to get the information either from the
     *       existing tomcat configuration file,
     *       or merge both files together somehow.
     */
    protected static String propertiesPath = "/root/.nppm.properties";

    /**
     * Load Properties File (e.g. DB access credentials)
     */
    protected static void LoadProperties() throws Exception {
        Properties props = new Properties();
        props.load(new FileInputStream(propertiesPath));
        de.uni_tuebingen.ub.nppm.db.AbstractBase.setCliProperties(props);
    }

    /**
     * Print usage information & exit with error code
     */
    protected static void Usage(String usage) {
        System.err.println(usage);
        System.exit(1);
    }

    protected static void Log(final String message) {
        System.err.println(message);
    }
}
