<%@page import="java.util.Set"%>
<%@page import="de.uni_tuebingen.ub.nppm.model.Einzelbeleg"%>
<%@page import="de.uni_tuebingen.ub.nppm.model.Person"%>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Language" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.exception.*" isThreadSafe="false" %>
<%@ include file="../configuration.jsp"%>
<%@ include file="../functions.jsp" %>

<jsp:include page="../dofilter.jsp" />

<link rel="stylesheet" href="<%=Utils.getVersionedHref(request, application, "/gast/layout/person.css")%>" type="text/css">

<%    int id = Integer.parseInt(request.getParameter("ID"));
    boolean buttonOnOff = "true".equals(request.getParameter("allfields"));

    Person person = PersonDB.getById(id);
    if (person == null) {
        String msg = DatenbankDB.getLabel(session.getAttribute("Sprache").toString(),"person", "IdNotFoundError",String.valueOf(id));
        throw new IdNotFoundException(msg);

    } else {
        Set<Einzelbeleg> listEinzelbeleg = person.getEinzelbeleg();

        boolean throwException = true;

        for (Einzelbeleg eb : listEinzelbeleg) {
            if (eb.getQuelle() != null && eb.getQuelle().getZuVeroeffentlichen() == 1) {
                throwException = false;
                break;
            }
        }

        if (throwException) {
            String msg = DatenbankDB.getLabel(session.getAttribute("Sprache").toString(),"person", "NotPublicError",String.valueOf(id));
            throw new IdNotPublicException(msg);

        }
    }
%>

<jsp:include page="layout/titel.inc.jsp">
    <jsp:param name="title" value="Person" />
    <jsp:param name="ID" value='<%= id%>' />
    <jsp:param name="size" value="" />
    <jsp:param name="Formular" value="person" />
</jsp:include>

<jsp:include page="../inc.erzeugeFormular.jsp">
    <jsp:param name="ID" value='<%= id%>' />
    <jsp:param name="Formular" value="person" />
    <jsp:param name="Datenfeld" value="ID" />
    <jsp:param name="size" value="11" />
</jsp:include>

<!---------- schema.org RDFa wrapper ---------->
<div class="container" vocab="https://schema.org/" typeof="Person">

    <!----------ID---------->
    <div class="container" id="id">
        <jsp:include page="../forms/id.jsp">
            <jsp:param name="ID" value='<%=id%>'/>
            <jsp:param name="title" value="gast_person"/>
        </jsp:include>
    </div>

    <!----------Prosopographisches---------->

    <!----------Has to be put inside of database/table: "datenbank_texte" -- (not present till now)---------->
    <div class="flex-header">
        <h3 class="ut-heading ut-heading--h3">
            <% Language.printTextfield(out, session, "person", "Prosopographical");%>
        </h3>
        <button class="ut-btn ut-btn--color-primary-4" id="toggleButton" style="margin-top: -8px;" onclick="toggleAllFields()">
            <% Language.getTextfield(session, "fields", "On"); %>
        </button>
    </div>

    <table class="ut-table ut-table--striped ut-table--striped--color-primary-3">
        <tbody class="ut-table__body">
            <tr class="ut-table__row">
                <td class="ut-table__item ut-table__body__item"><%= Language.getDatafield(session, "person", "Standardname")%> </td>
                <td class="ut-table__item ut-table__body__item">
                    <jsp:include page="../inc.erzeugeFormular.jsp">
                        <jsp:param name="ID" value='<%= id%>' />
                        <jsp:param name="Formular" value="person" />
                        <jsp:param name="Datenfeld" value="Standardname" />
                        <jsp:param name="size" value="50" />
                        <jsp:param name="Readonly" value="yes" />
                    </jsp:include>

                    <jsp:include page="../inc.erzeugeFormular.jsp">
                        <jsp:param name="ID" value='<%=id%>' />
                        <jsp:param name="Formular" value="person" />
                        <jsp:param name="Datenfeld" value="GNDLink" />
                    </jsp:include>
                     &nbsp;
                    <jsp:include page="../inc.erzeugeFormular.jsp">
                        <jsp:param name="ID" value='<%=id%>' />
                        <jsp:param name="Formular" value="person" />
                        <jsp:param name="Datenfeld" value="WikidataLink" />
                    </jsp:include>
                </td>
            </tr>

            <jsp:include page="../inc.erzeugeFormular.jsp">
                <jsp:param name="ID" value='<%= id%>' />
                <jsp:param name="Formular" value="person" />
                <jsp:param name="Datenfeld" value="Varianten" />
                <jsp:param name="size" value="50" />
                <jsp:param name="Readonly" value="yes" />
                <jsp:param name="Darstellung" value="Tabellenzeile"/>
                <jsp:param name="Label" value='<%=Language.getDatafield(session, "person", "Varianten")%>'/>
                <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
            </jsp:include>

            <jsp:include page="../inc.erzeugeFormular.jsp">
                <jsp:param name="ID" value='<%= id%>' />
                <jsp:param name="Formular" value="person" />
                <jsp:param name="Datenfeld" value="Geschlecht" />
                <jsp:param name="Readonly" value="yes" />
                <jsp:param name="Darstellung" value="Tabellenzeile"/>
                <jsp:param name="Label" value='<%=Language.getDatafield(session, "person", "Geschlecht")%>'/>
                <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
            </jsp:include>

            <jsp:include page="../inc.erzeugeFormular.jsp">
                <jsp:param name="ID" value='<%= id%>' />
                <jsp:param name="Formular" value="gast_person" />
                <jsp:param name="Datenfeld" value="Identifizierungsproblem" />
                <jsp:param name="cols" value="40" />
                <jsp:param name="rows" value="5" />
                <jsp:param name="Readonly" value="yes" />
                <jsp:param name="Darstellung" value="Tabellenzeile"/>
                <jsp:param name="Label" value='<%=Language.getDatafield(session, "gast_person", "Identifizierungsproblem")%>'/>
                <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
            </jsp:include>

            <jsp:include page="../inc.erzeugeFormular.jsp">
                <jsp:param name="ID" value='<%= id%>' />
                <jsp:param name="Formular" value="person" />
                <jsp:param name="Datenfeld" value="Stand" />
                <jsp:param name="Readonly" value="yes" />
                <jsp:param name="Darstellung" value="Tabellenzeile"/>
                <jsp:param name="Label" value='<%=Language.getDatafield(session, "person", "Stand")%>'/>
                <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
            </jsp:include>

            <jsp:include page="../inc.erzeugeFormular.jsp">
                <jsp:param name="ID" value='<%= id%>' />
                <jsp:param name="Formular" value="person" />
                <jsp:param name="Datenfeld" value="AmtWeihe" />
                <jsp:param name="Readonly" value="yes" />
                <jsp:param name="Darstellung" value="Tabellenzeile"/>
                <jsp:param name="Label" value='<%=Language.getDatafield(session, "person", "AmtWeihe")%>'/>
                <jsp:param name="CountRow" value="noCount" />
                <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
            </jsp:include>

            <jsp:include page="../inc.erzeugeFormular.jsp">
                <jsp:param name="ID" value='<%= id%>' />
                <jsp:param name="Formular" value="person" />
                <jsp:param name="Datenfeld" value="Ethnie" />
                <jsp:param name="Readonly" value="yes" />
                <jsp:param name="Darstellung" value="Tabellenzeile"/>
                <jsp:param name="Label" value='<%=Language.getDatafield(session, "person", "Ethnie")%>'/>
                <jsp:param name="CountRow" value="noCount" />
                <jsp:param name="allfields" value='<%= request.getParameter("allfields") %>'/>
            </jsp:include>

            <%
                List<Object[]> resultList = ModulIncDB.getListPersonenVerwandte(String.valueOf(id));

                if (buttonOnOff || (resultList != null && !resultList.isEmpty())) {
            %>

            <tr class="ut-table__row">
                <th class="ut-table__item ut-table__body__item"><% Language.printTextfield(out, session, "person", "TabVerwandte");%></th>
                <td class="ut-table__item ut-table__body__item">
                    <jsp:include page="../inc.modul.jsp">
                        <jsp:param name="ID" value='<%= id%>' />
                        <jsp:param name="Formular" value="person" />
                        <jsp:param name="Modul" value="Verwandte" />
                        <jsp:param name="Readonly" value="yes" />
                    </jsp:include>
                </td>
            </tr>

            <%
                }
            %>
        </tbody>
    </table>
</div>

<!----------Einzelbelege---------->
<h3 class="ut-heading ut-heading--h3"><% Language.printTextfield(out, session, "person", "TabEinzelbelege");%></h3>
<jsp:include page="../inc.modul.jsp">
    <jsp:param name="ID" value='<%= id%>' />
    <jsp:param name="Formular" value="person" />
    <jsp:param name="Modul" value="nachweiseRO" />
</jsp:include>

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
