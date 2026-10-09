package de.uni_tuebingen.ub.nppm.util;

import java.io.*;
import javax.servlet.http.*;
import javax.servlet.ServletException;
import de.uni_tuebingen.ub.nppm.model.Benutzer;
import de.uni_tuebingen.ub.nppm.db.BenutzerDB;

public class AuthHelper {
    // If you ever change this algorithm, all users must renew their password manually!
    public static String getPasswordHashingAlgorithm() {
        return "SHA-512";
    }

    public static int getPasswordSaltLength() {
        return 20;
    }

    public static int getSessionTimeout() {
        return 60*60;
    }

    public static boolean isBenutzerLogin(HttpServletRequest request) throws ServletException, IOException{
        HttpSession session = request.getSession(true);
        return session.getAttribute("BenutzerID") != null && ((Integer) session.getAttribute("BenutzerID")).intValue() > 0 && !((Boolean) session.getAttribute("Gast")).booleanValue();
    }

    public static boolean isGastLogin(HttpServletRequest request) throws ServletException, IOException {
        HttpSession session = request.getSession(true);

        if (session == null || session.getAttribute("BenutzerID") == null
                || ((Integer) session.getAttribute("BenutzerID")).intValue() <= 0) {
            return true;
        }

        Boolean isGast = (Boolean) session.getAttribute("Gast");
        return isGast != null && isGast;
    }

    public static boolean isAdminLogin(HttpServletRequest request) throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        return session.getAttribute("BenutzerID") != null && ((Integer) session.getAttribute("BenutzerID")).intValue() > 0 && ((Boolean) session.getAttribute("Administrator")).booleanValue();
    }


    public static Benutzer getBenutzer(HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession(true);
        Object BenutzerID_obj = session.getAttribute("BenutzerID");
        if (BenutzerID_obj != null) {
            Integer BenutzerID = (Integer)session.getAttribute("BenutzerID");
            if (BenutzerID > 0) {
                return BenutzerDB.getById(BenutzerID);
            }
        }
        return null;
    }

}
