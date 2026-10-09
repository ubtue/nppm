package de.uni_tuebingen.ub.nppm.test.util;

import java.io.*;

public class Properties extends java.util.Properties {

    public void load() throws Exception {
        InputStream input = Properties.class.getClassLoader().getResourceAsStream("junit.properties");
        super.load(input);
    }

    public String getPathNppmFile() {
        return this.getProperty("path.nppm.xml");
    }
}
