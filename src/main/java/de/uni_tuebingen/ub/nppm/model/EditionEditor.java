package de.uni_tuebingen.ub.nppm.model;

import javax.persistence.*;

@Entity
@Table(name = "edition_hateditor")
public class EditionEditor {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Integer id;

    @ManyToOne(targetEntity = Edition.class)
    @JoinColumn(name = "EditionID", referencedColumnName="ID")
    private Edition edition;

    @ManyToOne(targetEntity = SelektionEditor.class)
    @JoinColumn(name = "EditorID", referencedColumnName="ID")
    private SelektionEditor editor;

    public Integer getId() {
        return id;
    }

    public Edition getEdition() {
        return edition;
    }

    public void setEdition(Edition edition) {
        this.edition = edition;
    }

    public SelektionEditor getEditor() {
        return editor;
    }

    public void setEditor(SelektionEditor editor) {
        this.editor = editor;
    }
}
