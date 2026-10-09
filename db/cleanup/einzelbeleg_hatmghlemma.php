<?php

/**
 * This script is used to generate a sql patch
 * out of the xlsx (csv) that was generated mid 2025 after DMP import.
 */

$csvPath = 'einzelbeleg_hatmghlemma.csv';
$sqlPath = 'einzelbeleg_hatmghlemma.sql';

// Parse CSV file & generate simple numeric array
function parseCsv(string $csvPath) : array {
    $rows = [];
    $handle = fopen($csvPath, 'r');
    while (($row = fgetcsv($handle, 1000, ';', '"')) !== false) {
        $rows[] = $row;
    }
    fclose($handle);
    return $rows;
}

// Convert array with numeric columns
// into grouped array (by Belegform) with named columns
function groupCsvData(array $rows) : array {
    $data = [];
    foreach ($rows as $i => $row) {
        if ($i > 0) {
            $dataset = [
                'group' => $row[0],
                'einzelbelegId' => $row[1],
                'einzelbelegBelegform' => $row[2],
                'mghLemmaId' => $row[3],
                'mghLemmaText' => $row[4],
                'provenience' => $row[5],
                'winner' => $row[6],
            ];
            $groupKeyField = 'group';
            $groupKey = $dataset[$groupKeyField];
            if (!isset($data[$groupKey])) {
                $data[$groupKey] = [];
            }
            $data[$groupKey][] = $dataset;
        }
    }
    return $data;
}

// Generate SQL statements
function generateSqlStatements(array $data): string {
    $sql = 'BEGIN;' . PHP_EOL;
    foreach ($data as $groupKey => $datasets) {
        // check for diacritical characters
        foreach ($datasets as $dataset) {
            if (!preg_match('"^[a-zA-Z\[\].]*$"', $dataset['einzelbelegBelegform'])) {
                print 'WARNUNG: Diakritische Zeichen "' . $dataset['einzelbelegBelegform'] . '" in Gruppe: "' . $groupKey . '"' . PHP_EOL;
                continue 2;
            }
        }

        // detect the winner
        $winnerLemmaId = null;
        foreach ($datasets as $dataset) {
            if (!empty($dataset['winner']) && trim($dataset['winner']) != '') {
                if (trim($dataset['winner']) == 'x') {
                    if ($winnerLemmaId != null) {
                        echo 'WARNUNG: Mehrere Gewinner für Gruppe: "' . $groupKey . '"' . PHP_EOL;
                        continue 2;
                    }
                    $winnerLemmaId = $dataset['mghLemmaId'];
                } else {
                    print 'WARNUNG: Unbekannte Gewinner-Markierung "' . $dataset['winner'] . '" für Gruppe: "' . $groupKey . '"' . PHP_EOL;
                    continue 2;
                }
            }
        }

        if ($winnerLemmaId == null) {
            echo 'WARNUNG: Kein Gewinner für Gruppe: "' . $groupKey . '"' . PHP_EOL;
            continue;
        }

        // Generate SQL statements wherever necessary
        foreach ($datasets as $dataset) {
            if ($dataset['mghLemmaId'] != $winnerLemmaId) {
                $sql .= 'UPDATE einzelbeleg_hatmghlemma SET MGHLemmaID=' . $winnerLemmaId . ' WHERE MGHLemmaID=' . $dataset['mghLemmaId'] . ' AND EinzelbelegID=' . $dataset['einzelbelegId'] . ';' . PHP_EOL;
            }
        }
    }
    $sql .= 'COMMIT;' . PHP_EOL;
    return $sql;
}

$rows = parseCsv($csvPath);
$data = groupCsvData($rows);
$sql = generateSqlStatements($data);
file_put_contents($sqlPath, $sql);
