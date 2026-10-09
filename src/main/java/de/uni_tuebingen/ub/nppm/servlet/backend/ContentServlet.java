package de.uni_tuebingen.ub.nppm.servlet.backend;

import de.uni_tuebingen.ub.nppm.db.*;
import de.uni_tuebingen.ub.nppm.model.*;
import de.uni_tuebingen.ub.nppm.util.Language;
import de.uni_tuebingen.ub.nppm.util.Utils;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.fileupload.FileItemIterator;
import org.apache.commons.fileupload.FileItemStream;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

public class ContentServlet extends AbstractBackendServlet {

    protected Benutzer benutzer;

    @Override
    protected boolean isAdminRequired() {
        return true;
    }

    @Override
    protected void generatePage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        PrintWriter out = response.getWriter();

        try {
            // show TinyMCE
            if (request.getParameter("loadFile") != null) {
                RequestDispatcher rd = request.getRequestDispatcher("tinyMce.jsp");
                rd.include(request, response);
            } else if ("HtmlSaveToDatabase".equals(request.getParameter("htmlFileAccess"))) {
                String fileName = request.getParameter("tinyFileName");
                String language = request.getParameter("tinyLanguage");
                String newHtmlContent = request.getParameter("htmlContent");

                try {
                    Content content = ContentDB.getByNameAndLanguage(fileName, language);
                    if (content != null) {
                        ContentDB.updateHtmlFile(content, newHtmlContent);
                        // Redirect to the tinyMce.jsp page after saving
                        response.sendRedirect(Utils.getBaseUrl(request) + "/edit?loadFile=" + fileName);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else if (request.getParameter("loadFile") == null && !"HtmlSaveToDatabase".equals(request.getParameter("htmlFileAccess"))) {
                //show fileManagement

                HttpSession session = request.getSession();

                out.println("<div id=\"titel\">");
                out.println("  <table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
                out.println("    <tr>");
                out.println("      <td align=\"left\">");
                out.println("        <h1>");
                Language.printTextfield(out, session, "inhaltBearbeiten", "Titel");
                out.println("</h1>");
                out.println("      </td>");
                out.println("    </tr>");
                out.println("  </table>");
                out.println("</div>");
                out.println("<div id=\"form\">");
                out.println("<h2>");
                Language.printTextfield(out, session, "contentServlet", "h2");
                out.println("</h2>");
                out.println("<p style=\"line-height: 0.2; color: red;\">");
                Language.printTextfield(out, session, "contentServlet", "p1");
                out.println("</p>");
                out.println("<p style=\"line-height: 0.2; color: red;\">");
                Language.printTextfield(out, session, "contentServlet", "p2");
                out.println("</p>");
                out.println("<p style=\"line-height: 0.2; color: red;\">");
                Language.printTextfield(out, session, "contentServlet", "p3");
                out.println("</p>");

                // Actions:
                String fileAccess = request.getParameter("fileAccess");
                if (fileAccess != null) {
                    String messageStart = "";
                    String messageEnd = "";
                    String selectedLanguage = getCookieLanguage(request, response);
                    Content content = null;
                    if (request.getParameter("id") != null) {
                        content = ContentDB.getById(Integer.parseInt(request.getParameter("id")));
                    }

                    boolean isHtml = false;
                    if (content != null && content.getContext() != null && content.getContent_Type().equals("text/html")) {
                        isHtml = true;
                    }

                    //Action (Delete)
                    if (fileAccess.equals("fileDelete")) {
                        if (request.getParameter("id") != null) {

                            messageStart = Language.getTextfield(session, "contentServlet", "Datei") + " ";
                            messageEnd = " " + Language.getTextfield(session, "contentServlet", "BeenDeleted");

                            if (isHtml) {
                                deleteFileByNameAndLanguage(content.getName(), selectedLanguage);
                                out.println(messageStart + content.getName() + " (" + selectedLanguage + ") " + messageEnd);
                            } else {
                                deleteFile(request.getParameter("id"));
                                out.println(messageStart + content.getName() + messageEnd);
                            }

                        } else {
                            messageEnd = Language.getTextfield(session, "contentServlet", "FileNotDeleted");
                            out.println("<span style=\" color: red;\" >Error: </span> " + messageEnd);
                        }
                        // Action (upload OR replace/update)
                    } else if (fileAccess.equals("fileUpload")) {
                        uploadFile(request, response);
                    } else if (fileAccess.equals("fileReplace")) {

                        if (request.getParameter("id") != null) {  //hier != null
                            replaceFile(request, response);
                        } else {
                            messageEnd = Language.getTextfield(session, "contentServlet", "FileNotReplaced");
                            if (isHtml) {
                                out.println("<span style=\" color: red;\" >Error: </span> " + content.getName() + " (" + selectedLanguage + ") " + messageEnd);
                            } else {
                                out.println("<span style=\" color: red;\" >Error: </span> " + content.getName() + " " + messageEnd);
                            }
                        }
                    } else if (fileAccess.equals("HtmlFileCreate")) {
                        String createFileName = request.getParameter("CreateHTMLFileName");
                        String contextParam = request.getParameter("HtmlContext");
                        Content.Context context = Content.Context.valueOf(contextParam);

                        if (createFileName != null && context != null && selectedLanguage != null) {
                            ContentDB.createHtmlFile(createFileName, context, selectedLanguage);

                            messageStart = Language.getTextfield(session, "contentServlet", "Datei") + " ";
                            messageEnd = " " + Language.getTextfield(session, "contentServlet", "FileCreated");
                            out.println(messageStart + createFileName + " (" + selectedLanguage + ") " + messageEnd);
                        }
                    }
                }
                // show list (e.g. help, name comment or blank page)
                RequestDispatcher rd = request.getRequestDispatcher("fileManagement.jsp");
                rd.include(request, response);

            }
        } catch (Exception e) {
            // out.println("An error occurred mein Freund: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("fileManagement.jsp");
            rd.include(request, response);
        }
    }//end function

    public void deleteFile(String fileId) throws IOException, Exception {

        Integer id = Integer.parseInt(fileId);
        Content content = ContentDB.getById(id);
        if (content.getContext().equals(Content.Context.NAMENKOMMENTAR)) {
            List<NamenKommentar> namenkommentarList = NamenKommentarDB.searchByFileName(fileId);
            for (NamenKommentar n : namenkommentarList) {
                n.setDateiname(null);
                NamenKommentarDB.saveOrUpdate(n);
            }
        } else if (content.getContext().equals(Content.Context.QUELLENKOMMENTAR)) {
            List<Quelle> quellenkommtarList = QuelleDB.searchByFileName(fileId, Content.Context.QUELLENKOMMENTAR);
            for (Quelle q : quellenkommtarList) {
                q.setQuellenKommentarDatei(null);
                QuelleDB.saveOrUpdate(q);
            }
        } else if (content.getContext().equals(Content.Context.UEBERLIEFERUNGSKOMMENTAR)) {
            List<Quelle> ueberlieferungskommtarList = QuelleDB.searchByFileName(fileId, Content.Context.UEBERLIEFERUNGSKOMMENTAR);
            for (Quelle q : ueberlieferungskommtarList) {
                q.setUeberlieferungsKommentarDatei(null);
                QuelleDB.saveOrUpdate(q);
            }
        }
        ContentDB.deleteById(id);
    }//end function

    public void deleteFileByNameAndLanguage(String fileName, String selectedLanguage) throws IOException, Exception {

        if (!selectedLanguage.equals("dontDelete")) {
            Content content = ContentDB.getByNameAndLanguage(fileName, selectedLanguage);
            if (content != null) {
                ContentDB.deleteByNameAndLanguage(fileName, selectedLanguage);
            }
        }
    }//end function

    public void replaceFile(HttpServletRequest request, HttpServletResponse response) throws IOException, FileUploadException, Exception {
        PrintWriter out = response.getWriter();
        String oldfFile = ContentDB.getById(Integer.parseInt(request.getParameter("id"))).getName();

        // Create a new file upload handler
        ServletFileUpload upload = new ServletFileUpload();

        // Parse the request
        FileItemIterator iter = upload.getItemIterator(request);

        String messageStart = "";
        String messageEnd = "";
        HttpSession session = request.getSession();

        while (iter.hasNext()) {

            FileItemStream item = iter.next();
            String contentType = item.getContentType();

            String errorFileName = item.getName();

            if (!item.isFormField()) {

                if (item.getName() == null || item.getName().isEmpty() || item.getName().equals("")) {
                    messageEnd = " " + Language.getTextfield(session, "contentServlet", "NoFile");
                    out.println("<span style=\" color: red;\" >Error: </span>" + messageEnd);
                } else if (item.getContentType().startsWith("text/html") || item.getContentType().startsWith("text/plain") || item.getContentType().startsWith("application/vnd.oasis.opendocument.text")
                        || item.getContentType().startsWith("image") || item.getContentType().startsWith("application/vnd.openxmlformats-officedocument.wordprocessingml.document")
                        || item.getContentType().startsWith("application/msword")) {

                    String fileName = item.getName();

                    boolean fileExists = ContentDB.searchName(fileName);

                    if (fileExists && oldfFile.equals(fileName)) {

                        Content content = null;
                        String selectedLanguage = getCookieLanguage(request, response);

                        if (contentType.equals("text/html")) {
                            content = ContentDB.getByNameAndLanguage(fileName, selectedLanguage);
                        } else {
                            content = ContentDB.getById(Integer.parseInt(request.getParameter("id")));
                        }

                        String pathname = writeItemToTempFile(item);

                        byte[] bytes = ContentDB.readBytesFromFile(pathname);
                        content.setContent(bytes);
                        ContentDB.saveOrUpdate(content);

                        messageStart = Language.getTextfield(session, "contentServlet", "Datei") + " ";
                        messageEnd = " " + Language.getTextfield(session, "contentServlet", "FileUpdate");
                        if (contentType.equals("text/html")) {
                            out.println(messageStart + fileName + " (" + selectedLanguage + ")" + messageEnd);
                        } else {
                            out.println(messageStart + fileName + messageEnd);
                        }

                        //Now delete the temporary file again
                        File myObj = new File(pathname);
                        myObj.delete();
                    } else {
                        messageStart = Language.getTextfield(session, "contentServlet", "FilesDontMatch") + " ";
                        messageEnd = " " + Language.getTextfield(session, "contentServlet", "Und") + " ";
                        out.println("<span style=\" color: red;\" >Error: </span>" + messageStart + oldfFile + messageEnd + fileName);
                        out.println("<br>");
                    }
                } else {
                    messageStart = Language.getTextfield(session, "contentServlet", "Datei") + " ";
                    messageEnd = " " + Language.getTextfield(session, "contentServlet", "FileNotAllowed");
                    out.println("<span style=\" color: red;\" >Error: </span>" + messageStart + errorFileName + ":" + messageEnd);
                    out.println("<br>");
                }
            }
        }
    }

    public void uploadFile(HttpServletRequest request, HttpServletResponse response) throws IOException, FileUploadException, Exception {
        PrintWriter out = response.getWriter();
        String context = request.getParameter("context");
        Content.Context contextEnum = Content.Context.valueOf(context);

        String selectedLanguage = getCookieLanguage(request, response);

        // Create a new file upload handler
        ServletFileUpload upload = new ServletFileUpload();

        // Parse the request
        FileItemIterator iter = upload.getItemIterator(request);

        String messageStart = "";
        String messageEnd = "";
        HttpSession session = request.getSession();

        while (iter.hasNext()) {

            FileItemStream item = iter.next();
            String contentType = item.getContentType();
            String errorFileName = item.getName();

            if (!item.isFormField()) {

                if (item.getName() == null || item.getName().isEmpty() || item.getName().equals("")) {
                    messageEnd = " " + Language.getTextfield(session, "contentServlet", "NoFile");
                    out.println("<span style=\" color: red;\" >Error: </span>" + messageEnd);
                } else if (item.getContentType().startsWith("text/html") || item.getContentType().startsWith("text/plain") || item.getContentType().startsWith("application/vnd.oasis.opendocument.text")
                        || item.getContentType().startsWith("image") || item.getContentType().startsWith("application/vnd.openxmlformats-officedocument.wordprocessingml.document")
                        || item.getContentType().startsWith("application/msword")) {

                    String fileName = item.getName();

                    boolean fileExists = true;

                    if (contentType.equals("text/html")) {
                        fileExists = ContentDB.searchNameAndLanguage(fileName, selectedLanguage);
                    } else {
                        fileExists = ContentDB.searchName(fileName);
                    }

                    String pathname = writeItemToTempFile(item);

                    if (fileExists == true) {

                        //search file - Context of existing file
                        String existingFileContext = "";
                        messageStart = Language.getTextfield(session, "contentServlet", "Datei") + " ";
                        messageEnd = " " + Language.getTextfield(session, "contentServlet", "FileExist") + " ";
                        if (contentType.equals("text/html")) {
                            existingFileContext = ContentDB.getByNameAndLanguage(fileName, selectedLanguage).getContext().toString();
                            out.println("<span style=\" color: red;\" >Error: </span>" + messageStart + fileName + " (" + selectedLanguage + ")" + messageEnd + existingFileContext);
                        } else {
                            existingFileContext = ContentDB.getByName(fileName).getContext().toString();
                            out.println("<span style=\" color: red;\" >Error: </span>" + messageStart + fileName + messageEnd + existingFileContext);
                        }
                        out.println("<br>");
                    } else {
                        messageStart = Language.getTextfield(session, "contentServlet", "Datei") + " ";
                        messageEnd = " " + Language.getTextfield(session, "contentServlet", "FileSuccess");
                        if (contentType.equals("text/html")) {
                            ContentDB.saveFile(pathname, fileName, contentType, contextEnum, selectedLanguage);
                            out.println(messageStart + fileName + "(" + selectedLanguage + ")" + messageEnd);
                        } else {
                            ContentDB.saveFile(pathname, fileName, contentType, contextEnum);
                            out.println(messageStart + fileName + messageEnd);
                        }
                        out.println("<br>");
                    }

                    //Now delete the temporary file again
                    File myObj = new File(pathname);
                    myObj.delete();
                } else {
                    messageStart = Language.getTextfield(session, "contentServlet", "Datei") + " ";
                    messageEnd = " " + Language.getTextfield(session, "contentServlet", "FileNotAllowed");
                    out.println("<span style=\" color: red;\" >Error: </span>" + messageStart + errorFileName + ":" + messageEnd);
                    out.println("<br>");
                }
            }
        }
    }

    protected String writeItemToTempFile(FileItemStream item) throws FileNotFoundException, IOException {
        String tmpDir = System.getProperty("java.io.tmpdir");
        String pathname = tmpDir + "/" + item.getName();

        InputStream stream = item.openStream();
        try (FileOutputStream file = new FileOutputStream(new File(pathname))) {
            for (int data = stream.read(); data >= 0; data = stream.read()) {
                file.write(data);
            }
        }
        return pathname;
    }

    @Override
    protected String getTitle() {
        return "fileManagement";
    }

    public String getCookieLanguage(HttpServletRequest request, HttpServletResponse response) {
        Cookie[] cookies = request.getCookies();
        String selectedLanguage = "dontDelete";  //Standardwert wenn kein Cookie gesetzt worden ist
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("selectedLanguage")) {
                    selectedLanguage = cookie.getValue();
                    break;
                }
            }
        }
        return selectedLanguage;
    }
}//end class

