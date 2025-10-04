# README

This repository provides the source codes and outcomes presented in the PhD thesis entitled _Quality in use evaluation of smart environment applications by agent-based simulation_ to be presented on December 12th of 2025 in Université Polytechnique Hauts-de-France.

- the **abms** directory provides the agent-based model and simulation coded in NetLogo;
- the **abms-observer** directory provides the abms observer, supposed to launch both the abms and the software application under evaluation (**Help Me!** or **ParkinsonCom**);
- the **process-mining** directory provides the source code for the data mining technique that finds patterns between the motion sensors turning on and off (and for how long) and informing the abms;
- the **auxiliary** directory provides Python scripts that auxiliate in the data extraction from the SQL databases;
- the **interaction-log-data** directory provides the outcome from the interaction between the abms and the software applications under evaluation;
- the **simulation-log-data** directory provides the outcome from the simulation executed in the abms in NetLogo;
- the **qinu-measures** directory provides the outcome of the measurements for the selected QinU characteristics;
- the **webpage** directory provides the source code for the software application evaluated in the proof of concept, the **Help Me!** webpage.

As the apk file for ParkinsonCom is larger than 25MB, it is not possible to upload it to GitHub. It will be provided upon demand.

## How to execute the methodology for ParkinsonCom
- Install the APK file of ParkinsonCom in an Android emulator. In this experimental study, the application was run on Nox;
- Register at least one primary contact and set up the medicine alarm;
- To initiate the process, launch the **abms-observer** for the ParkinsonCom application;
- This will then launch both the **abms** and the **ParkinsonCom**;
- Allow for the coded sequence to follow its flow;
- **ATTENTION:** for the replication of this experiment, it is necessary to adapt the script to open your emulator of choice (e.g., the Nox application) and the coordinates of your computer screen as provided by the AutoIt software (as the AutoIt library for Python was employed in this experimental study).

## How to execute the methodology for Help Me!
- The source code of the webpage must be compiled and executed using a web server environment. In this experimental study, the application was run locally using IIS Express, which allows you to host and test the website on your local machine;
- To initiate the process, launch the Python script for the **abms-observer** for the Help Me! application;
- This will then launch both the **abms** and the **webpage**;
- Allow for the coded sequence to follow its flow;
- The log data will be stored, ready for the extraction of relevant data.
