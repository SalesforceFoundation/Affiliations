#!/bin/bash

ECHO "# === Create a temporary org definition file with sample data disabled"
mv orgs/feature.json orgs/feature-save.json
jq '.hasSampleData = false' orgs/feature-save.json > orgs/temp.json
jq '.orgName = "NPSP - Translations"' orgs/temp.json > orgs/feature.json

ECHO "# ==== CREATE THE SCRATCH ORG ===="
cci org remove translations
cci org scratch feature translations --days 1
cci flow run dependencies --org translations 
cci flow run deploy_unmanaged --org translations
cci task run update_admin_profile --org translations

rm orgs/temp.json
mv orgs/feature-save.json orgs/feature.json

ECHO "# ==== RESET the Package.xml and use retrieve_unpackaged to pull down the metadata ===="
git checkout src/package.xml
cci task run retrieve_unpackaged --org translations -o path src -o package_xml src/package.xml

cci org remove translations

ECHO "# ==== DISCARD other files pulled down by the above task that we do not need ===="
git checkout src/applications/*
git checkout src/aura/*
git checkout src/classes/*
git checkout src/components/*
git checkout src/customMetadata/*
git checkout src/email/*
git checkout src/featureParameters/*
git checkout src/labels/*
git checkout src/layouts/*
git checkout -- src/lwc
git checkout src/objects/*
git checkout src/pages/*
git checkout src/reports/*
git checkout src/tabs/*
git checkout src/triggers/*
git checkout src/package.xml

ECHO "# ==== CLEANUP task to strip out extraneous elements from the translation files ===="
cci task run cleanup_translation_metadata

ECHO "# ==== DONE! - Review the remaining modified translation files before committing back into the branch"
