<%@page import="de.uni_tuebingen.ub.nppm.util.Language"%>

<div id="titel">
  <table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
      <td align="left">
        <h1><% Language.printTextfield(out, session, "datenpflege", "Titel");%></h1>
      </td>
    </tr>
  </table>
</div>
