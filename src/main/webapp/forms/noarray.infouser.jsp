<%@page import="de.uni_tuebingen.ub.nppm.util.Utils"%>
<%@ page import="de.uni_tuebingen.ub.nppm.db.*" isThreadSafe="false" %>
<%@ page import="java.util.Map" isThreadSafe="false" %>

<%
  if (feldtyp.equals("infouser") && !array) {

      Map row = AbstractBase.getMappedRow("SELECT benutzer.Vorname, benutzer.Nachname, benutzer.Login, benutzer_gruppe.Bezeichnung FROM "+zielTabelle+", benutzer, benutzer_gruppe WHERE "+zielTabelle+".ID=\""+id+"\" AND "+zielTabelle+"."+zielAttribut+"=benutzer.ID AND benutzer.GruppeID = benutzer_gruppe.ID");

     if (row != null) {
        out.print(
           Utils.safeToString(row.get("Vorname"))
          +" "
          + Utils.safeToString(row.get("Nachname"))
          +" ("
          + Utils.safeToString(row.get("Login"))
          +")"
          +" ("
          + Utils.safeToString(row.get("Bezeichnung"))
          +")");
      }
  }
%>
