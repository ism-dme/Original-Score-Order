const fs = require("fs");
const { exec } = require("child_process");

const firstMovement = 'dmeedtA_165-001.mei';
const fourthMovement = 'dmeedtA_165-004.mei';

// Get movement from command line arguments
const movement = process.argv[2]; // Expecting '1' or '4'
if (!["1", "4"].includes(movement)) {
    console.error("Usage: node script.js <movement>\nMovement must be '1' or '4'.");    
    process.exit(1);
}

// Select the correct movement file
const movementFile = movement === "1" ? firstMovement : fourthMovement;
const outputFile = `./mei/output/dmeedtA_165-00${movement}_Autograph.mei`;

console.log('Prcessing: ' + movementFile);

// Define commands
const reorderStavesCmd = `node node_modules/xslt3/xslt3.js "-s:./mei/source/${movementFile}" "-xsl:./dist/sef/reorder-staves.sef.json" "-o:./mei/temp_reordered.mei"`;
const extractPartsCmd = `node node_modules/xslt3/xslt3.js "-s:./mei/temp_reordered.mei" "-xsl:./dist/sef/extract-parts.sef.json" "-o:${outputFile}" "?P_OVERWRITE_FILE=true()"`;


exec(reorderStavesCmd, (error, stdout, stderr) => {
    if (error) {
        console.error(`Error running reorder-staves: ${error.message}`);
        return;
    }
    if (stderr) console.error(`Reorder stderr: ${stderr}`);

    // Ensure temp file is written before running next step
    // fs.writeFileSync("./mei/temp_reordered.mei", stdout, "utf-8");

    exec(extractPartsCmd, (err, out, errOut) => {
        if (err) {
            console.error(`Error running extract-parts: ${err.message}`);
            return;
        }
        if (errOut) console.error(`Extract stderr: ${errOut}`);

        console.log(`Transformation finished!\nWriting output file to ${outputFile}`);

        // Cleanup temp file
        fs.unlinkSync("./mei/temp_reordered.mei");
    });
});
