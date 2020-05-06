#!/bin/bash

mkdir -p target
TIMESTAMP=`date +"%s"`
PMDRPTFILE=apex-pmd.xml
VFRPTFILE=vf-pmd.xml
CPDRPTFILE=cpd.xml

$PMD_HOME/bin/run.sh pmd -d src -f xml -R rulesets/apex/quickstart.xml -r target/${PMDRPTFILE} -failOnViolation false
$PMD_HOME/bin/run.sh pmd -d src/pages -f xml -R rulesets/apex/quickstart.xml -r target/${VFRPTFILE} -failOnViolation false
$PMD_HOME/bin/run.sh cpd --files src --minimum-tokens 100 --format xml --language apex -failOnViolation false >target/${CPDRPTFILE}