# README

This repository provides the source codes and outcomes presented in the PhD thesis entitled _Quality in use evaluation of smart environment applications by agent-based simulation_ presented on December 11th of 2025 in Université Polytechnique Hauts-de-France.

- the **abms** directory provides the agent-based model and simulation developed in NetLogo (the software needs to be installed in your machine for the experiment to be executed);
- the **abms-observer** directory provides the abms observer, supposed to launch both the abms and the software application under evaluation (**Help Me!** or **ParkinsonCom**);
- the **process-mining** directory provides the source code for the data mining technique that finds patterns between the motion sensors turning on and off (and for how long) and informing the abms;
- the **auxiliary** directory provides Python scripts that auxiliate in the data extraction from the SQL databases;
- the **interaction-log-data** directory provides the outcome from the interaction between the abms and the software applications under evaluation;
- the **simulation-log-data** directory provides the outcome from the simulation executed in the abms in NetLogo;
- the **qinu-measures** directory provides the outcome of the measurements for the selected QinU characteristics;
- the **webpage** directory provides the source code for the software application evaluated in the proof of concept, the **Help Me!** webpage.

## How to execute the methodology for ParkinsonCom
- Install the apk file of ParkinsonCom in an Android emulator. As this file is larger than 25MB, it is not possible to upload it to GitHub and it will be provided upon demand. In this experimental study, the application was executed on Nox;
- Register at least one primary contact and set up the medicine alarm;
- To initiate the process, launch the **abms-observer** for the ParkinsonCom application;
- This will then launch both the **abms** and **ParkinsonCom**;
- Allow for the coded sequence to follow its flow;
- **ATTENTION:** for the replication of this experiment, it is necessary to adapt the script to open your emulator of choice (e.g., Nox) and the coordinates of your computer screen according to the AutoIt software (because the AutoIt library for Python was employed in this experimental study);
- Once finished, the log data will be stored for both the **abms** and **ParkinsonCom**, ready for the extraction of relevant data.

## How to execute the methodology for Help Me!
- The source code of the webpage must be compiled and executed using a web server environment. In this experimental study, the application was run locally using IIS Express, which allows you to host and test the website on your local machine;
- To initiate the process, launch the Python script for the **abms-observer** of the Help Me! application;
- This will then launch both the **abms** and the **webpage**;
- Allow for the coded sequence to follow its flow;
- Once finished, the log data will be stored for both the **abms** and the **webpage**, ready for the extraction of relevant data.
