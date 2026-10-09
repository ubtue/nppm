package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.Table;
import org.hibernate.annotations.Type;

@Entity
@Table(name = "content")
public class Content {

    public enum Context {
        NAMENKOMMENTAR,
        QUELLENKOMMENTAR,
        UEBERLIEFERUNGSKOMMENTAR,
        CMS
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    int ID;

    @Column(name = "Bezeichnung", length = 255)
    String name;

    @Column(name = "contentType", length = 55)
    String content_Type;

    @Lob
    @Type(type = "org.hibernate.type.ImageType")
    @Column(name = "content", nullable = false, columnDefinition = "blob")
    private byte[] content;

    @Enumerated(EnumType.STRING)
    @Column(name = "context", nullable = false)
    private Context context;

    @Column(name = "language", length = 255)
    String language;

    //Constructors
    //Default Constructor is neccessary !!! - don delete
    public Content() {
    }

    public Content(String name, String content_Type, byte[] content, Context context) {
        this.name = name;
        this.content_Type = content_Type;
        this.content = content;
        this.context = context;
    }

    public Content(String name, String content_Type, byte[] content, Context context, String language) {
        this.ID = ID;
        this.name = name;
        this.content_Type = content_Type;
        this.content = content;
        this.context = context;
        this.language = language;
    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getContent_Type() {
        return content_Type;
    }

    public void setContent_Type(String content_Type) {
        this.content_Type = content_Type;
    }

    public byte[] getContent() {
        return content;
    }

    public void setContent(byte[] content) {
        this.content = content;
    }

    public Context getContext() {
        return context;
    }

    public void setContext(Context context) {
        this.context = context;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

}//end Class
