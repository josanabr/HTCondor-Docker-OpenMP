# III Workshop Computational Platforms
This workshop is aimed to anyone with an interest in topics such as High Performance Computing, Computational modeling and Distributed Systems. The presentations will be carried out in Spanish.

## HTCondor's workshop goals

The objective of this workshop is to give asistants a brief introduction of how to use HTCondor as a new tool in their research processes.


## Examples

The examples are:

 - Ex01: A simple example of how to define and execute a set of jobs in HTCondor.
 - Ex02_R: This example shows how to use Docker and HTCondor to process a set of data using R language.
 - Ex03_OctaveDagman: This last example shows how to create workflows which allows the user to define dependencies between jobs.

## Important
When you clone/download this files, run the next commands to prevent execution issues:
 - cd 2019_HTCondor
 - find . -iname "*.bash" -type f -exec chmod +x {} \;
 