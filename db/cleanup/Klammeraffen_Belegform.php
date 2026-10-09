<?php

/**
 * This script is used to generate a sql patch
 * out of the xlsx (csv) file that Steffen Patzold provided in May 2025.
 */

$csvPath = 'Klammeraffen_Belegform.csv';
$sqlPathNeg = 'Klammeraffen_Belegform.neg.sql';
$sqlPathDmp = 'Klammeraffen_Belegform.dmp.sql';

// Parse CSV file & generate simple numeric array
function parseCsv(string $csvPath) : array {
    $rows = [];
    $handle = fopen($csvPath, 'r');
    while (($row = fgetcsv($handle, 1000, ',', '"')) !== false) {
        $rows[] = $row;
    }
    fclose($handle);
    return $rows;
}

function normalizeData(array $rows): array {
    $result = [];
    unset($rows[0]); // ignore header
    foreach ($rows as $row) {
        $result[] = ['to_replace' => trim($row[0]), 'replacement' => trim($row[1])];
    }
    return $result;
}

function escapeMysql($string, $enclosure="'") {
    return str_replace($enclosure, '\\' . $enclosure, $string);
}

function escapePostgresql($string, $enclosure="'") {
    return str_replace($enclosure, $enclosure . $enclosure, $string);
}

function generateSqlForNeg(array $data) : string {
    $sql = 'BEGIN;' . PHP_EOL;
    foreach ($data as $entry) {
        $sql .= 'UPDATE einzelbeleg SET Belegform = REPLACE(Belegform, \'' . escapeMysql($entry['to_replace']) . '\', \'' . escapeMysql($entry['replacement']) . '\');' . PHP_EOL;
    }
    $sql .= 'COMMIT;' . PHP_EOL;
    return $sql;
}

function generateSqlForDmp(array $data) : string {
    $sql = 'BEGIN;' . PHP_EOL;
    foreach ($data as $entry) {
        $sql .= 'UPDATE namen SET pn_text = REPLACE(pn_text, \'' . escapePostgresql($entry['to_replace']) . '\', \'' . escapePostgresql($entry['replacement']) . '\');' . PHP_EOL;
    }
    $sql .= 'COMMIT;' . PHP_EOL;
    return $sql;
}

$rows = parseCsv($csvPath);
$data = normalizeData($rows);
$sqlNeg = generateSqlForNeg($data);
file_put_contents($sqlPathNeg, $sqlNeg);
$sqlDmp = generateSqlForDmp($data);
file_put_contents($sqlPathDmp, $sqlDmp);
