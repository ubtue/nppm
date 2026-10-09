package de.uni_tuebingen.ub.nppm.util;

import javax.servlet.*;

/**
 * This ContextListener initialized objects to be shared across all tomcat sessions,
 * especially the SessionFactory for DB connections.
 */
public class ContextListener implements ServletContextListener {

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        try {
            de.uni_tuebingen.ub.nppm.db.AbstractBase.initSessionFactory();
        } catch (Exception e) {
            throw new RuntimeException("Application startup failed (could not create DB SessionFactory)", e);
        }
    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        de.uni_tuebingen.ub.nppm.db.AbstractBase.shutdownSessionFactory();
    }
}
