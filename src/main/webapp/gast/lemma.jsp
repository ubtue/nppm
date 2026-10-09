<%@page import="de.uni_tuebingen.ub.nppm.model.MghLemma"%>
<%@page import="de.uni_tuebingen.ub.nppm.model.Einzelbeleg"%>
<%@ page import="de.uni_tuebingen.ub.nppm.db.DatenbankDB" isThreadSafe="false" %>
<%@ page import="java.util.ArrayList" isThreadSafe="false"%>
<%@ page import="java.util.Enumeration" isThreadSafe="false"%>
<%@ page import="java.util.List" isThreadSafe="false"%>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Language" isThreadSafe="false" %>
<%@ include file="../configuration.jsp"%>
<%@ include file="../functions.jsp"%>

<%@ page import="com.lowagie.text.Document" isThreadSafe="false"%>
<%@ page import="com.lowagie.text.*" isThreadSafe="false"%>
<%@ page import="com.lowagie.text.rtf.*" isThreadSafe="false"%>
<%@ page import="java.io.*" isThreadSafe="false"%>
<%@ page import="de.uni_tuebingen.ub.nppm.exception.*" isThreadSafe="false" %>

<jsp:include page="../dofilter.jsp" />

<%    int id = Integer.parseInt(request.getParameter("ID"));

    MghLemma lemma = LemmaDB.getById(id);

    if (lemma == null) {
        String msg = DatenbankDB.getLabel(session.getAttribute("Sprache").toString(),"mgh_lemma", "IdNotFoundError",String.valueOf(id));
        throw new IdNotFoundException(msg);
    } else {

        Set<Einzelbeleg> listEinzelbeleg = lemma.getEinzelbelege();

        boolean throwIdNotPublicException = true;
        boolean throwContainsInvalidStrException = true;
        for (Einzelbeleg eb : listEinzelbeleg) {
            if (eb.getQuelle() != null && eb.getQuelle().getZuVeroeffentlichen() == 1) {
                throwIdNotPublicException = false;
                break;
            }
        }

        if(!lemma.getMghLemma().contains(Constants.forbiddenLemmaSubstring)){
            throwContainsInvalidStrException = false;
        }

        if (throwIdNotPublicException) {
            String msg = DatenbankDB.getLabel(session.getAttribute("Sprache").toString(),"mgh_lemma", "NotPublicError",String.valueOf(id));
            throw new IdNotPublicException(msg);
        }

        if (throwContainsInvalidStrException) {
            String msg = DatenbankDB.getLabel(session.getAttribute("Sprache").toString(),"mgh_lemma", "LemmaInvalidString",String.valueOf(id));
            throw new ContainsInvalidStrException(msg);
        }
    }

    String formular ="mgh_lemma";

    String tableString = "einzelbeleg LEFT OUTER JOIN einzelbeleg_hatnamenkommentar ON einzelbeleg.ID=einzelbeleg_hatnamenkommentar.EinzelbelegID LEFT OUTER JOIN namenkommentar ON einzelbeleg_hatnamenkommentar.NamenkommentarID=namenkommentar.ID LEFT OUTER JOIN einzelbeleg_hatperson ON einzelbeleg.ID=einzelbeleg_hatperson.EinzelbelegID LEFT OUTER JOIN person ON einzelbeleg_hatperson.PersonID=person.ID LEFT OUTER JOIN einzelbeleg_hatmghlemma ON einzelbeleg_hatmghlemma.EinzelbelegID=einzelbeleg.ID LEFT OUTER JOIN mgh_lemma ON mgh_lemma.ID=einzelbeleg_hatmghlemma.MGHLemmaID INNER JOIN quelle ON einzelbeleg.QuelleID=quelle.ID LEFT OUTER JOIN person_hatamtstandweihe ON person.ID=person_hatamtstandweihe.PersonID LEFT OUTER JOIN selektion_amtweihe ON person_hatamtstandweihe.AmtWeiheID=selektion_amtweihe.ID LEFT OUTER JOIN person_hatethnie ON person.ID=person_hatethnie.PersonID LEFT OUTER JOIN selektion_ethnie ON person_hatethnie.EthnieID=selektion_ethnie.ID LEFT OUTER JOIN edition ON einzelbeleg.EditionID=edition.ID LEFT OUTER JOIN selektion_lebendverstorben ON einzelbeleg.LebendVerstorbenID=selektion_lebendverstorben.ID";
    String order = "";
    String export = "browse";

    List<String> conditions = new ArrayList<>();
    conditions.add("quelle.zuVeroeffentlichen=1");
    conditions.add("mgh_lemma.ID=" + id);

    List<String> fields = new ArrayList<>();
    fields.add("person.Standardname");
    fields.add("person.ID");
    fields.add("selektion_amtweihe.Bezeichnung");
    fields.add("person_hatamtstandweihe.Zeitraum");
    fields.add("selektion_ethnie.Bezeichnung");
    fields.add("namenkommentar.PLemma");
    fields.add("quelle.Bezeichnung");
    fields.add("quelle.ID");
    fields.add("edition.Titel");
    fields.add("einzelbeleg.EditionKapitel");
    fields.add("einzelbeleg.EditionSeite");
    fields.add("einzelbeleg.Belegform");
    fields.add("einzelbeleg.ID");
    fields.add("einzelbeleg.Kontext");
    fields.add("einzelbeleg.VonTag");
    fields.add("einzelbeleg.VonMonat");
    fields.add("einzelbeleg.VonJahr");
    fields.add("einzelbeleg.VonJahrhundert");
    fields.add("einzelbeleg.BisTag");
    fields.add("einzelbeleg.BisMonat");
    fields.add("einzelbeleg.BisJahr");
    fields.add("einzelbeleg.BisJahrhundert");
    fields.add("selektion_lebendverstorben.Bezeichnung");

    List<String> fieldNames = new ArrayList<>();
    fieldNames.add("person.Standardname");
    fieldNames.add("selektion_amtweihe.Bezeichnung");
    fieldNames.add("person_hatamtstandweihe.Zeitraum");
    fieldNames.add("selektion_ethnie.Bezeichnung");
    fieldNames.add("namenkommentar.PLemma");
    fieldNames.add("quelle.Bezeichnung");
    fieldNames.add("edition.Titel");
    fieldNames.add("einzelbeleg.EditionKapitel");
    fieldNames.add("einzelbeleg.EditionSeite");
    fieldNames.add("einzelbeleg.Belegform");
    fieldNames.add("einzelbeleg.Kontext");
    fieldNames.add("einzelbeleg.VonTag");
    fieldNames.add("einzelbeleg.VonMonat");
    fieldNames.add("einzelbeleg.VonJahr");
    fieldNames.add("einzelbeleg.VonJahrhundert");
    fieldNames.add("einzelbeleg.BisTag");
    fieldNames.add("einzelbeleg.BisMonat");
    fieldNames.add("einzelbeleg.BisJahr");
    fieldNames.add("einzelbeleg.BisJahrhundert");
    fieldNames.add("selektion_lebendverstorben.Bezeichnung");

    List<String> tables = new ArrayList<>();
    tables.add("mghlemma");
    tables.add("person");

   String sprache = Constants.DEFAULT_LANG;

   //till now de is the only one witch gets transfered  --> sprache = (String)session.getAttribute("Sprache");
   if (session != null && session.getAttribute("Sprache") != null)
         sprache = (String)session.getAttribute("Sprache");

   List<String> joins = new ArrayList<>();
   List<String> headlines = new ArrayList<>();
    headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Person_Standardname"));
    headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Person_AmtWeihe"));
    headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Person_AmtWeiheZeitraum"));
    headlines.add(DatenbankDB.getMapping(sprache,"freie_suche", "Ausgabe_Person_Ethnie"));
    headlines.add(DatenbankDB.getMapping(sprache,"namenkommentar", "PLemma"));
    headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Quelle"));
    headlines.add(DatenbankDB.getMapping(sprache, "quelle", "Edition"));
    headlines.add(DatenbankDB.getMapping(sprache, "einzelbeleg", "EditionKapitel"));
    headlines.add(DatenbankDB.getMapping(sprache, "einzelbeleg", "EditionSeite"));
    headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Einzelbeleg_Belegform"));
    headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Einzelbeleg_Kontext"));
    headlines.add("von T.");
    headlines.add("von M.");
    headlines.add("von J.");
    headlines.add("von Jh.");
    headlines.add("bis T.");
    headlines.add("bis M.");
    headlines.add("bis J.");
    headlines.add("bis Jh.");
    headlines.add(DatenbankDB.getMapping(sprache, "freie_suche", "Ausgabe_Einzelbeleg_Lebend"));
%>

<h3 class="ut-heading ut-heading--h3">
    <a class="ut-link" href="<%=Utils.getBaseUrl(request)%>/gast/lemma?page=stat">
        <jsp:include page="../inc.erzeugeBeschriftung.jsp">
            <jsp:param name="Formular" value="statlemma"/>
            <jsp:param name="Textfeld" value="Titel"/>
        </jsp:include>
    </a>
</h3>

<jsp:include page="layout/titel.inc.jsp">
    <jsp:param name="title" value="mgh_lemma" />
    <jsp:param name="ID" value='<%= id%>' />
    <jsp:param name="size" value="" />
    <jsp:param name="Formular" value="mgh_lemma" />
    <jsp:param name="excludeText" value= "<%= Constants.forbiddenLemmaSubstring%>" />
</jsp:include>

<!----------ID---------->
<div class="container" id="id">
    <jsp:include page="../forms/id.jsp">
        <jsp:param name="ID" value='<%=id%>'/>
        <jsp:param name="title" value="gast_mghlemma"/>
    </jsp:include>
</div>

<table class="ut-table ut-table--striped ut-table--striped--color-primary-3" style="width: 100%; table-layout: fixed; border-collapse: collapse; border-spacing: 0;">
    <tbody class="ut-table__body ">
        <tr class="ut-table__row">
            <td class="ut-table__item" style="padding-right: 0px; text-align: left; white-space: nowrap;">
                <% Language.printDatafield(out, session, "mgh_lemma", "MGHLemma");%>
            </td>
            <td class="ut-table__item" style="padding-left: 0px;">
                <jsp:include page="../inc.erzeugeFormular.jsp">
                    <jsp:param name="ID" value='<%= id%>' />
                    <jsp:param name="Formular" value="mgh_lemma" />
                    <jsp:param name="Datenfeld" value="MGHLemma" />
                    <jsp:param name="Klarlemma" value="yes"/>
                    <jsp:param name="size" value="25" />
                    <jsp:param name="Readonly" value="yes" />
                </jsp:include>
            </td>
        </tr>

        <jsp:include page="../inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value='<%= id%>' />
            <jsp:param name="Formular" value="mgh_lemma" />
            <jsp:param name="Datenfeld" value="Sprachherkunft" />
            <jsp:param name="Readonly" value="yes" />
            <jsp:param name="Darstellung" value="Tabellenzeile"/>
            <jsp:param name="Label" value='<%=Language.getDatafield(session, "mgh_lemma", "Sprachherkunft")%>'/>
        </jsp:include>

        <tr class="ut-table__row">
            <td class="ut-table__item" style="padding-right: 0px; text-align: left; white-space: nowrap;">
                <% Language.printDatafield(out, session, "mgh_lemma", "EinzelbelegRO");%>
            </td>
            <td class="ut-table__item" style="padding-left: 0px;">
                <jsp:include page="../inc.erzeugeFormular.jsp">
                    <jsp:param name="ID" value='<%= id%>' />
                    <jsp:param name="Formular" value="mgh_lemma" />
                    <jsp:param name="Datenfeld" value="EinzelbelegRODistinct" />
                    <jsp:param name="Readonly" value="yes" />
                    <jsp:param name="Ausrichtung" value="horizontal" />
                </jsp:include>
            </td>
        </tr>
    </tbody>
</table>
<!----------Treffer insgesamt---------->
<div class="container" style="overflow:auto;">
    <%@ include file="suche/ergebnisliste.jsp"%>
</div>
