<%@page import="de.uni_tuebingen.ub.nppm.util.Language"%>
<%@page import="de.uni_tuebingen.ub.nppm.util.Utils" isThreadSafe="false" %>

<html>
<head>
<title><% Language.printTextfield(out, session, "login", "Umzug");%></title>
<meta name="author" content="rst">
<meta http-equiv="refresh" content="1; URL=<%=Utils.getBaseUrl(request)%>/gast/infos?sharedHtml=start&current=start">
</head>
<body text="#000000" bgcolor="#FFFFFF" link="#FF0000" alink="#FF0000" vlink="#FF0000">
    <table height=100% width=100% >
        <tr>
            <td align=center valign=center>
               <% Language.printTextfield(out, session, "login", "WerdenUmgeleitet");%>
            </td>
        </tr>
    </table>
</body>
</html>
