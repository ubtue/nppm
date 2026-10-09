package de.uni_tuebingen.ub.nppm.cli;

import de.uni_tuebingen.ub.nppm.db.*;
import de.uni_tuebingen.ub.nppm.model.*;
import org.jgrapht.graph.*;
import org.jgrapht.nio.*;
import org.jgrapht.nio.csv.*;
import org.jgrapht.nio.dot.*;
import org.jgrapht.nio.gexf.*;
import java.io.FileWriter;
import java.io.Writer;
import java.nio.file.Path;
import java.util.LinkedHashMap;
import java.util.Map;


public class Graph extends AbstractBase {
    // CLI Arguments
    private static Path outputPath;

    private static org.jgrapht.Graph<String, DefaultWeightedEdge> graph = new SimpleWeightedGraph<>(DefaultWeightedEdge.class);

    /**
     * Generate Graph-related data, e.g. for Gephi or Graphviz
     */
    public static void main (String[] args) throws Exception {
        // Load Properties (DB access credentials, etc.)
        LoadProperties();

        // Process args
        switch (args.length) {
            case 1:
                outputPath = Path.of(args[0]);
                break;
            default:
                Usage("Usage: Graph <outputPath(.csv|.dot|.gexf)> ");
        }

        generateGraph();
        exportGraph();

        // Exit successfully (we need this or the program will hang forever)
        System.exit(0);
    }

    private static void addVertex(Person person) {
        if (!graph.containsVertex(person.getPersistentIdentifier())) {
            graph.addVertex(person.getPersistentIdentifier());
        }
    }

    private static void addEdge(Person person1, Person person2, double weight) {
        // quick & dirty workaround in case we run into non-public persons for some reason (should never happen!)
        addVertex(person1);
        addVertex(person2);

        // Try to find existing edge (bidirectional / undirected), increment weight if possible
        DefaultWeightedEdge edge = null;
        edge = graph.getEdge(person1.getPersistentIdentifier(), person2.getPersistentIdentifier());
        if (edge == null) {
            edge = graph.getEdge(person2.getPersistentIdentifier(), person1.getPersistentIdentifier());
        }
        if (edge != null) {
            graph.setEdgeWeight(edge, graph.getEdgeWeight(edge) + weight);
        } else {
            // or insert new edge if non exists
            edge = graph.addEdge(person1.getPersistentIdentifier(), person2.getPersistentIdentifier());
            graph.setEdgeWeight(edge, weight);
        }
    }


    private static void generateGraph() throws Exception {
        // select all public quellen as starting point
        Log("Baue Graph...");
        for (var quelle : QuelleDB.getListPublic()) {
            Log("Verarbeite Quelle " + quelle.getPersistentIdentifier());
            var belege = quelle.getEinzelbelege();
            for (var beleg : belege) {
                var personen = beleg.getPerson();
                for (var person : personen) {
                    // Unclear / always add person even if there are no relations?
                    // Makes graph a lot bigger, but is this really useful?
                    // addVertex(person, 1);

                    // Add persons who are directly related within the same Einzelbeleg
                    for (var person2 : personen) {
                        if (!person.getPersistentIdentifier().equals(person2.getPersistentIdentifier())) {
                            addEdge(person, person2, 10);
                        }
                    }

                    // Add persons from other einzelbelege on the same page (depending on raster if available)
                    if (beleg.getSeite() != null) {
                        for (var beleg2 : belege) {
                            if (!beleg.getPersistentIdentifier().equals(beleg2.getPersistentIdentifier())) {
                                double weight = 1;
                                if (beleg.getSeite().equals(beleg2.getSeite())) {
                                    ++weight;

                                    if (beleg.getRaster() != null && beleg.getRaster().equals(beleg2.getRaster()))  {
                                        ++weight;
                                    }
                                    if (beleg.getSchreiber() != null && beleg.getSchreiber().equals(beleg2.getSchreiber()))  {
                                        ++weight;
                                    }
                                }
                                for (var person2 : beleg2.getPerson()) {
                                    if (!person2.getPersistentIdentifier().equals(person.getPersistentIdentifier())) {
                                        addEdge(person, person2, weight);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private static void exportGraph() throws Exception {
        if (outputPath.toString().endsWith(".csv")) {
            Log("Exportiere als CSV");

            // ADJACENCY_LIST for Gephi
            CSVExporter<String, DefaultWeightedEdge> exporter =
            new CSVExporter<>(CSVFormat.ADJACENCY_LIST);

            // Vertex ID (important für CSV)
            exporter.setVertexIdProvider(v -> v);

            // Optional: Edge Label
            exporter.setEdgeIdProvider(e -> e.toString());

            try (Writer writer = new FileWriter(outputPath.toString())) {
                exporter.exportGraph(graph, writer);
            }
        } else if (outputPath.toString().endsWith(".dot")) {
            Log("Exportiere als DOT");
            DOTExporter<String, DefaultWeightedEdge> exporter = new DOTExporter<>();
            exporter.setVertexAttributeProvider((v) -> {
                Map<String, Attribute> map = new LinkedHashMap<>();
                map.put("label", DefaultAttribute.createAttribute(v));
                return map;
            });
            exporter.setEdgeAttributeProvider(e -> {
                Map<String, Attribute> map = new LinkedHashMap<>();
                double weight = graph.getEdgeWeight(e);
                map.put("label", DefaultAttribute.createAttribute(weight));
                map.put("weight", DefaultAttribute.createAttribute(weight)); // optional für DOT
                return map;
            });
            try (Writer writer = new FileWriter(outputPath.toString())) {
                exporter.exportGraph(graph, writer);
            }
        } else if (outputPath.toString().endsWith(".gexf")) {
            Log("Exportiere als GEXF");
            GEXFExporter<String, DefaultWeightedEdge> exporter = new GEXFExporter<>();
            exporter.setVertexIdProvider(v -> v);
            exporter.setEdgeAttributeProvider(e -> {
                Map<String, Attribute> map = new LinkedHashMap<>();
                double weight = graph.getEdgeWeight(e);
                map.put("label", DefaultAttribute.createAttribute(weight));
                map.put("weight", DefaultAttribute.createAttribute(weight));
                return map;
            });
            try (Writer writer = new FileWriter(outputPath.toString())) {
                exporter.exportGraph(graph, writer);
            }
        } else {
            Log("Export fehlgeschlagen, unbekanntes Zielformat (unterstützt wird .csv|.dot|.gexf): " + outputPath);
            return;
        }

        Log("Export fertig: " + outputPath);
    }

}
