# Original Score Order


This repository contains a tool for modifying the score order, along with example MEI encodings on which the tool operates. Both were developed as part of the [Digital Mozart Edition](dme.mozarteum.at) (DME), a long-term research and editing project of the Mozarteum Foundation Salzburg (Austria) and the Packard Humanities Institute (Los Altos, USA).


- [Introduction](#introduction)
- [Installation and Usage](#installation-and-usage)
- [Developing](#developing)



## Introduction

The MEI files include the first and fourth movements of the motet [Exsultate, jubilate](https://kv.mozarteum.at/de/work/exsultate-jubilate-2625), KV 165 (first and fourth movements) by W. A. Mozart. The encodings use the _Neue Mozart Ausgabe_ as a reference source, which follows the standard score order (see the image on the left). The transformation changes the score order to the one originally used by the composer.

The differences in the score order are as follows:

- the order of winds and strings is swapped
- the _Soprano_ part has a different clef
- the oboe parts are split onto two staves in the Autograph

<img width="600" alt="NMA vs. Autograph." src="./docs/pct/NMAvsAutograph.png">

<hr>

DME has developed a tools pipeline that transforms the standard score order to the original score order. The process consists of the following steps:

1. Reordering the staves.
2. Splitting oboe parts.

<img width="600" alt="Transformation pipeline." src="./docs/pct/transformationPipeline.png">

## Installation and Usage

The transformation pipeline is implemented in XSLT. For users of the oXygen XML Editor, the repository includes a project file named `original-score-order.xpr`, which can be opened either by double-clicking it in the file explorer or by selecting it from the project view within the oXygen XML Editor.

After opening the project, you can apply the transformation scenario `original-score-order-KV165` to the files located in `./mei/source` folder.

<img width="400" alt="Transformation scenario." src="./docs/pct/transformationScenario.png">


This will output transformed MEI files to the `./mei/source/out` folder.

<hr>

Alternatively, you can use the free saxonJS processor using the command line. First you need to install nodeJS. Then run the following commands from the root of the repository.

```bash
# Install packages
npm i
```

```
# Run transformation
# Replace <movementNo> by '1' or '4' depending which movement of KV 165 you want to process.
node .\original-score-order.js <movementNo>
```

# Developing

The transformation pipeline consists of two distinct tools:

1. `Reorder Staves`
2. `Extract Parts`

The folder `./dist`contains compiled files for these transformations that can be used with the Saxon processor. The folder `./dist/xsef` contains files for use with the Java version of the Saxon and the folder `./dist/sef` contains files for use with saxonJS.

THe source files are located in the following folders:

1.  `./Reorder-Staves`                        
2. `./Extract-Parts` (as submodule)

The tools can be used separately from each other. See the REDME files in the repositories for usage details.

Note that development takes place in an internal GitLab repository, and the GithUb serves only as a publishing platform.



