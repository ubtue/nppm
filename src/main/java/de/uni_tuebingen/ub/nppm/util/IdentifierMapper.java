package de.uni_tuebingen.ub.nppm.util;

import de.uni_tuebingen.ub.nppm.db.EinzelbelegDB;
import de.uni_tuebingen.ub.nppm.db.LemmaDB;
import de.uni_tuebingen.ub.nppm.db.NamenKommentarDB;
import de.uni_tuebingen.ub.nppm.db.PersonDB;
import de.uni_tuebingen.ub.nppm.db.QuelleDB;
import de.uni_tuebingen.ub.nppm.exception.*;
import de.uni_tuebingen.ub.nppm.model.Einzelbeleg;
import de.uni_tuebingen.ub.nppm.model.MghLemma;
import de.uni_tuebingen.ub.nppm.model.NamenKommentar;
import de.uni_tuebingen.ub.nppm.model.Person;
import de.uni_tuebingen.ub.nppm.model.Quelle;

public class IdentifierMapper {
    public static Object getModelByIdentifier(final String identifier) throws Exception, IdNotPublicException {
        Object ret = null;
        // Map identifier to Model Class
        if (identifier.startsWith("M")) {
            ret = LemmaDB.getById(Integer.valueOf(identifier.substring(1)),MghLemma.class);
        } else if (identifier.startsWith("N")) {
            ret = NamenKommentarDB.getById(Integer.valueOf(identifier.substring(1)),NamenKommentar.class);
        } else if (identifier.startsWith("B")) {
            ret = EinzelbelegDB.getById(Integer.valueOf(identifier.substring(1)),Einzelbeleg.class);
            //check if einzelbeleg is zuVeröffentlichen
            if(ret != null){
                Quelle q = ((Einzelbeleg)ret).getQuelle();
                if(q != null && (q.getZuVeroeffentlichen() == null || q.getZuVeroeffentlichen() != 1)) {
                    throw new IdNotPublicException("Einzelbeleg ID " + identifier + " ist nicht zu veröffentlichen");
                }
            }
        } else if (identifier.startsWith("P")) {
            ret = PersonDB.getById(Integer.valueOf(identifier.substring(1)),Person.class);
        } else if (identifier.startsWith("Q")) {
            ret = QuelleDB.getById(Integer.valueOf(identifier.substring(1)),Quelle.class);
            if (ret != null){
                Quelle q = (Quelle)ret;
                if (q.getZuVeroeffentlichen() != null && q.getZuVeroeffentlichen() != 1){
                    throw new IdNotPublicException("Quelle ID " + identifier + " ist nicht zu veröffentlichen");
                }
            }
        }
        return ret;
    }

    public static String getFormByPrefix(char prefix) {
         switch (prefix) {
            case 'B':
                return "einzelbeleg";
            case 'P':
                return "person";
            case 'N':
                return "namenkommentar";
            case 'Q':
                return "quelle";
            case 'E':
                return "edition";
            case 'T':
                return "handschrift";
            case 'M':
                return "lemma";
        }
        return null;
    }

    public static String getFormByIdentifier(final String identifier) throws IdInvalidException {
        validateIdentifier(identifier);
        return getFormByPrefix(identifier.charAt(0));
    }

    public static String getPrefixByForm(final String form) {
        switch (form) {
            case "einzelbeleg":
                return "B";
            case "person":
                return "P";
            case "namenkommentar":
                return "N";
            case "quelle":
                return "Q";
            case "edition":
                return "E";
            case "handschrift":
                return "T";
            case "lemma":
            case "mgh_lemma":
                return "M";
        }

        return null;
    }

    public static boolean isValidIdentifier(final String identifier) {
        return !identifier.isBlank() && identifier.matches("^[A-Z][0-9]+$");
    }

    public static void validateIdentifier(final String identifier) throws IdInvalidException {
        if (!isValidIdentifier(identifier)) {
            throw new IdInvalidException();
        }
    }
}
