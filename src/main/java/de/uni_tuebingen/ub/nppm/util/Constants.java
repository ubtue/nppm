package de.uni_tuebingen.ub.nppm.util;

public class Constants {
    public static final String USER_AGENT = "NPPMBot (https://nppm.ub.uni-tuebingen.de)";

    public static final Integer UNDEFINED_ID = -2;
    public static final Integer NEW_ITEM = -1;
    //Fallback language if no translation is found
    public static final String DEFAULT_LANG = "gb";
    //Is used in SharedHtmlServlet if no DEFAULT_LANG content is available, because most of the content is translated in german
    public static String FALLBACK_LANG = "de";
    //Statisctics
    public static final Integer RECORDS_PER_PAGE = 100;
    //Exclude Lemmas in Frontend that contains [???]
    public static final String forbiddenLemmaSubstring = "[???]";
}
