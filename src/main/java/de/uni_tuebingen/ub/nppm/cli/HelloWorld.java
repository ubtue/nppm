package de.uni_tuebingen.ub.nppm.cli;

import de.uni_tuebingen.ub.nppm.db.PersonDB;
import de.uni_tuebingen.ub.nppm.model.Person;
import de.uni_tuebingen.ub.nppm.util.Constants;

/**
 * Hello World CLI Example
 *
 * This is just a first test to prove that classes inside a WAR file
 * can be run via command line.
 *
 * To call the main function via CLI, execute the following shell commands:
 * - `cd /var/lib/tomcat10/webapps/nppm/WEB-INF`
 * - `java -classpath "lib/*:classes/." de.uni_tuebingen.ub.nppm.cli.HelloWorld`
 *
 * Be aware that everytime you rebuild / redeploy the project, your tomcat
 * might be restarted, so the nppm/WEB-INF directory will be recreated
 * and you have to change the working directory again so the call works.
 *
 */
public class HelloWorld extends AbstractBase {
    public static void main (String[] args) throws Exception {
        System.out.println("Hello World");
        System.out.println("Default Language is: " + Constants.DEFAULT_LANG);

        System.out.println("Loading Properties file...");
        LoadProperties();
        System.out.println("Finished Loading Properties file");

        System.out.println("Loading First Public Person...");
        Person person = PersonDB.getFirstPublicPerson();
        System.out.println("First Public Person is: " + person.getStandardname());

        // Without this line, the program will just hang and never terminate
        System.exit(0);
    }
}
