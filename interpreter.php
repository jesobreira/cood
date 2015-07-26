<?php

/*
	Cood language
*/

$cells = array();
for($i = 0; $i <= 65535; $i++) {
	$cells[$i] = 0;
}

$pointer = 32767; // we start at this cell

$file = $argv[1];

if(!file_exists($file)) die("Pardon monsieur, but we can't understand you.\n");

$c = file($file);
$c = array_map('trim', $c);

$n = 0;
//foreach($c as $l) {
$j = sizeof($c);

for($i = 0; $i<=$j; $i++) {
	$n++;
	$l = $c[$i];
	if(wildcard("Know a joke*", $l)) continue;
	if(wildcard("The bill*please*", $l)) exit;
	if(wildcard("I want this*", $l)) $cells[$pointer] += 1;
	if(wildcard("I don*t want this*", $l)) $cells[$pointer] -= 1;
	if(wildcard("What do you have for dessert*", $l)) $pointer += 1;
	if(wildcard("What do you have for tidbit*", $l)) $pointer -= 1;
	if(wildcard("May I ask something*", $l)) $cells[$pointer] = ((int)gets());
	if(wildcard("I*m hungry*", $l)) printf("%c\n", $cells[$pointer]);
	if(wildcard("I*m very hungry*", $l)) printf("%c", $cells[$pointer]);
	if(wildcard("How much is it*", $l)) printf("%d", $cells[$pointer]);
	if(wildcard("I hate this*", $l)) $cells[$pointer] = 0;
	
	// get number
	if(wildcard("I want * of this*", $l)) {
		$num = (int)(str_replace(array("I want ", " of this.", " of this"), null, $l));
		$cells[$pointer] = $num;
	}
	
	// add number
	if(wildcard("More * of this*", $l)) {
		$num = (int)(str_replace(array("More ", " of this.", " of this"), null, $l));
		$cells[$pointer] += $num;
	}
	
	// subtract number
	if(wildcard("Less * of this*", $l)) {
		$num = (int)(str_replace(array("Less ", " of this.", " of this"), null, $l));
		$cells[$pointer] -= $num;
	}
	
	// loop
	if($l == "What do you suggest?") {
		$loop_line = $i;
	}
	
	if($l == "Nothing more?") {
		if($cells[$pointer]>0 AND isset($loop_line)) {
			$i = $loop_line;
		}
	}
	
	if(isset($argv[2]) AND $argv[2]=='--debug') echo "\nPointer: $pointer  / Value: $cells[$pointer] / Line $i: $l\n";
}

function wildcard($pattern, $string) {
	//echo "\n".$pattern.'   '.$string.'    '.(preg_match("#^".strtr(preg_quote($pattern, '#'), array('\*' => '.*', '\?' => '.'))."$#i", $string) ? 's' : 'n');
	return preg_match("#^".strtr(preg_quote($pattern, '#'), array('\*' => '.*', '\?' => '.'))."$#i", $string);
} 

function gets($length='255') 
{ 
   if (!isset ($GLOBALS['StdinPointer'])) 
   { 
      $GLOBALS['StdinPointer'] = fopen ("php://stdin","r"); 
   } 
   $line = fgets ($GLOBALS['StdinPointer'],$length); 
   return trim ($line); 
} 
