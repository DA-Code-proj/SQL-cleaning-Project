# SQL-cleaning-Project

Cleaned and standardized a raw dataset of global layoffs to prepare it for accurate analysis. The dataset contained duplicates, inconsistent formatting, null values, and unstructured text fields that needed transformation before meaningful insights could be extracted.

Situation:
I worked with a raw layoffs dataset containing duplicates, inconsistent formatting, null values, and unstructured text fields, making it unreliable for analysis.

Task:
My goal was to clean and standardize the dataset so it could be used for accurate analysis of layoff trends across industries, companies, and time periods.

Action:
Removed duplicates using ROW_NUMBER() and created a clean staging table.
Standardized text fields (company names, industries, country names).
Converted date strings into proper SQL DATE format.
Filled missing industries using other company/location references.
Deleted rows with no useful layoff information.

Result:
Produced a clean, structured dataset free of duplicates and inconsistencies, enabling accurate and efficient analysis of global layoff patterns.
