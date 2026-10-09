# Solr: Experimental!

This directory + the Solr functionality is experimental & could serve as a simple proof-of concept for the funding period 2025+.

Installation:
- Download the latest Solr Binary release (tested with 9.11.0) from https://solr.apache.org/downloads.html + extract it to the "vendor" directory
- Execute `solr.sh --force start` (NOT in the vendor directory => use the script in the same directory as this README file)
  - (--force is only needed if you try to run as root user)
- Check http://localhost:8984/solr/#/einzelbeleg/query to make sure that the Solr instance is running.
- Import some sample data e.g. by using `import.sh` in this directory
    - (This will just import a small amount of test datasets. You can use the Java CLI class ExportSolr if you need more test data later)
- Execute a sample query, e.g. http://localhost:8984/solr/einzelbeleg/select?q=*:*&df=belegform&fl=*,score&facet=true&facet.field=quelle&facet.mincount=1
- Open http://localhost:8984/neg/gast/solr for a basic Servlet+jsp example

Notes:
- This is just a simple development environment. To use it on the servers we must move the directory structure out of the repository, e.g. to /usr/local/nppm/solr/...
- The instance is actually configured to run on port 8984 instead of 8983 to avoid conflicts with other services.
- Later on we might need to add multiple variants of the same field when importing (e.g. quelle_string for facets + quelle_text for fulltext search).
