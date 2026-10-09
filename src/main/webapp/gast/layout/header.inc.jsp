<%@ page import="de.uni_tuebingen.ub.nppm.util.Utils" isThreadSafe="false" %>

<%@ include file="../../configuration.jsp" %>
<%@ include file="../../functions.jsp" %>
<%@ page language="java" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.List" %>

<%    // Wenn ein Link geklickt wurde, setzen Sie die Sprache entsprechend
    if (request.getParameter("language") != null) {
        String selectedLanguage = request.getParameter("language");
        session.setAttribute("Sprache", selectedLanguage);
    } else if (session.getAttribute("Sprache") == null) {
        // Holen Sie sich den Accept-Language-Header-Wert
        String acceptLanguage = request.getHeader("Accept-Language");

        // Teilen Sie die Sprachen auf der Grundlage von Kommata
        String[] languages = acceptLanguage.split(",");

        // Erstellen Sie eine Liste von bevorzugten Sprachen
        List<String> preferredLanguages = Arrays.asList(languages);

        // Gehen Sie durch die bevorzugten Sprachen und extrahieren Sie die primäre Sprache
        String primaryLanguage = null;
        for (String lang : preferredLanguages) {
            String[] parts = lang.split(";");
            primaryLanguage = parts[0];
            break; // Nur die erste Sprache berücksichtigen
        }

        // Erstellen Sie ein Locale-Objekt aus der primären Sprache
        Locale userLocale = new Locale(primaryLanguage);

        // Sie können dann die Sprache und das Land aus dem Locale-Objekt erhalten
        String language = userLocale.getLanguage(); // Sprache (z. B. "en" für Englisch)
        String country = userLocale.getCountry();   // Land (z. B. "US" für die Vereinigten Staaten)

        if (language.startsWith("de")) {
            language = "de";
            session.setAttribute("Sprache", language);
        } else if (language.startsWith("en")) {
            language = "gb";
            session.setAttribute("Sprache", language);
        } else if (language.startsWith("la")) {
            language = "la";
            session.setAttribute("Sprache", language);
        } else if (language.startsWith("fr")) {
            language = "fr";
            session.setAttribute("Sprache", language);
        } else {
            language = Constants.DEFAULT_LANG;
            session.setAttribute("Sprache", language);
        }
    }

    // Hole die aktuelle Spracheinstellung aus der Session
    String language = (String) session.getAttribute("Sprache");

    int id = -1;
    String title = (String) request.getAttribute("title"); // Holt den Titel aus der Anfrage
    if (title == null) {
        title = "Default Title"; // Setzt einen Standardtitel, falls keiner übergeben wird
    }

    try {
        id = Integer.parseInt(request.getParameter("ID"));
    } catch (NumberFormatException e) {
    }

    String form = "";

 String current = (String) request.getParameter("current");
        if (current == null) {
            current = "start"; // Fallback nur wenn nicht gesetzt
        }
  %>

<header>
    <nav class="ut-nav ut-nav--skipanchors" aria-label="Bereiche überspringen">
        <ul class="ut-nav__list">
            <li class="ut-nav__item" data-level-count="1">
                <a class="ut-link ut-nav__link hidden-xs hidden-sm sr-only sr-only-focusable" href="#ut-identifier--main-nav" tabindex="0">###DT-skip_to_main_navigation###</a>
            </li>
            <li class="ut-nav__item" data-level-count="2">
                <a class="ut-link ut-nav__link sr-only sr-only-focusable" href="#ut-identifier--main-content" tabindex="0">###DT-skip_to_content###</a>
            </li>
            <li class="ut-nav__item" data-level-count="3">
                <a class="ut-link ut-nav__link sr-only sr-only-focusable" href="#ut-identifier--footer" tabindex="0">###DT-skip_to_footer###</a>
            </li>
        </ul>
    </nav>
    <div class="container ut-page-header__container">
        <div class="ut-page-header__menu">
            <nav class="ut-page-header__switch ut-switchbar">
                <ul class="ut-switchbar__list" role="tablist">

                    <!-- Suchen -->
                    <li class="ut-switchbar__item" id="switchbar-search">
                        <button class="ut-switchbar__toggle" id="ut-identifier--search-toggle" data-toggle="switchbar" data-target="#switchblock-search" aria-label="<% Language.printTextfield(out, session, "suche", "Titel"); %>" aria-haspopup="true" aria-expanded="false" tabindex="0">
                            <span class="ut-switchbar__icon ut-icon ut-icon-search"></span>
                            <span class="ut-switchbar__label"><% Language.printTextfield(out, session, "suche", "Titel"); %></span>
                        </button>
                        <div class="ut-switchblock__item ut-switchblock__item--dropdown" id="switchblock-search" style="right: 381px;">
                            <div class="ut-switchblock__header">
                                <span class="ut-switchblock__title"><% Language.printTextfield(out, session, "sucheEinzelbeleg", "Titel");%></span>
                            </div>
                            <div class="ut-switchblock__content">
                                <form class="ut-form ut-form--search ut-form--small" name="searchForm" role="search" action="<%=Utils.getBaseUrl(request)%>/gast/einfaches_ergebnis" onsubmit="appendSiteToQuery()">
                                    <fieldset>
                                        <div class="ut-form__row row ">
                                            <input class="ut-form__input ut-form__field" id="search" type="search" name="query" placeholder="<% Language.printTextfield(out, session, "gast_freie_suche", "IhreSuchanfrage"); %>" value="" aria-label=<% Language.printTextfield(out, session, "gast_freie_suche", "IhreSuchanfrage"); %> required="">
                                            <input type="hidden" name="form" value="einfache_suche">
                                        </div>
                                        <div class="ut-form__actions row ">
                                            <button type="submit" class="ut-btn ut-btn--outline ut-btn--color-primary-1 ut-form__action" aria-label="<% Language.printTextfield(out, session, "suche", "Start"); %>" >
                                                <% Language.printTextfield(out, session, "suche", "Titel");%>
                                                <span class="ut-btn__icon ut-btn__icon--right ut-icon ut-icon-right-big"></span>
                                            </button>
                                        </div>
                                    </fieldset>
                                </form>
                            </div>
                            <span class="ut-switchblock__close-icon ut-icon ut-icon-cancel" role="button" tabindex="0"></span>
                        </div>
                    </li>

                    <!-- Help -->
                    <li class="ut-switchbar__item" id="switchbar-help">
                        <a href="<%=Utils.getBaseUrl(request)%>/gast/infos?sharedHtml=hilfe" class="ut-switchbar__toggle" data-toggle="switchbar" data-target="#switchblock-help" aria-label="<% Language.printTextfield(out, session, "hilfe", "Titel");%>" role="button" aria-haspopup="false" aria-expanded="false">
                            <span class="ut-switchbar__icon ut-icon ut-icon-info-circled"></span>
                            <span class="ut-switchbar__label"><% Language.printTextfield(out, session, "hilfe", "Titel");%></span>
                        </a>
                    </li>

                    <!-- Login -->
                    <li class="ut-switchbar__item" id="switchbar-login">
                        <a href="<%=Utils.getBaseUrl(request)%>/logout?go=intern" class="ut-switchbar__toggle" data-toggle="switchbar" data-target="#switchblock-login"  aria-label="<% Language.printTextfield(out, session, "internerBereich", "Titel"); %>" role="button" aria-haspopup="false" aria-expanded="false" rel="nofollow">
                            <span class="ut-switchbar__icon ut-icon ut-icon-login"></span>
                            <span class="ut-switchbar__label"><% Language.printTextfield(out, session, "internerBereich", "Titel"); %></span>
                        </a>
                    </li>

                    <!-- Language -->
                    <li class="ut-switchbar__item" id="switchbar-language">
                        <a href="#" class="ut-switchbar__toggle" data-toggle="switchbar" data-target="#switchblock-language"
                           title="Select Language" role="button" aria-label="Select Language" aria-haspopup="true" aria-expanded="false" rel="nofollow">
                            <span class="ut-switchbar__icon ut-icon ut-icon-globe"></span>
                            <span class="ut-switchbar__label">Language</span>
                        </a>
                        <div class="ut-switchblock__item ut-switchblock__item--dropdown" id="switchblock-language">
                            <div class="ut-switchblock__header">
                                <span class="ut-switchblock__title"><% Language.printTextfield(out, session, "sprachauswahl", "Sprachauswahl");%></span>
                                <span class="ut-switchblock__close-icon ut-icon ut-icon-cancel" role="button" aria-label="<% Language.printTextfield(out, session, "sprachauswahl", "SprachauswahlSchliessen");%>" tabindex="0" ></span>
                            </div>
                            <div class="ut-switchblock__content">
                                <nav class="ut-nav ut-nav--language" aria-label="language">
                                    <ul class="ut-nav__list ">
                                        <li class="ut-nav__item " data-level-count="1">
                                            <a class="ut-link ut-nav__link" href="?language=de&sharedHtml=<%= request.getParameter("sharedHtml")%>" title=" <% Language.printTextfield(out, session, "sprachauswahl", "Sprache_de");%>" aria-label="<% Language.printTextfield(out, session, "sprachauswahl", "Sprache_de");%>" tabindex="0" rel="nofollow">
                                                <% Language.printTextfield(out, session, "sprachauswahl", "Sprache_de");%>
                                            </a>
                                        </li>
                                        <li class="ut-nav__item " data-level-count="2">
                                            <a class="ut-link ut-nav__link" href="?language=gb&sharedHtml=<%= request.getParameter("sharedHtml")%>" title="<% Language.printTextfield(out, session, "sprachauswahl", "Sprache_en");%>" aria-label="<% Language.printTextfield(out, session, "sprachauswahl", "Sprache_en");%>" tabindex="0" rel="nofollow">
                                                <% Language.printTextfield(out, session, "sprachauswahl", "Sprache_en");%>
                                            </a>
                                        </li>
                                        <li class="ut-nav__item " data-level-count="2">
                                            <a class="ut-link ut-nav__link" href="?language=fr&sharedHtml=<%= request.getParameter("sharedHtml")%>" title="<% Language.printTextfield(out, session, "sprachauswahl", "Sprache_fr");%>" aria-label="<% Language.printTextfield(out, session, "sprachauswahl", "Sprache_fr");%>" tabindex="0" rel="nofollow">
                                                <% Language.printTextfield(out, session, "sprachauswahl", "Sprache_fr");%>
                                            </a>
                                        </li>
                                        <li class="ut-nav__item " data-level-count="2">
                                            <a class="ut-link ut-nav__link" href="?language=la&sharedHtml=<%= request.getParameter("sharedHtml")%>" title="<% Language.printTextfield(out, session, "sprachauswahl", "Sprache_la");%>" aria-label="<% Language.printTextfield(out, session, "sprachauswahl", "Sprache_la");%>" tabindex="0" rel="nofollow">
                                                <% Language.printTextfield(out, session, "sprachauswahl", "Sprache_la");%>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </div>
                    </li>

                    <!-- Switchbar Menu (for low resolutions) -->
                    <li class="ut-switchbar__item" id="switchbar-menu">
                        <a href="#" class="ut-switchbar__toggle" id="ut-identifier--menu-toggle" data-toggle="switchbar" data-target="#switchblock-menu" title="###DT-language_chooser###" aria-label="Menu" role="button" aria-haspopup="true" aria-expanded="false" rel="nofollow">
                            <span class="ut-switchbar__icon ut-icon ut-icon-menu"></span>
                            <span class="ut-switchbar__label sr-only-focusable">Menu</span>
                        </a>
                    </li>

                </ul>
            </nav>
        </div>
        <div class="ut-page-header__banner">
            <div class="ut-page-header__logos">
                <a href="https://www.uni-tuebingen.de" class="ut-logo-link ut-logo-link--main" aria-label="<% Language.printTextfield(out, session, "logo", "AriaLabelUniversitaetTuebingen");%>">
                    <img src="<%=Utils.getBaseUrl(request) + "/gast/vendor/ut-typo3/img/Logo_Universitaet_Tuebingen.svg"%>" class="ut-img ut-img--logo ut-img--logo-main" alt="Logo of the University Tübingen">
                </a>
                <a href="https://www.uni-tuebingen.de/exzellenzinitiative/" class="ut-logo-link ut-logo-link--excellence" aria-label="<% Language.printTextfield(out, session, "logo", "AriaLabelExcellence");%>">
                    <img src="<%=Utils.getBaseUrl(request) + "/gast/vendor/ut-typo3/img/Logo_Universitaet_Tuebingen_Exzellent_EN.svg"%>" class="ut-img ut-img--logo ut-img--logo-excellence-###LANGUAGE_CODE_LOWER###" alt="Logo of the Excellence Strategy">
                </a>
            </div>
            <div class="ut-page-header__dropdowns"></div>
        </div>
        <nav class="ut-nav-area ut-page-header__area_nav" aria-label="###DT-area_navigation###">
            <h4 class="ut-heading ut-nav-area__prev-level">
                <a href="https://www.ub.uni-tuebingen.de" title="<% Language.printTextfield(out, session, "logo", "AriaLabelLibrary");%>" aria-label="<% Language.printTextfield(out, session, "logo", "AriaLabelLibrary");%>" class="ut-link ut-nav-area__link ut-nav-area__link--prev">
                    <% Language.printTextfield(out, session, "library", "Library");%>
                </a>
            </h4>
            <h2 class="ut-heading ut-nav-area__current-level">
                <a class="ut-link ut-nav-area__link" title="<% Language.printTextfield(out, session, "logo", "NomenEtGens");%>" aria-label="<% Language.printTextfield(out, session, "logo", "NomenEtGens");%>"  href="<%=Utils.getBaseUrl(request)%>">
                    <%= DBtoHTML(Language.getTextfield(session, "logo", "NPPM"))%>
                </a>
            </h2>
        </nav>
        <div class="ut-page__switchblock ut-switchblock">
            <div id="switchblock-menu" class="ut-switchblock__item menuBarFitcontent">
                <div class="ut-switchblock__header">
                    <span class="ut-switchblock__title">Menu</span>
                    <span class="ut-switchblock__close-icon ut-icon ut-icon-cancel" role="button"></span>
                </div>
                <div class="ut-switchblock__content" data-breadcrumbuids="0">
                    <nav id="ut-identifier--main-nav" class="ut-nav ut-nav--main lory-slider js_variablewidth variablewidth" data-current-languageuid="###LANGUAGE_UID###">
                        <div class="lory-frame js_frame">
                            <!-- ###TOPNAV### Start -->
                            <ul class="ut-nav__list ut-nav__list--level-1 lory-slides js_slides">
                                <li class="ut-nav__item ut-nav__item--level-1 lory-slides__item js-slide" data-level-count="1">
                                    ${param.current eq 'start' ? '<div class="ut-nav__link-group ut-nav__link-group--is-current">' : ''}
                                    <a class="ut-link ut-nav__link ut-nav__link--level-1 ${param.current eq 'start' ? 'ut-nav__link--is-active' : ''} ut-nav__link--no-sub" href="<%=Utils.getBaseUrl(request)%>/gast/infos?sharedHtml=start&current=start" aria-label="<% Language.printTextfield(out, session, "startseite", "Titel");%>" tabindex="0">
                                        <jsp:include page="../../inc.erzeugeBeschriftung.jsp">
                                            <jsp:param name="Formular" value="startseite"/>
                                            <jsp:param name="Textfeld" value="Titel"/>
                                        </jsp:include>
                                    </a>
                                    ${param.current eq 'start' ? '</div>' : ''}
                                </li>
                                <li class="ut-nav__item ut-nav__item--level-1 lory-slides__item js-slide" data-level-count="2">
                                    ${param.current eq 'einzelbeleg' ? '<div class="ut-nav__link-group ut-nav__link-group--is-current">' : ''}
                                    <a class="ut-link ut-nav__link ut-nav__link--level-1 ${param.current eq 'einzelbeleg' ? 'ut-nav__link--is-active' : ''} ut-nav__link--no-sub" href="<%=Utils.getBaseUrl(request)%>/gast/einzelbeleg?current=einzelbeleg" aria-label="<% Language.printTextfield(out, session, "einzelbeleg", "Titel");%>"  tabindex="0">
                                        <jsp:include page="../../inc.erzeugeBeschriftung.jsp">
                                            <jsp:param name="Formular" value="einzelbeleg"/>
                                            <jsp:param name="Textfeld" value="Titel"/>
                                        </jsp:include>
                                    </a>
                                    ${param.current eq 'einzelbeleg' ? '</div>' : ''}
                                </li>
                                <li class="ut-nav__item ut-nav__item--level-1 lory-slides__item js-slide" data-level-count="3">
                                    ${param.current eq 'person' ? '<div class="ut-nav__link-group ut-nav__link-group--is-current">' : ''}
                                    <a class="ut-link ut-nav__link ut-nav__link--level-1 ${param.current eq 'person' ? 'ut-nav__link--is-active' : ''} ut-nav__link--no-sub" href="<%=Utils.getBaseUrl(request)%>/gast/person?current=person" aria-label="<% Language.printTextfield(out, session, "person", "Titel");%>"  tabindex="0">
                                        <jsp:include page="../../inc.erzeugeBeschriftung.jsp">
                                            <jsp:param name="Formular" value="person"/>
                                            <jsp:param name="Textfeld" value="Titel"/>
                                        </jsp:include>
                                    </a>
                                    ${param.current eq 'person' ? '</div>' : ''}
                                </li>
                                <li class="ut-nav__item ut-nav__item--level-1 lory-slides__item js-slide" data-level-count="4">
                                    ${param.current eq 'namenkommentar' ? '<div class="ut-nav__link-group ut-nav__link-group--is-current">' : ''}
                                    <a class="ut-link ut-nav__link ut-nav__link--level-1 ${param.current eq 'namenkommentar' ? 'ut-nav__link--is-active' : ''} ut-nav__link--no-sub" href="<%=Utils.getBaseUrl(request)%>/gast/lemma?current=namenkommentar" aria-label="<% Language.printTextfield(out, session, "namen", "Namen");%>" tabindex="0">
                                        <jsp:include page="../../inc.erzeugeBeschriftung.jsp">
                                            <jsp:param name="Formular" value="namenkommentar"/>
                                            <jsp:param name="Textfeld" value="Titel"/>
                                        </jsp:include>
                                    </a>
                                    ${param.current eq 'namenkommentar' ? '</div>' : ''}
                                </li>
                                <li class="ut-nav__item ut-nav__item--level-1 lory-slides__item js-slide" data-level-count="5">
                                    ${param.current eq 'quelle' ? '<div class="ut-nav__link-group ut-nav__link-group--is-current">' : ''}
                                    <a class="ut-link ut-nav__link ut-nav__link--level-1 ${param.current eq 'quelle' ? 'ut-nav__link--is-active' : ''} ut-nav__link--no-sub" href="<%=Utils.getBaseUrl(request)%>/gast/quelle?current=quelle" aria-label="<% Language.printTextfield(out, session, "quelle", "Titel");%>" tabindex="0">
                                        <jsp:include page="../../inc.erzeugeBeschriftung.jsp">
                                            <jsp:param name="Formular" value="quelle"/>
                                            <jsp:param name="Textfeld" value="Titel"/>
                                        </jsp:include>
                                    </a>
                                    ${param.current eq 'quelle' ? '</div>' : ''}
                                </li>
                                <li class="ut-nav__item ut-nav__item--level-1 lory-slides__item js-slide" data-level-count="6">
                                    ${param.current eq 'einfaches_ergebnis' ? '<div class="ut-nav__link-group ut-nav__link-group--is-current">' : ''}
                                    <a class="ut-link ut-nav__link ut-nav__link--level-1 ${param.current eq 'einfaches_ergebnis' ? 'ut-nav__link--is-active' : ''} ut-nav__link--no-sub" href="<%=Utils.getBaseUrl(request)%>/gast/einfaches_ergebnis?current=einfaches_ergebnis" aria-label="<% Language.printTextfield(out, session, "suche", "Titel");%>" tabindex="0" rel="nofollow">
                                        <jsp:include page="../../inc.erzeugeBeschriftung.jsp">
                                            <jsp:param name="Formular" value="gast_freie_suche"/>
                                            <jsp:param name="Textfeld" value="Suchen"/>
                                        </jsp:include>
                                    </a>
                                    ${param.current eq 'einfaches_ergebnis' ? '</div>' : ''}
                                </li>
                                <li class="ut-nav__item ut-nav__item--level-1 lory-slides__item js-slide" data-level-count="7">
                                    ${param.current eq 'freie_suche' ? '<div class="ut-nav__link-group ut-nav__link-group--is-current">' : ''}
                                    <a class="ut-link ut-nav__link ut-nav__link--level-1 ${param.current eq 'freie_suche' ? 'ut-nav__link--is-active' : ''} ut-nav__link--no-sub" href="<%=Utils.getBaseUrl(request)%>/gast/freie_suche?current=freie_suche" aria-label="<% Language.printTextfield(out, session, "gast_freie_suche", "Titel");%>" tabindex="0" rel="nofollow">
                                        <jsp:include page="../../inc.erzeugeBeschriftung.jsp">
                                            <jsp:param name="Formular" value="gast_freie_suche"/>
                                            <jsp:param name="Textfeld" value="Titel"/>
                                        </jsp:include>
                                    </a>
                                    ${param.current eq 'freie_suche' ? '</div>' : ''}
                                </li>
                                <li class="ut-nav__item ut-nav__item--level-1 lory-slides__item js-slide jumpIDBoxWrapper" data-level-count="8">
                                    <div class="mobile-fix-menu-item-wrapper">
                                        <form name="jumpForm" method="post" action="<%=Utils.getBaseUrl(request) + "/gast/dojumpid"%>" >
                                        <div style="display: flex; align-items: center; gap: 10px;">
                                            <a class="mobile-fix-menu-item ut-link ut-nav__link ut-nav__link--level-1 ${param.current eq 'freie_suche' ? 'ut-nav__link--is-active' : ''} ut-nav__link--no-sub"
                                               href="#"
                                               onclick="document.querySelector('form[name=jumpForm]').submit(); return false;"
                                               aria-label="ID Button" tabindex="0" rel="nofollow">
                                                ID
                                            </a>
                                            <input class="ut-form__field" type="text" name="jumpValueID" placeholder="z.B. P7404" aria-labelledby="jumpLabel" aria-required="true" style="width: 120px;">
                                            <input type="hidden" name="jumpTableGuest" value="guestTable">
                                            <input type="hidden" name="jumpTable" value="<%= title%>">
                                            <input type="hidden" name="akt" value="<%= id%>">
                                            <input type="hidden" name="ID" value="<%= id%>">
                                            <input type="hidden" name="jumpID" value="los">
                                                 <!-- HIER das aktuelle TAB übergeben -->
                                            <input type="hidden" name="current" value="<%= current %>">
                                        </div>
                                    </form>
                                    </div>
                                </li>
                            </ul>
                            <!-- ###TOPNAV### End -->
                        </div>
                    </nav>
                </div>
            </div>
        </div>
    </div>
</header>
