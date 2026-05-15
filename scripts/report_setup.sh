#!/bin/bash

# report_setup.sh - First time run thru

echo "<<<<INITIAL SETUP>>>>>"

echo "+++++CHECKING TEMPLATES++++++++"

Rscript inst/scripts/01_check_all_templates.R

echo "CREATING DATA FILES"

Rscript inst/scripts/02_data_processor_module.R

echo "GENERATING DOMAIN FILES"

Rscript inst/scripts/03_generate_domain_files.R

echo "...GENERATING ALL TABLES AND FIGURES..."

Rscript inst/scripts/04_generate_all_domain_assets.R

echo "!!!DONE WITH SETUP!!!"
