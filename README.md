# HTCondor - All in one

En este repositorio se encuentran los archivos necesarios para hacer el despliegue de Docker + HTCondor (All-in-one). 
En una máquina virtual se instalará [Docker](https://www.docker.com) y [HTCondor](https://research.cs.wisc.edu/htcondor/) y se tendrá un sistema funcional con estas dos herramientas usadas en entornos de HTC (*Hight Throughput Computing*).

## Requerimientos

Instalar la herramienta [vagrant](https://vagrantup.com).
Durante el desarrollo de los scripts en este repositorio se usó la versión 2.2.5 de Vagrant.

---

## Pasos para el despliegue Docker + HTCondor (All-In-One)

Asumiendo que se ha instalado `vagrant` y desde una terminal, ubíquese en el directorio donde se encuentren los archivos listados en este directorio de este repositorio.
Una vez en el directorio ejecutar los siguientes pasos:

```
vagrant up
```

## Validando Docker y HTCondor

La máquina virtual desplegada instala Docker y HTCondor.
A continuación se describe como validar que ha sido correcta la instalación.

### Verificando instalación de Docker

Ejecute los siguientes comandos:

```
vagrant ssh
docker run --rm hello-world
```

Debería aparecer algo como esto:

```
Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

### Verificando instalación de HTCondor

Ingrese en la máquina virtual recien desplegada y ejecute los siguienes comandos:

```
cd /vagrant
condor_submit demo.condor
```

Debería aparecer algo como esto:

```
Submitting job(s).
1 job(s) submitted to cluster 1.
```

Y para validar la correcta ejecución ejecutar:

```
cat hostOut.0
```

Debería aparecer:

```
_condor_stderr
_condor_stdout
condor_exec.exe
```

### Validando Docker en HTCondor

Ingrese en la máquina virtual recien desplegada y ejecute los siguienes comandos:

```
cd /vagrant
condor_submit docker.condor
```

Debería aparecer en pantalla algo como esto:

```
Submitting job(s).
1 job(s) submitted to cluster 2.
```

Validar el archivo de salida `out.0`:

```
cat out.0
```

Y debería aparecer una fecha, algo como esto:

```
Sat Jul 13 16:30:48 UTC 2019
```
---

# Pruebas de rendimiento

Las pruebas de rendimiento se llevaron en cuatro escenarios:

* OpenMP sobre la máquina virtual
* OpenMP en Docker sobre la máquina virtual
* OpenMP corriendo en contenedor de Docker como tarea de HTCondor sobre la máquina virtual
* OpenMP corriendo en contenedor de Docker como tarea de HTCondor sobre la máquina virtual __*slots dinámicos*__

## Preliminares - IMPORTANTE

**IMPORTANTE** todas las pruebas se encuentran en el directorio `/vagrant/src`.
**Si estos pasos no se ejecutan no se podrán hacer las pruebas descritas a continuación**.

Para llevar a cabo estas pruebas se deben preparar:

* El binario que hará la prueba de stress de la CPU
* La imagen de Docker que contiene el binario descrito anteriormente

Para las pruebas de rendimiento se usó un programa que no tiene ningún objetivo particular sino que más bien es una aplicación intensiva en operaciones de CPU.
El programa se encuentra en [`src/fibonacci.c`](src/fibonacci.c).
Este programa itera sobre un vector relativamente grande, 10,000,000 de posiciones, y cada posición `i` se inicializa con el valor de el `fibonacci(i%20)`.
La forma como se implementó `fibonacci` fue de forma recursiva para mayor costo computacional.

El programa `fibonacci.c` usa hilos de ejecución a través de OpenMP y se hace necesario entonces su compilación incluyendo dicha librería.

```
gcc -fopenmp fibonacci.c -o fibonacci
```

Una vez se tiene el binario compilado entonces se procede a la **creación de la imagen del contenedor de Docker** como sigue:

```
docker build -t josanabr/demo_openmp .
```

**Usted puede cambiar `josanabr` por el nombre de su usuario en Docker Hub**.

## Ejecución de pruebas

Las pruebas, como se indicó anteriormente, son de 4 tipos. 
Comenzaremos con la ejecución del binario sobre la máquina virtual. 
Para ello, ubicado en el directorio `/vagrant/src`, ejecute lo siguiente:

```
time ./fibonacci
```

Ejecutar ese comando 2 veces más para obtener una tabla similar a esta:

| Iteración  | Tiempo | T. User   |
|------------|--------|-----------|
|     1      |  24.53 |   48.53   |
|     2      |  23.58 |   46.57   |
|     3      |  23.47 |   46.31   |
|     4      |  23.53 |   46.42   |
|     5      |  23.85 |   47.29   |
|    Avg.    |  23.65 |   46.76   |

Para sacar el **promedio** se eliminan los valores extremos (más alto (48.53) y el más bajo (46.31)).

## Autores

Edier Zapata - edalzap@gmail.com

John Sanabria - john.sanabria@correounivalle.edu.co
