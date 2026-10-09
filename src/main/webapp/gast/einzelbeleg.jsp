<%@page import="java.util.Set"%>
<%@page import="de.uni_tuebingen.ub.nppm.exception.*"%>
<%@page import="de.uni_tuebingen.ub.nppm.model.Einzelbeleg"%>
<%@page import="de.uni_tuebingen.ub.nppm.model.MghLemma"%>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Language" isThreadSafe="false" %>
<%@ include file="../configuration.jsp" %>
<%@ include file="../functions.jsp" %>

<jsp:include page="../dofilter.jsp" />

<link rel="stylesheet" href="<%=Utils.getVersionedHref(request, application, "/gast/layout/einzelbeleg.css")%>" type="text/css">

<%
    int id = Integer.parseInt(request.getParameter("ID"));
    boolean buttonOnOff = "true".equals(request.getParameter("allfields"));

    Einzelbeleg einzelbeleg = EinzelbelegDB.getById(id);

    if (einzelbeleg == null) {
        String msg = DatenbankDB.getLabel(session.getAttribute("Sprache").toString(), "einzelbeleg", "IdNotFoundError", String.valueOf(id));
        throw new IdNotFoundException(msg);
    }

    if (einzelbeleg.getQuelle() == null || einzelbeleg.getQuelle().getZuVeroeffentlichen() != 1) {
        String msg = DatenbankDB.getLabel(session.getAttribute("Sprache").toString(), "einzelbeleg", "NotPublicError", String.valueOf(id));
        throw new IdNotPublicException(msg);
    }

    boolean throwContainsInvalidStrException = false;

    for (MghLemma lemmaObj : einzelbeleg.getMghLemma()) {
        String text = lemmaObj.getMghLemma();
        if (text != null && text.contains(Constants.forbiddenLemmaSubstring)) {
            throwContainsInvalidStrException = true;
            break;
        }
    }

    if (throwContainsInvalidStrException) {
        String msg = DatenbankDB.getLabel(session.getAttribute("Sprache").toString(),"einzelbeleg","EinzelbelegInvalidLemmaString",String.valueOf(einzelbeleg.getId()));
        throw new ContainsInvalidStrException(msg);
    }
%>

<jsp:include page="layout/titel.inc.jsp">
    <jsp:param name="title" value="Einzelbeleg" />
    <jsp:param name="ID" value='<%= id%>' />
    <jsp:param name="size" value="" />
    <jsp:param name="Formular" value="einzelbeleg" />
</jsp:include>

<jsp:include page="../inc.erzeugeFormular.jsp">
    <jsp:param name="ID" value='<%= id%>'/>
    <jsp:param name="Formular" value="einzelbeleg"/>
    <jsp:param name="Datenfeld" value="ID"/>
    <jsp:param name="size" value="11"/>
</jsp:include>

<!----------ID---------->
<div class="container" id="id">
    <jsp:include page="../forms/id.jsp">
        <jsp:param name="ID" value='<%=id%>'/>
        <jsp:param name="title" value="gast_einzelbeleg"/>
    </jsp:include>
</div>

<!----------Belegstelle---------->
<div class="flex-header">
    <h3 class="ut-heading ut-heading--h3">
        <% Language.printTextfield(out, session, "einzelbeleg", "TabBelegstelle");%>
    </h3>
    <button class="ut-btn ut-btn--color-primary-4" id="toggleButton" style="margin-top: -8px;" onclick="toggleAllFields()">
        <% Language.getTextfield(session, "fields", "On"); %>
    </button>
</div>

<div class="myTable">
<table class="ut-table ut-table--striped ut-table--striped--color-primary-3">
    <tbody class="ut-table__body ">
        <jsp:include page="../inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value='<%= id%>'/>
            <jsp:param name="Formular" value="einzelbeleg"/>
            <jsp:param name="Datenfeld" value="PersonRO"/>
            <jsp:param name="Readonly" value="yes"/>
            <jsp:param name="Darstellung" value="Tabellenzeile"/>
            <jsp:param name="Label" value='<%=Language.getDatafield(session, "einzelbeleg", "PersonRO")%>'/>
            <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
        </jsp:include>

        <tr class="ut-table__row">
            <td class="ut-table__item ut-table__body__item"><% Language.printDatafield(out, session, "einzelbeleg", "Belegform");%></td>
            <td class="ut-table__item ut-table__body__item">
                <span style="display: inline-flex; align-items: center;">
                    <jsp:include page="../inc.erzeugeFormular.jsp">
                        <jsp:param name="ID" value='<%= id%>'/>
                        <jsp:param name="Formular" value="einzelbeleg"/>
                        <jsp:param name="Datenfeld" value="Belegform"/>
                        <jsp:param name="size" value="50"/>
                        <jsp:param name="Readonly" value="yes"/>
                    </jsp:include>
                </span>
                <div>
                    <jsp:include page="../inc.erzeugeFormular.jsp">
                        <jsp:param name="ID" value='<%= id%>'/>
                        <jsp:param name="Formular" value="einzelbeleg"/>
                        <jsp:param name="Datenfeld" value="Griechisch"/>
                        <jsp:param name="size" value="50"/>
                        <jsp:param name="Readonly" value="yes"/>
                    </jsp:include>
                </div>
            </td>
        </tr>
        <!--
        <jsp:include page="../inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value='<%= id%>'/>
            <jsp:param name="Formular" value="einzelbeleg"/>
            <jsp:param name="Datenfeld" value="LemmaRO"/>
            <jsp:param name="Readonly" value="yes"/>
            <jsp:param name="Darstellung" value="Tabellenzeile"/>
            <jsp:param name="Label" value='<%=Language.getDatafield(session, "einzelbeleg", "LemmaRO")%>'/>
            <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
        </jsp:include>
        -->
        <jsp:include page="../inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value='<%= id%>'/>
            <jsp:param name="Formular" value="einzelbeleg"/>
            <jsp:param name="Datenfeld" value="MGHLemmaRO"/>
            <jsp:param name="Readonly" value="yes"/>
            <jsp:param name="Darstellung" value="Tabellenzeile"/>
            <jsp:param name="Label" value='<%=Language.getDatafield(session, "einzelbeleg", "MGHLemmaRO")%>'/>
            <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
        </jsp:include>

        <jsp:include page="../inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value='<%= id%>'/>
            <jsp:param name="Formular" value="einzelbeleg"/>
            <jsp:param name="Datenfeld" value="Kontext"/>
            <jsp:param name="cols" value="40"/>
            <jsp:param name="rows" value="5"/>
            <jsp:param name="Readonly" value="yes"/>
            <jsp:param name="Darstellung" value="Tabellenzeile"/>
            <jsp:param name="Label" value='<%=Language.getDatafield(session, "einzelbeleg", "Kontext")%>'/>
            <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
        </jsp:include>

        <jsp:include page="../inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value='<%= id%>'/>
            <jsp:param name="Formular" value="einzelbeleg"/>
            <jsp:param name="Datenfeld" value="KontextSelektion"/>
            <jsp:param name="Readonly" value="yes"/>
            <jsp:param name="Darstellung" value="Tabellenzeile"/>
            <jsp:param name="Label" value='<%=Language.getDatafield(session, "einzelbeleg", "KontextSelektion")%>'/>
            <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
        </jsp:include>

        <jsp:include page="../inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value='<%= id%>'/>
            <jsp:param name="Formular" value="einzelbeleg"/>
            <jsp:param name="Datenfeld" value="KritikSelektion"/>
            <jsp:param name="Readonly" value="yes"/>
            <jsp:param name="Darstellung" value="Tabellenzeile"/>
            <jsp:param name="Label" value='<%=Language.getDatafield(session, "einzelbeleg", "KritikSelektion")%>'/>
            <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
        </jsp:include>

        <jsp:include page="../inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value='<%= id%>'/>
            <jsp:param name="Formular" value="einzelbeleg"/>
            <jsp:param name="Datenfeld" value="LebendVerstorben"/>
            <jsp:param name="Readonly" value="yes"/>
            <jsp:param name="Darstellung" value="Tabellenzeile"/>
            <jsp:param name="Label" value='<%=Language.getDatafield(session, "einzelbeleg", "LebendVerstorben")%>'/>
            <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
        </jsp:include>

        <jsp:include page="../inc.erzeugeFormular.jsp">
            <jsp:param name="Formular" value="gast_einzelbeleg"/>
            <jsp:param name="ID" value='<%= id%>'/>
            <jsp:param name="Datenfeld" value="Datierung"/>
            <jsp:param name="Readonly" value="yes"/>
            <jsp:param name="Darstellung" value="Tabellenzeile"/>
            <jsp:param name="Label" value='<%=Language.getDatafield(session, "gast_einzelbeleg", "Datierung")%>'/>
            <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
        </jsp:include>

        <%
            // Pr�fe das Attribut
            Boolean displayDatierung = (Boolean) request.getAttribute("displayDatierungUngewiss");
            if (displayDatierung != null && displayDatierung) {
        %>

        <jsp:include page="../inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value='<%= id%>'/>
            <jsp:param name="Formular" value="einzelbeleg"/>
            <jsp:param name="Datenfeld" value="DatierungUngewiss"/>
            <jsp:param name="Readonly" value="yes"/>
            <jsp:param name="Darstellung" value="Tabellenzeile"/>
            <jsp:param name="Label" value='<%=Language.getDatafield(session, "einzelbeleg", "DatierungUngewiss")%>'/>
            <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
        </jsp:include>

        <%
            }
        %>

        <jsp:include page="../inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value='<%= id%>'/>
            <jsp:param name="Formular" value="einzelbeleg"/>
            <jsp:param name="Datenfeld" value="KommentarDatierung"/>
            <jsp:param name="cols" value="40"/>
            <jsp:param name="rows" value="5"/>
            <jsp:param name="Readonly" value="yes"/>
            <jsp:param name="Darstellung" value="Tabellenzeile"/>
            <jsp:param name="Label" value='<%=Language.getDatafield(session, "einzelbeleg", "KommentarDatierung")%>'/>
            <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
        </jsp:include>

        <jsp:include page="../inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value='<%= id%>'/>
            <jsp:param name="Formular" value="einzelbeleg"/>
            <jsp:param name="Datenfeld" value="Konvent"/>
            <jsp:param name="Readonly" value="yes"/>
            <jsp:param name="Darstellung" value="Tabellenzeile"/>
            <jsp:param name="Label" value='<%=Language.getDatafield(session, "einzelbeleg", "Konvent")%>'/>
            <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
        </jsp:include>

        <jsp:include page="../inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value='<%= id%>'/>
            <jsp:param name="Formular" value="einzelbeleg"/>
            <jsp:param name="Datenfeld" value="PalAbgrenzung"/>
            <jsp:param name="Readonly" value="yes"/>
            <jsp:param name="Darstellung" value="Tabellenzeile"/>
            <jsp:param name="Label" value='<%=Language.getDatafield(session, "einzelbeleg", "PalAbgrenzung")%>'/>
            <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
        </jsp:include>

        <jsp:include page="../inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value='<%= id%>'/>
            <jsp:param name="Formular" value="einzelbeleg"/>
            <jsp:param name="Datenfeld" value="InhAbgrenzung"/>
            <jsp:param name="Readonly" value="yes"/>
            <jsp:param name="Darstellung" value="Tabellenzeile"/>
            <jsp:param name="Label" value='<%=Language.getDatafield(session, "einzelbeleg", "InhAbgrenzung")%>'/>
            <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
        </jsp:include>

        <jsp:include page="../inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value='<%= id%>'/>
            <jsp:param name="Formular" value="einzelbeleg"/>
            <jsp:param name="Datenfeld" value="NrInStrukt"/>
            <jsp:param name="Readonly" value="yes"/>
            <jsp:param name="Darstellung" value="Tabellenzeile"/>
            <jsp:param name="Label" value='<%=Language.getDatafield(session, "einzelbeleg", "NrInStrukt")%>'/>
            <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
        </jsp:include>

        <jsp:include page="../inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value='<%= id%>'/>
            <jsp:param name="Formular" value="einzelbeleg"/>
            <jsp:param name="Datenfeld" value="Seite"/>
            <jsp:param name="Readonly" value="yes"/>
            <jsp:param name="Darstellung" value="Tabellenzeile"/>
            <jsp:param name="Label" value='<%=Language.getDatafield(session, "einzelbeleg", "Seite")%>'/>
            <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
        </jsp:include>

        <jsp:include page="../inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value='<%= id%>'/>
            <jsp:param name="Formular" value="einzelbeleg"/>
            <jsp:param name="Datenfeld" value="Raster"/>
            <jsp:param name="Readonly" value="yes"/>
            <jsp:param name="Darstellung" value="Tabellenzeile"/>
            <jsp:param name="Label" value='<%=Language.getDatafield(session, "einzelbeleg", "Raster")%>'/>
            <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
        </jsp:include>

        <jsp:include page="../inc.erzeugeFormular.jsp">
            <jsp:param name="ID" value='<%= id%>'/>
            <jsp:param name="Formular" value="einzelbeleg"/>
            <jsp:param name="Datenfeld" value="Schreiber"/>
            <jsp:param name="Readonly" value="yes"/>
            <jsp:param name="Darstellung" value="Tabellenzeile"/>
            <jsp:param name="Label" value='<%=Language.getDatafield(session, "einzelbeleg", "Schreiber")%>'/>
            <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
        </jsp:include>
    </tbody>
</table>

<!----------Quelle---------->
<h3 class="ut-heading ut-heading--h3"><% Language.printTextfield(out, session, "einzelbeleg", "BoxQuelle"); %></h3>
<table class="ut-table ut-table--striped ut-table--striped--color-primary-3">
    <tr class="ut-table__row">
        <td class="ut-table__item ut-table__body__item"><%=Language.getDatafield(session, "einzelbeleg", "QuelleLink")%></td>
        <td class="ut-table__item ut-table__body__item">
            <jsp:include page="../inc.erzeugeFormular.jsp">
                <jsp:param name="ID" value='<%= id%>'/>
                <jsp:param name="Formular" value="einzelbeleg"/>
                <jsp:param name="Datenfeld" value="QuelleLink"/>
            </jsp:include>
        </td>
    </tr>

    <jsp:include page="../inc.erzeugeFormular.jsp">
        <jsp:param name="ID" value='<%= id%>'/>
        <jsp:param name="Formular" value="gast_einzelbeleg"/>
        <jsp:param name="Datenfeld" value="Edition"/>
        <jsp:param name="Readonly" value="yes"/>
        <jsp:param name="Darstellung" value="Tabellenzeile"/>
        <jsp:param name="Label" value='<%=Language.getDatafield(session, "gast_einzelbeleg", "Edition")%>'/>
        <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
    </jsp:include>

    <jsp:include page="../inc.erzeugeFormular.jsp">
        <jsp:param name="ID" value='<%= id%>'/>
        <jsp:param name="Formular" value="gast_einzelbeleg"/>
        <jsp:param name="Datenfeld" value="EditionKapitel"/>
        <jsp:param name="size" value="20"/>
        <jsp:param name="Readonly" value="yes"/>
        <jsp:param name="Darstellung" value="Tabellenzeile"/>
        <jsp:param name="Label" value='<%=Language.getDatafield(session, "gast_einzelbeleg", "EditionKapitel")%>'/>
        <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
    </jsp:include>

    <jsp:include page="../inc.erzeugeFormular.jsp">
        <jsp:param name="ID" value='<%= id%>'/>
        <jsp:param name="Formular" value="gast_einzelbeleg"/>
        <jsp:param name="Datenfeld" value="EditionSeite"/>
        <jsp:param name="size" value="20"/>
        <jsp:param name="Readonly" value="yes"/>
        <jsp:param name="Darstellung" value="Tabellenzeile"/>
        <jsp:param name="Label" value='<%=Language.getDatafield(session, "gast_einzelbeleg", "EditionSeite")%>'/>
        <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
    </jsp:include>

    <jsp:include page="../inc.erzeugeFormular.jsp">
        <jsp:param name="Formular" value="gast_einzelbeleg"/>
        <jsp:param name="ID" value='<%= id%>'/>
        <jsp:param name="Datenfeld" value="QuelleDatierung"/>
        <jsp:param name="Readonly" value="yes"/>
        <jsp:param name="Darstellung" value="Tabellenzeile"/>
        <jsp:param name="Label" value='<%=Language.getDatafield(session, "einzelbeleg", "QuelleDatierung")%>'/>
        <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
    </jsp:include>
</table>
</div>
<!----------Textkritik---------->
<%
    List<Object[]> resultList = ModulIncDB.getListEinzelbelegTextkritik(String.valueOf(id));

    if (buttonOnOff || (resultList != null && !resultList.isEmpty())) {
%>
<div class="container">
    <h3 class="ut-heading ut-heading--h3"><% Language.printTextfield(out, session, "einzelbeleg", "TabTextkritik");%></h3>
    <jsp:include page="../inc.modul.jsp">
        <jsp:param name="ID" value='<%= id%>'/>
        <jsp:param name="Formular" value="einzelbeleg"/>
        <jsp:param name="Modul" value="lesartenRO"/>
    </jsp:include>
</div>

<%
    }
%>

<script>
    function toggleAllFields() {
        let url = new URL(window.location.href);
        let params = url.searchParams;

        if (params.get("allfields") === "true") {
            params.delete("allfields");
        } else {
            params.set("allfields", "true");
        }

        window.location.href = url.toString();
    }

    window.onload = function () {
        let params = new URLSearchParams(window.location.search);
        let button = document.getElementById("toggleButton");
        let on = '<%= Language.getTextfield(session, "fields", "Off") %>';
        let off = '<%= Language.getTextfield(session, "fields", "On") %>';

        if (params.get("allfields") === "true") {
            button.textContent = on;
        } else {
            button.textContent = off;
        }
    };
</script>
