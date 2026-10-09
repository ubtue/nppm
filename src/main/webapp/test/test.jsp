<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<h1>Test</h1>
<h2>This file belongs to the TestServlet.</h2>
<p>The following text is delivered by the TestServlet:</p>
<p>${fn:escapeXml(text)}</p>
