<?php

$xml = simplexml_load_file('vysledky_krajmesta.xml');
//print_r($xml);

$vse = array();
for ($i = 0; $i < count($xml->KRAJ); $i++) {

    $uvnitr = count($xml->KRAJ[$i]->CELKEM->HLASY_STRANA);

    $x = 0;
    while ($x < $uvnitr) {
        $vse[$i][$x] = $xml->KRAJ[$i]->CELKEM->HLASY_STRANA[$x]['HLASY'];
        $x++;
    }
}
// print_r($vse);

$procenta = array();
for ($i = 0; $i < count($vse); $i++) {

    $uvnitrProcenta = count($vse[$i]);

    $x = 0;
    $proc = 97; // Meneni

    while ($x < $uvnitrProcenta) {
        $procNahodne = $proc + rand(0, 3) . "\n";
        $procenta[$i][$x] = $vse[$i][$x] * ($procNahodne / 100);
        $x++;
    }
}
// print_r($procenta);

/* ------------------------------------- */
for ($i = 0; $i < count($xml->KRAJ); $i++) {

    $uvnitr = count($xml->KRAJ[$i]->CELKEM->HLASY_STRANA);

    $x = 0;
    while ($x < $uvnitr) {
        $xml->KRAJ[$i]->CELKEM->HLASY_STRANA[$x]['HLASY'] = $procenta[$i][$x] . "\n";
        $x++;
    }
}
$xml->asXML("vysledky_krajmesta-" . $proc . "procent.xml");
?>