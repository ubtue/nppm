<%@page import="de.uni_tuebingen.ub.nppm.util.Language"%>
<%@ page import="java.util.ArrayList" isThreadSafe="false" %>
<%@ page import="java.util.Enumeration" isThreadSafe="false" %>
<%@ page import="java.util.List" isThreadSafe="false" %>

<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>
<%@ page import="com.lowagie.text.Document" isThreadSafe="false" %>
<%@ page import="com.lowagie.text.*" isThreadSafe="false" %>
<%@ page import="com.lowagie.text.rtf.*" isThreadSafe="false" %>
<%@ page import="java.io.*" isThreadSafe="false" %>


<%

Document document = new Document();

 int limit=0;
 int offset = 5;
  try{
      limit = Integer.parseInt(request.getParameter("limit"));
  }catch(Exception ex){;}

  String file = "/print/" +request.getParameter("form")+ request.getParameter("Belegform").replace('%','_') + "download.rtf";

FileOutputStream buffer = new FileOutputStream(this.getServletContext().getRealPath("/") + file);
RtfWriter2.getInstance( document, buffer );

// step 3: we open the document
document.open();

  String formular = request.getParameter("form");

 /* out.println("<center>");
  out.println("<a href=\"?form="+formular+"&Belegform="+request.getParameter("Belegform")+"&limit="+(limit+5)+"\">Nächste "+offset+" Lemmata</a>");
  out.println("</center>");
*/

      String link = Language.getTextfield(session, "suche", "Link");
      String beleg = Language.getTextfield(session, "person", "Beleg");
      String datierung = Language.getTextfield(session, "person", "Datierung");
      String sigleVariante = Language.getTextfield(session, "suche", "SigleVariante");
      String belegform = Language.getTextfield(session, "suche", "Belegform");

      out.println("<table class=\"date\">\n");
      out.println("<tr><th>" + link + "</th><th>" + beleg + "</th><th>" + datierung + "</th><th>" + sigleVariante + "</th></tr>\n");
      try {

        if(request.getParameter("Belegform").equals("")){
        String sql = "SELECT einzelbeleg.ID, einzelbeleg.Belegnummer, einzelbeleg.Belegform"
                              +", einzelbeleg.VonTag, einzelbeleg.VonMonat, einzelbeleg.VonJahr, einzelbeleg.BisTag, einzelbeleg.BisMonat, einzelbeleg.BisJahr"
                             +" FROM einzelbeleg"
                             +" WHERE NOT EXISTS (SELECT eh.EinzelbelegID FROM einzelbeleg_hatnamenkommentar eh WHERE einzelbeleg.ID=eh.EinzelbelegID) ORDER BY einzelbeleg.ID";

         int count=0;
         String standardName = "";
         java.util.List<Object[]> result = SucheDB.getListNative(sql);
        for ( Object[] row : result ) {

        count++;
          if(count%2==0)out.println("<tr>");
          else out.println("<tr bgcolor='#AACCDD'>");

          out.println("<td><a href=\"einzelbeleg?ID="+row[0]+"\">" + belegform + "</a></td>");
          if(row[2] == null){
            row[2] = "&nbsp;";
          }
          out.println("<td>"+(row[2])+"</td>");
          String date1 = makeDateWrapper(row[3], row[4], row[5]);
          String date2 = makeDateWrapper(row[6], row[7], row[8]);
          if(date1 != "" && date2 != "")
            out.println("<td> "+date1+" - "+date2+"</td>");

		out.println("</tr>");

          }


      out.println("</table>\n");

        }else
        {
        String sql = "SELECT n.ID, n.PLemma"
                             +" FROM einzelbeleg_hatnamenkommentar eh2, einzelbeleg e2, namenkommentar n"
                             +" WHERE e2.Belegform LIKE '" +request.getParameter("Belegform")+"' AND eh2.EinzelbelegID=e2.ID AND n.ID=eh2.NamenkommentarID GROUP BY n.ID ORDER BY n.PLemma";

        java.util.List<Object[]> result = SucheDB.getListNative(sql);
        for(Object[] row : result){
        // step 4: we add a paragraph to the document
                        document.add(new Paragraph(DBtoHTML(String.valueOf(row[1].toString())), new Font(Font.TIMES_ROMAN, 28)));

        float [] widths = {0.1f,0.1f,0.1f,0.1f,0.2f,0.1f,0.1f,0.1f};

         Table table = new Table(widths.length);
         table.setWidths(widths);
   //      table.addCell(new Cell("Belegnummer"));
         table.addCell(new Cell(new Paragraph("Belegform", new Font(Font.TIMES_ROMAN, 8))));
         table.addCell(new Cell(new Paragraph("Datierung", new Font(Font.TIMES_ROMAN, 8))));
            table.addCell(new Cell(new Paragraph("Sigle", new Font(Font.TIMES_ROMAN, 8))));
            table.addCell(new Cell(new Paragraph("Variante", new Font(Font.TIMES_ROMAN, 8))));
            table.addCell(new Cell(new Paragraph("Textzeuge", new Font(Font.TIMES_ROMAN, 8))));
            table.addCell(new Cell(new Paragraph("Schriftheimat", new Font(Font.TIMES_ROMAN, 8))));
            table.addCell(new Cell(new Paragraph("Bib.heimat", new Font(Font.TIMES_ROMAN, 8))));
            table.addCell(new Cell(new Paragraph("Datierung", new Font(Font.TIMES_ROMAN, 8))));


           out.println("<tr><td colspan=4><a href=\"namenkommentar?ID="+DBtoHTML(row[0])+"\"><h1>"+DBtoHTML(row[1])+"</h1></a></td></tr>");
           int id = Integer.valueOf(DBtoHTML(row[0].toString()));
       //  Statement st2 = cn.createStatement();
          String sql2 = "SELECT einzelbeleg.ID, einzelbeleg.Belegnummer, einzelbeleg.Belegform"
                             +", person.ID as personID, person.Standardname"
                             +", einzelbeleg.VonTag, einzelbeleg.VonMonat, einzelbeleg.VonJahr, einzelbeleg.BisTag, einzelbeleg.BisMonat, einzelbeleg.BisJahr"
                             +" FROM einzelbeleg_hatnamenkommentar, (einzelbeleg LEFT JOIN einzelbeleg_hatperson ON einzelbeleg.ID = einzelbeleg_hatperson.EinzelbelegID) LEFT JOIN person ON einzelbeleg_hatperson.PersonID = person.ID"
                             +" WHERE einzelbeleg_hatnamenkommentar.NamenkommentarID = \""+id+"\""
                             +" AND einzelbeleg_hatnamenkommentar.EinzelbelegID = einzelbeleg.ID"
                             +" ORDER BY person.Standardname ASC";
          java.util.List<Object[]> results = SucheDB.getListNative(sql2);
         int count=0;
         String standardName = "";
        for ( Object[] resultRow : results) {
        if(resultRow[4]==null){
           if(!standardName.equals("-")){
             standardName = "-";
             out.println("<tr><td colspan=4><h2>"+DBtoHTML(standardName)+"</h1></td></tr>");

             document.add(table);
             document.add(new Paragraph("     " + standardName, new Font(Font.TIMES_ROMAN, 16)));

             table = new Table(widths.length);
         table.setWidths(widths);
           }
        }
        else if(!resultRow[4].toString().equals(standardName)){
            standardName = resultRow[4].toString();
            out.println("<tr><td colspan=4><a href=\"person?ID="+DBtoHTML(resultRow[3])+"\"><h2>"+DBtoHTML(standardName)+"</h2></a></td></tr>");
             document.add(table);
             document.add(new Paragraph("     " + standardName, new Font(Font.TIMES_ROMAN, 16)));
             table = new Table(widths.length);
         table.setWidths(widths);
         }

        count++;
          if(count%2==0)out.println("<tr>");
          else out.println("<tr bgcolor='#AACCDD'>");

          out.println("<td><a href=\"einzelbeleg?ID="+DBtoHTML(resultRow[0])+"\">" + belegform + "</a></td>");
          out.println("<td>"+(resultRow[2]==null?"&nbsp;":DBtoHTML(resultRow[2]))+"</td>");
          out.println("<td> "+makeDateWrapper(resultRow[5], resultRow[6], resultRow[7])+" - "+makeDateWrapper(resultRow[8], resultRow[9], resultRow[10])+"</td>");

            Cell eb = new Cell(new Paragraph((resultRow[2]==null?"&nbsp;":DBtoHTML(resultRow[2].toString())), new Font(Font.TIMES_ROMAN, 8)));
            table.addCell(eb);

             Cell dat = new Cell(new Paragraph(makeDateWrapper(resultRow[5], resultRow[6], resultRow[7])+" - "+makeDateWrapper(resultRow[8], resultRow[9], resultRow[10]), new Font(Font.TIMES_ROMAN, 8)));
             table.addCell(dat);

          String sql3 = "Select u.Sigle, e.Variante, h.Bibliothekssignatur, e.handschriftID, h.ID, hu.VonTag, hu.VonMonat, hu.VonJahr, hu.BisTag, hu.BisMonat, hu.BisJahr, s1.Bezeichnung AS Bezeichnung1, s2.Bezeichnung AS Bezeichnung2  from einzelbeleg_textkritik e, ueberlieferung_edition u, handschrift h, handschrift_ueberlieferung hu, selektion_ort s1, selektion_ort s2 where e.EinzelbelegID=" + resultRow[0] +" and hu.ID=e.handschriftID and hu.handschriftID=h.ID and e.handschriftID=u.ueberlieferungID and e.editionID=u.editionID and s1.ID=hu.Bibliotheksheimat AND s2.ID=hu.Schriftheimat";

          out.println("<td><table cellpadding=2 style=\"font-size:8pt\">");
          String sigle = "";
          boolean first=true;

          int belegCount =0;

          java.util.List<Object[]> sucheResults = SucheDB.getListNative(sql3);
          for(Object[] innerResultRow : sucheResults){
          belegCount++;
            if(first){
            first=false;
            out.println("<tr><th><b>Sigle</b></th>");
            out.println("<th><b>Variante</b></th>");
            out.println("<th><b>Textzeuge</b></th>");
            out.println("<th><b>Schriftheimat</b></th>");
            out.println("<th><b>Bib.heimat</b></th>");
          out.println("<th><b>Datierung</b></th></tr>");


            }
            else          {
            table.addCell("");
                    table.addCell("");
            }

            out.println("<tr><td>"+DBtoHTML(innerResultRow[0]) + "</td>");
            out.println("<td>" + DBtoHTML(innerResultRow[1]) +"</td>");
            out.println("<td><a href=\"handschrift?ID="+innerResultRow[4]+"\"/><div style=\"font-size:8pt\">" + DBtoHTML(innerResultRow[2])+"</div></a></td>");
            out.println("<td>" + DBtoHTML(innerResultRow[12])+"</td>");
            out.println("<td>" + DBtoHTML(innerResultRow[11])+"</td>");
            String date =  makeDateWrapper(innerResultRow[5], innerResultRow[6], innerResultRow[7])+" - "+makeDateWrapper(innerResultRow[8], innerResultRow[9], innerResultRow[10]);
          out.println("<td> "+date+"</td></tr>");

                       table.addCell(new Cell(new Paragraph(DBtoHTML(innerResultRow[0].toString()), new Font(Font.TIMES_ROMAN, 8))));
         table.addCell(new Cell(new Paragraph(DBtoHTML(innerResultRow[1].toString()), new Font(Font.TIMES_ROMAN, 8))));
       table.addCell(new Cell(new Paragraph(DBtoHTML(innerResultRow[2].toString()), new Font(Font.TIMES_ROMAN, 8))));
     table.addCell(new Cell(new Paragraph(DBtoHTML(innerResultRow[12].toString()), new Font(Font.TIMES_ROMAN, 8))));
     table.addCell(new Cell(new Paragraph(DBtoHTML(innerResultRow[11].toString()), new Font(Font.TIMES_ROMAN, 8))));
      table.addCell(new Cell(new Paragraph(date, new Font(Font.TIMES_ROMAN, 8))));

          }
          if(belegCount==0){
                                  table.addCell("");
         table.addCell("");
       table.addCell("");
     table.addCell("");
     table.addCell("");
      table.addCell("");

          }
          else{
            eb.setRowspan(belegCount);
            dat.setRowspan(belegCount);
          }

          out.println("</table></td></tr>");


        }
        document.add(table);
        }}
      }
      catch (Exception e) {
        out.println(e);
      }
      out.println("</table>\n");

%>

<%

// step 5: we close the document
document.close();

// step 6: we output the writer as bytes to the response output
out.println("<a href='../.."+file+"'>Download</a>");
%>


