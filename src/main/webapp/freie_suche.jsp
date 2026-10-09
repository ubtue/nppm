<%@ page import="de.uni_tuebingen.ub.nppm.db.DatenbankDB"%>
<%@ page import="java.util.Date" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.*" isThreadSafe="false" %>
<%@ page import="de.uni_tuebingen.ub.nppm.util.Filter" isThreadSafe="false" %>
<%@ include file="configuration.jsp" %>
<%@ include file="functions.jsp" %>


<%
    int id = Constants.UNDEFINED_ID;
    String formular = "freie_suche";
    Filter.setFilter(request, formular, out);
    Language.setLanguage(request);
%>

<div>
<style>
	#truncate-hint {
		font-size: small;
		right: 0;
	    position: absolute;
	    width: 240px;
	}
</style>

    <script type="text/javascript">
    $(function() { // when document has loaded

    	// replace [help] with link to help >>
    	var p = $('#truncate-hint');
        var baseUrl = "<%= Utils.getBaseUrl(request) %>";

        p.html(p.text().trim().replace(/\[(.+)\]/, "<a href='" + baseUrl + "/gast/infos?sharedHtml=hilfe'>$1</a>"));
    	// <<

        var i = 4; // check how many input exists on the document and add 1 for the add command to work
        $('a#add').click(function() { // when you click the add link
        if(i<15){
<%
   out.print("$('<tr><th>Dann nach</th><td>");
   out.print("<select name=\"order'+i+'\">");
   out.print("  <option value=\"-1\">--</option>");

     String sprache = Constants.DEFAULT_LANG;
  if (session != null && session.getAttribute("Sprache") != null)
    sprache = (String)session.getAttribute("Sprache");

    List<Object[]> res = DatenbankDB.getResult("SELECT Textfeld, "+sprache+" FROM datenbank_texte WHERE Formular='freie_suche' AND Textfeld LIKE \"Order%\"");
    for(Object[] val : res){
        String textfeld = val[0].toString();
        String lang = val[1].toString();

        out.print("<option test=\"test\" value=\"" + textfeld +"\">");
        out.print(lang);
        out.print("</option>");
    }

    out.print("</select>");

    out.print("<input type=\"radio\" name=\"order'+i+'ASCDESC\" value=\"ASC\" checked/>");
    out.print("aufsteigend");
    out.print(" &nbsp;");
    out.print(" <input type=\"radio\" name=\"order'+i+'ASCDESC\" value=\"DESC\" />");
 	out.print("absteigend");
    out.print("<br>Zeitraum (nur für Datierung): <input type=\"text\" name=\"order'+i+'zeit\" />  ");



    out.print("</td></tr>').appendTo('div#tab3 div#main table tbody');");
%>
    // if you have the input inside a form, change body to form in the appendTo
            i++; //after the click i will be i = 3 if you click again i will be i = 4
      }
     });
            });
    </script>

    <noscript></noscript>
</div>

    <jsp:include page="layout/titel.suche.jsp" />

    <FORM method="POST" action="suchergebnis">
      <input type="hidden" name="form" value="freie_suche">

<!-- ##### SUCHFELDER ##### -->
      <div id="form">
        <div id="tab1">
          <div id="header">
            <ul id="primary">
              <li>
                <span>
                    <% Language.printTextfield(out,session, formular,"Tab1");%>
                </span>
              </li>
              <li>
                <a href="javascript:onoff('tab2','tab1');">
                    <% Language.printTextfield(out,session, formular,"Tab2");%>
                </a>
              </li>
              <li>
                <a href="javascript:onoff('tab3','tab1');">
                    <% Language.printTextfield(out,session, formular,"Tab3");%>
                </a>
              </li>
              <li>
                <a href="javascript:onoff('tab4','tab1');">
                    <% Language.printTextfield(out,session, formular,"Tab4");%>
                </a>
              </li>
            </ul>
          </div>
          <div id="main">
            <p id="truncate-hint">
                <% Language.printTextfield(out,session, formular,"TruncateHint");%>
            </p>
            <h3>
                <% Language.printTextfield(out,session, formular,"Ueberschrift1");%>
            </h3>
            <table>
              <tbody>
                <tr>
                  <th width="200">
                    <% Language.printTextfield(out, session, "jump", "JumpTo");%>
                  </th>
                  <td width="450">
                    <span></span><input type="text" title="NPPM-ID" placeholder="NPPM-ID" name="jumpValueID" size="5">
     <input type="submit" name="jumpID" value="&gt;">
                  </td>
                </tr>
                <tr><td colspan="2">&nbsp;</td></tr>
                <tr>
                  <th width="200">
                      <% Language.printDatafield(out,session, formular,"Belegform");%>
                  </th>
                  <td width="450">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Belegform"/>
                      <jsp:param name="size" value="75"/>
                    </jsp:include>
                  </td>
                </tr>
                <tr>
                  <th width="200">
                      <% Language.printDatafield(out,session, formular,"Kontext");%>
                  </th>
                  <td width="450">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Kontext"/>
                    </jsp:include>
                  </td>
                </tr>
                <tr>
                  <th width="200">
                      <% Language.printDatafield(out,session, formular,"Namenlemma");%>
                  </th>
                  <td width="450">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Namenlemma"/>
                      <jsp:param name="size" value="75"/>
                    </jsp:include>
                  </td>
                </tr>
                <tr>
                  <th width="200">
                      <% Language.printDatafield(out,session, formular,"Erstglied");%>
                  </th>
                  <td width="450">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Erstglied"/>
                    </jsp:include>
                  </td>
                </tr>
                <tr>
                  <th width="200" valign="top">
                      <% Language.printDatafield(out,session, formular,"Zweitglied");%>
                  </th>
                  <td width="450">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Zweitglied"/>
                    </jsp:include>
                  </td>
                </tr>
                <tr>
                  <th width="200" valign="top">
                      <% Language.printDatafield(out,session, formular,"MGHLemma");%>
                  </th>
                  <td width="450">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="MGHLemma"/>
                    </jsp:include>
                  </td>
                </tr>

                <tr><td colspan="2">&nbsp;</td></tr>
                <tr>
                  <th width="200" valign="top">
                      <% Language.printDatafield(out,session, formular,"Personenname");%>
                  </th>
                  <td width="450">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Personenname"/>
                      <jsp:param name="size" value="75"/>
                    </jsp:include>
                  </td>
                </tr>
                <tr>
                  <th width="200" valign="top">
                      <% Language.printDatafield(out,session, formular,"Geschlecht");%>
                  </th>
                  <td width="450">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Geschlecht"/>
                      <jsp:param name="Empty" value="yes"/>
                    </jsp:include>
                  </td>
                </tr>
                <tr>
                  <th width="200" valign="top">
                      <% Language.printDatafield(out,session, formular,"PersonZeitraum");%>
                  </th>
                  <td width="450">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="PersonZeitraum"/>
                    </jsp:include>
                    <br>
                    <% Language.printTextfield(out,session, formular,"Datumsformat");%>: 6Jh2, 750, 750-810, 5Jh1-7Jh2
                  </td>
                </tr>

                <tr><td colspan="2">&nbsp;</td></tr>
                <tr>
                  <th width="200" valign="top">
                      <% Language.printDatafield(out,session, formular,"AmtWeihePerson");%>
                  </th>
                  <td width="450">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="AmtWeihePerson"/>
                      <jsp:param name="Empty" value="yes"/>
                    </jsp:include>
                  </td>
                </tr>
                <tr>
                  <th width="200" valign="top">
                      <% Language.printDatafield(out,session, formular,"StandPerson");%>
                  </th>
                  <td width="450">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="StandPerson"/>
                      <jsp:param name="Empty" value="yes"/>
                    </jsp:include>
                  </td>
                </tr>
                <tr>
                  <th width="200" valign="top">
                      <% Language.printDatafield(out,session, formular,"AmtWeiheEinzelbeleg");%>
                  </th>
                  <td width="450">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="AmtWeiheEinzelbeleg"/>
                       <jsp:param name="Empty" value="yes"/>
                    </jsp:include>
                  </td>
                </tr>
                <tr>
                  <th width="200" valign="top">
                      <% Language.printDatafield(out,session, formular,"Funktion");%>
                  </th>
                  <td width="450">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Funktion"/>
                      <jsp:param name="Empty" value="yes"/>
                    </jsp:include>
                  </td>
                </tr>
                <tr><td colspan="2">&nbsp;</td></tr>
                <tr>
                  <th width="200" valign="top">
                      <% Language.printDatafield(out,session, formular,"Verwandtschaftsgrad");%>
                  </th>
                  <td width="450">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Verwandtschaftsgrad"/>
                      <jsp:param name="Empty" value="yes"/>
                    </jsp:include>
                  </td>
                </tr>
                <tr><td colspan="2">&nbsp;</td></tr>
                <tr>
                  <th width="200" valign="top">
                       <% Language.printDatafield(out,session, formular,"Quelle");%>
                  </th>
                  <td width="450">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Quelle"/>
                      <jsp:param name="size" value="75"/>
                    </jsp:include>
                  </td>
                </tr>
                <tr>
                  <th width="200" valign="top">
                       <% Language.printDatafield(out, session, formular, "QuelleGattung");%>
                  </th>
                  <td width="450">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Quellengattung"/>
                      <jsp:param name="Empty" value="yes"/>
                    </jsp:include>
                  </td>
                </tr>
                 <tr>
                  <th width="200" valign="top">
                      <% Language.printDatafield(out,session, formular,"QuelleZeitraum");%>
                  </th>
                  <td width="450">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="QuelleZeitraum"/>
                    </jsp:include>
                    <br>
                    <% Language.printTextfield(out,session, formular,"Datumsformat");%>: 6Jh2, 750, 750-810, 5Jh1-7Jh2
                  </td>
                </tr>
                <!-- Provenance information Einzelbeleg-->
                <tr>
                  <th width="200" valign="top">
                      <% Language.printDatafield(out,session, formular,"ProvenanceEinzelbeleg");%>
                  </th>
                  <td width="450">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="ProvenanceEinzelbeleg"/>
                    </jsp:include>
                  </td>
                </tr>

              </tbody>
            </table>
            <!--p>&nbsp;<font color="red">*</font> <br>

                    <% Language.printTextfield(out,session, formular,"KeineFunktion");%>
            </p-->
            <p align="right">
              <a href="javascript:onoff('tab2','tab1');">

                  <% Language.printTextfield(out,session, formular,"LinkWeiter");%>
              </a>
            </p>
          </div>
        </div>

<!-- ##### AUSGABEFELDER ##### -->
        <div id="tab2">
          <div id="header">
            <ul id="primary">
              <li>
                <a href="javascript:onoff('tab1','tab2');">

                    <% Language.printTextfield(out,session, formular,"Tab1");%>
                </a>
              </li>
              <li>
                <span>

                    <% Language.printTextfield(out,session, formular,"Tab2");%>
                </span>
              </li>
              <li>
                <a href="javascript:onoff('tab3','tab2');">

                    <% Language.printTextfield(out,session, formular,"Tab3");%>
                </a>
              </li>
              <li>
                <a href="javascript:onoff('tab4','tab2');">

                    <% Language.printTextfield(out,session, formular,"Tab4");%>
                </a>
              </li>
            </ul>
          </div>
          <div id="main">
            <h3>

                <% Language.printTextfield(out,session, formular,"Ueberschrift2");%>
            </h3>
            <table>
              <tbody>
                <tr><td colspan="2"><h3>
                 <% Language.printTextfield(out,session, formular,"ZumNamen");%>
                        </h3></td></tr>
                <tr>
                  <td width="25">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Namenlemma"/>
                    </jsp:include>
                  </td>
                  <th width="350" valign="top">
                      <% Language.printDatafield(out,session, formular,"Ausgabe_Namenlemma");%>
                  </th>
                </tr>
                <tr>
                  <td width="25">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Erstglied"/>
                    </jsp:include>
                  </td>
                  <td width="350" valign="top">
                      <% Language.printDatafield(out,session, formular,"Ausgabe_Erstglied");%>
                  </td>
                </tr>
                <tr>
                  <td width="25">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Zweitglied"/>
                    </jsp:include>
                  </td>
                  <td width="350" valign="top">
                      <% Language.printDatafield(out,session, formular,"Ausgabe_Zweitglied");%>
                  </td>
                </tr>
                <tr>
                  <td width="25">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_MGHLemma"/>
                    </jsp:include>
                  </td>
                  <td width="350" valign="top">
                      <% Language.printDatafield(out,session, formular,"Ausgabe_MGHLemma");%>
                  </td>
                </tr>
                <tr><td colspan="2">&nbsp;</td></tr>
                <tr><td colspan="2"><h3>
                        <% Language.printTextfield(out, session, "gast_freie_suche", "ZurPerson");%>
                        </h3></td></tr>
                <tr>
                  <td width="25">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Person_Standardname"/>
                    </jsp:include>
                  </td>
                  <th width="350" valign="top">
                      <% Language.printDatafield(out,session, formular,"Ausgabe_Person_Standardname");%>
                  </th>
                </tr>
                <tr>
                  <td width="25">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Person_AmtWeihe"/>
                    </jsp:include>
                  </td>
                  <td width="350" valign="top">
                      <% Language.printDatafield(out,session, formular,"Ausgabe_Person_AmtWeihe");%>
                    <font color="blue">**</font>
                  </td>
                </tr>
                <tr>
                  <td width="25">
                  </td>
                  <td width="350" valign="top">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Person_AmtWeiheZeitraum"/>
                    </jsp:include>
                      <% Language.printDatafield(out,session, formular,"Ausgabe_Person_AmtWeiheZeitraum");%>
                  </td>
                </tr>
                <tr>
                  <td width="25">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Person_Ethnie"/>
                    </jsp:include>
                  </td>
                  <td width="350" valign="top">
                      <% Language.printDatafield(out,session, formular,"Ausgabe_Person_Ethnie");%>
                    <font color="blue">**</font>
                  </td>
                </tr>
                <tr>
                  <td width="25">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Stand"/>
                    </jsp:include>
                  </td>
                  <td width="350" valign="top">
                      <% Language.printDatafield(out,session, formular,"Ausgabe_Stand");%>
                    <font color="blue">**</font>
                  </td>
                </tr>
                <tr>
                  <td width="25">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Geschlecht"/>
                    </jsp:include>
                  </td>
                  <td width="350" valign="top">
                      <% Language.printDatafield(out,session, formular,"Ausgabe_Geschlecht");%>
                    <font color="blue">**</font>
                  </td>
                </tr>
                <tr>
                  <td width="25">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Person_Verwandte"/>
                    </jsp:include>
                  </td>
                  <td width="350" valign="top">
                      <% Language.printDatafield(out,session, formular,"Ausgabe_Person_Verwandte");%>
                    <font color="blue">**</font>
                  </td>
                </tr>
                <tr>
                  <td width="25">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Person_Areal"/>
                    </jsp:include>
                  </td>
                  <td width="350" valign="top">
                      <% Language.printDatafield(out,session, formular,"Ausgabe_Person_Areal");%>
                    <font color="blue">**</font>
                  </td>
                </tr>

                <tr><td colspan="2">&nbsp;</td></tr>
                <tr><td colspan="2"><h3>
                        <% Language.printTextfield(out, session, "gast_freie_suche", "ZumEinzelbeleg");%>
                        </h3></td></tr>
                <tr>
                  <td width="25">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Einzelbeleg_Belegstelle"/>
                    </jsp:include>
                  </td>
                  <td width="350" valign="top">
                      <% Language.printDatafield(out,session, formular,"Ausgabe_Einzelbeleg_Belegstelle");%>
                  </td>
                </tr>
                <tr>
                  <td width="25">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Quelle_Datierung"/>
                    </jsp:include>
                  </td>
                  <td width="350" valign="top">
                      <% Language.printDatafield(out, session, formular, "QuelleZeitraum");%>
                  </td>
                </tr>
                <tr>
                  <td width="25">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Einzelbeleg_Quellengattung"/>
                    </jsp:include>
                  </td>
                  <td width="350" valign="top">
                      <% Language.printDatafield(out,session, formular,"Ausgabe_Einzelbeleg_Quellengattung");%>
                  </td>
                </tr>
                <tr>
                  <td width="25">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Einzelbeleg_Belegform"/>
                    </jsp:include>
                  </td>
                  <th width="350" valign="top">
                      <% Language.printDatafield(out,session, formular,"Ausgabe_Einzelbeleg_Belegform");%>
                  </th>
                </tr>
                <tr>
                  <td width="25">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Einzelbeleg_Kontext"/>
                    </jsp:include>
                  </td>
                  <td width="350" valign="top">
                      <% Language.printDatafield(out,session, formular,"Ausgabe_Einzelbeleg_Kontext");%>
                  </td>
                </tr>
                <tr>
                  <td width="25">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Einzelbeleg_Datierung"/>
                    </jsp:include>
                  </td>
                  <td width="350" valign="top">
                      <% Language.printDatafield(out,session, formular,"Ausgabe_Einzelbeleg_Datierung");%>
                  </td>
                </tr>
                <tr>
                  <td width="25">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Einzelbeleg_lebend"/>
                    </jsp:include>
                  </td>
                  <td width="350" valign="top">
                      <% Language.printDatafield(out,session, formular,"Ausgabe_Einzelbeleg_lebend");%>
                  </td>
                </tr>
                <tr>
                  <td width="25">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Einzelbeleg_Funktion"/>
                    </jsp:include>
                  </td>
                  <td width="350" valign="top">
                      <% Language.printDatafield(out,session, formular,"Ausgabe_Einzelbeleg_Funktion");%>
                    <font color="blue">**</font>
                  </td>
                </tr>
                <tr>
                  <td width="25">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Einzelbeleg_Areal"/>
                    </jsp:include>
                  </td>
                  <td width="350" valign="top">
                      <% Language.printDatafield(out,session, formular,"Ausgabe_Person_Areal");%>
                    <font color="blue">**</font>
                  </td>
                </tr>
                <tr>
                  <td width="25">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Einzelbeleg_Varianten"/>
                    </jsp:include>
                  </td>
                  <td width="350" valign="top">
                      <% Language.printDatafield(out,session, formular,"Ausgabe_Einzelbeleg_Varianten");%>
                    <font color="blue">**</font>
                  </td>
                </tr>
                <tr>
                  <td width="25">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Einzelbeleg_Textzeuge"/>
                    </jsp:include>
                  </td>
                  <td width="350" valign="top">
                      <% Language.printDatafield(out,session, formular,"Ausgabe_Einzelbeleg_Textzeuge");%>
                    <font color="red">*</font>
                  </td>
                </tr>
                <tr>
                  <td width="25">
                  </td>
                  <td width="350" valign="top">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Einzelbeleg_Textzeuge_Datierung"/>
                    </jsp:include>
                      <% Language.printDatafield(out,session, formular,"Ausgabe_Einzelbeleg_Textzeuge_Datierung");%>
                    <font color="red">*</font>
                  </td>
                </tr>
                <tr>
                  <td width="25">
                  </td>
                  <td width="350" valign="top">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Einzelbeleg_Textzeuge_Schriftheimat"/>
                    </jsp:include>
                      <% Language.printDatafield(out,session, formular,"Ausgabe_Einzelbeleg_Textzeuge_Schriftheimat");%>
                    <font color="red">*</font>
                  </td>
                </tr>
                <tr>
                  <td width="25">
                  </td>
                  <td width="350" valign="top">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Einzelbeleg_Textzeuge_Bibliotheksheimat"/>
                    </jsp:include>
                      <% Language.printDatafield(out,session, formular,"Ausgabe_Einzelbeleg_Textzeuge_Bibliotheksheimat");%>
                    <font color="red">*</font>
                  </td>
                </tr>
                <tr>
                  <td width="25">
                    <jsp:include page="inc.erzeugeFormular.jsp">
                      <jsp:param name="Formular" value="freie_suche"/>
                      <jsp:param name="Datenfeld" value="Ausgabe_Provenance_Einzelbeleg"/>
                    </jsp:include>
                  </td>
                  <td width="350" valign="top">
                      <% Language.printDatafield(out,session, formular,"Ausgabe_Provenance_Einzelbeleg");%>
                  </td>
                </tr>
              </tbody>
            </table>
            <p>
              &nbsp;<font color="red">*</font>
                    <% Language.printTextfield(out,session, formular,"KeineFunktion");%>
              <br>
              &nbsp;<font color="blue">**</font>
                    <% Language.printTextfield(out,session, formular,"GroessereAusgabe");%>
            </p>
            <p align="right">
              <a href="javascript:onoff('tab3','tab2');">
                  <% Language.printTextfield(out,session, formular,"LinkWeiter");%>
              </a>
            </p>
          </div>
        </div>

<!-- ##### SORTIERUNG ##### -->
        <div id="tab3">
          <div id="header">
            <ul id="primary">
              <li>
                <a href="javascript:onoff('tab1','tab3');">

                    <% Language.printTextfield(out,session, formular,"Tab1");%>
                </a>
              </li>
              <li>
                <a href="javascript:onoff('tab2','tab3');">

                    <% Language.printTextfield(out,session, formular,"Tab2");%>
                </a>
              </li>
              <li>
                <span>

                    <% Language.printTextfield(out,session, formular,"Tab3");%>
                </span>
              </li>
              <li>
                <a href="javascript:onoff('tab4','tab3');">

                    <% Language.printTextfield(out,session, formular,"Tab4");%>
                </a>
              </li>
            </ul>
          </div>
          <div id="main">
            <h3>

                <% Language.printTextfield(out,session, formular,"Ueberschrift3");%>
            </h3>
            <table>
              <tbody>
                <tr>
                  <th width="200" valign="top">

                      <% Language.printTextfield(out,session, formular,"Sortierung1");%>
                  </th>
                  <td width="450">
                    <jsp:include page="forms/search.order.jsp">
                      <jsp:param name="name" value="order1"/>
                    </jsp:include>
                  </td>
                </tr>
                <tr>
                  <th width="200" valign="top">

                      <% Language.printTextfield(out,session, formular,"Sortierung2");%>
                  </th>
                  <td width="450">
                    <jsp:include page="forms/search.order.jsp">
                      <jsp:param name="name" value="order2"/>
                    </jsp:include>
                  </td>
                </tr>
                <tr>
                  <th width="200" valign="top">

                      <% Language.printTextfield(out,session, formular,"Sortierung3");%>
                  </th>
                  <td width="450">
                    <jsp:include page="forms/search.order.jsp">
                      <jsp:param name="name" value="order3"/>
                    </jsp:include>
                  </td>
                </tr>
              </tbody>
            </table>
           <p align="right">
               <a href="#" id="add">Weitere Gruppierung hinzufügen</a>
            </p>
            <p align="right">
              <a href="javascript:onoff('tab4','tab3');">

                  <% Language.printTextfield(out,session, formular,"LinkWeiter");%>
              </a>
            </p>
          </div>
        </div>

<!-- ##### AUSGABEFORMAT ##### -->
        <div id="tab4">
          <div id="header">
            <ul id="primary">
              <li>
                <a href="javascript:onoff('tab1','tab4');">

                    <% Language.printTextfield(out,session, formular,"Tab1");%>
                </a>
              </li>
              <li>
                <a href="javascript:onoff('tab2','tab4');">

                    <% Language.printTextfield(out,session, formular,"Tab2");%>
                </a>
              </li>
              <li>
                <a href="javascript:onoff('tab3','tab4');">

                    <% Language.printTextfield(out,session, formular,"Tab3");%>
                </a>
              </li>
              <li>
                <span>

                    <% Language.printTextfield(out,session, formular,"Tab4");%>
                </span>
              </li>
            </ul>
          </div>
          <div id="main">
            <h3>

                <% Language.printTextfield(out,session, formular,"Ueberschrift4");%>
            </h3>
            <table>
              <tbody>
                <tr>
                  <td>
                    <input type="radio" name="export" value="liste" />
                  </td>
                  <td>

                      <% Language.printTextfield(out,session, formular,"ExportListe");%>
                  </td>
                </tr>
                <tr>
                  <td>
                    <input type="radio" name="export" value="excel" />
                  </td>
                  <td>

                      <% Language.printTextfield(out,session, formular,"ExportExcel");%>
                  </td>
                </tr>
                <tr>
                  <td>
                    <input type="radio" name="export" value="rtf" />
                  </td>
                  <td>

                      <% Language.printTextfield(out,session, formular,"ExportRtf");%>
                    <font color="red">*</font>
                  </td>
                </tr>
                <tr>
                  <td>
                    <input type="radio" name="export" value="browse" />
                  </td>
                  <td>

                      <% Language.printTextfield(out,session, formular,"ExportBrowse");%>
                  </td>
                </tr>
              </tbody>
            </table>
            <p>
              &nbsp;<font color="red">*</font>
                <% Language.printTextfield(out,session, formular,"KeineFunktion");%>
            </p>
            <p align="right">
              <input type="reset">
              <input type="submit">
            </p>
          </div>
        </div>
      </div>
    </FORM>
