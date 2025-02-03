# original_scoring

Testing repository for the [Original Scoring](https://gitlab.mozarteum.at/groups/dme/dime/-/milestones/7#tab-issues) project.

Commands:
- `cd saxonJS`
- `npm i`
- Run reorder-staves: `node node_modules/xslt3/xslt3.js "-s:./input/dmeedtA_165-001_2626.xml" "-xsl:./xsl/reorder-staves.sef.json" "-o:./output/dmeedtA_165-001_2626_reordered.xml"`
- Run extract-parts: `node node_modules/xslt3/xslt3.js "-s:./input/dmeedtA_165-001_2626_reordered.xml" "-xsl:./xsl/extract-parts.sef.json" "-o:./output/dmeedtA_165-001_2626_originalScoring.xml" "?P_MOVI=true()"`


`node node_modules/xslt3/xslt3.js "-s:./input/dmeedtA_165-001_2626_reordered.xml" "-xsl:./xsl/extract-parts.sef.json" "-o:./output/dmeedtA_165-001_2626_originalScoring.xml" "P_USER_PARAMETERS=" "?P_MOVI=true()"`
