# HTCondor - All in one

En este repositorio se encuentran los archivos necesarios para hacer el despliegue de Docker + HTCondor (*All-in-one*). 
La razón para desarrollar este ambiente *all-in-one* es porque muchas veces se presentan situaciones donde se debe ejecutar algún tipo de contextos de ejecución que requieren una maquinaria de software compleja como lo son Docker y HTCondor.
Este repositorio simplifica el como materializar este entorno de ejecución.

Al llevar a cabo los pasos descritos aquí usted tendrá una máquina virtual, desplegada a través de [Vagrant](https://vagrantup.com), y en la cual se instalará [Docker](https://www.docker.com) y [HTCondor](https://research.cs.wisc.edu/htcondor/). 
Al final del proceso se tendrá un sistema funcional con estas dos herramientas usadas en entornos de HTC (*Hight Throughput Computing*).

## Requerimientos

Para llevar a cabo el proceso de despliegue es necesario instalar [Vagrant](https://www.vagrantup.com/downloads.html).
Una vez instalada la herramienta se hace necesario descargar el [box de Vagrant](https://www.vagrantup.com/docs/boxes.html) que se usó para hacer este despliegue.
En una terminal ejecutar:

```
vagrant box add ubuntu/xenial64
```

Estos scripts se probaron en el siguiente entorno:

* macOS 10.14.5
* VirtualBox 5.2.30
* Vagrant versión 2.2.5

---

## Pasos para el despliegue Docker + HTCondor (All-In-One)

Asumiendo que se ha instalado `vagrant` y desde una terminal, ubíquese en el directorio donde se encuentren los archivos de este repositorio.
Una vez en el directorio ejecutar:

```
vagrant up
```

Una vez terminada la ejecución del comando anterior usted tendrá un sistema Linux con Docker y HTCondor.

## Validando la instalación de Docker y HTCondor

La máquina virtual desplegada tiene instalados Docker y HTCondor.
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

### OpenMP sobre máquina virtual

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

### Tarea de OpenMP en Docker sobre máquina virtual

Para esta ejecución se asume que el usuario se encuentra en la máquina virtual en el directorio `/vagrant/src`.
Estando en este directorio y asumiendo que el contenedor fue creado somo se indicó anteriormene, se lleva a cabo la siguiene ejecucicón:

```
docker run --rm josanabr/demo_openmp
```

Para esta ocasión 

| Iteración  | Tiempo |
|------------|--------|
|     1      |   27   |
|     2      |   25   |
|     3      |   24   |
|     4      |   23   |
|     5      |   24   |
|    Avg.    |   24.3 |

Para sacar el **promedio** se eliminan los valores extremos (más alto (27) y el más bajo (23)).

### OpenMP en Docker como tarea de HTCondor  sobre máquina virtual

En este caso se define una tarea basada en Docker para HTCondor.

```
universe                = docker
docker_image            = josanabr/demo_openmp
arguments		= time_fibo.sh
transfer_executable     = true
transfer_input_files	= time_fibo.sh
should_transfer_files   = YES
when_to_transfer_output = ON_EXIT
output                  = out.$(Cluster).$(Process)
error                   = err.$(Cluster).$(Process)
log                     = log.$(Cluster)
request_cpus		= 1
queue 1
```

Observe que en este caso el `ad` `request_cpus` tiene un valor de 1. 
La razón es porque nuestro sistema HTCondor está definido con slots estáticos y donde cada slot tiene una sola CPU.
Aquí la salida de la ejecución del comando `condor_status`

```
Name               OpSys      Arch   State     Activity LoadAv Mem   ActvtyTime

slot1@htcondor.loc LINUX      X86_64 Unclaimed Idle      0.040  999  0+00:14:47
slot2@htcondor.loc LINUX      X86_64 Unclaimed Idle      0.000  999  0+00:15:05
                     Total Owner Claimed Unclaimed Matched Preempting Backfill

        X86_64/LINUX     2     0       0         2       0          0        0

               Total     2     0       0         2       0          0        0
```

Al lanzar la tarea, con el comando `condor_submit docker.condor`, estos fueron los valores observados.

| Iteración  | Tiempo |
|------------|--------|
|     1      |   46   |
|     2      |   45   |
|     3      |   46   |
|     4      |   46   |
|     5      |   46   |
|    Avg.    |   46   |

Para sacar el **promedio** se eliminan los valores extremos (más alto (46) y el más bajo (45)).

Ya que la tarea espera usar varios núcleos se hace una modificación en el archivo definición de la tarea de HTCondor.
Se cambia `request_cpus` de `1` a `2`.
Cuando se lanza la tarea, `condor_submit docker.condor`, la tarea no logra ejecutarse pues no hay ningún slot en la máquina de procesamiento que tenga dos núcleos.

### OpenMP en Docker como tarea de HTCondor  sobre máquina virtual - Configuración de HTCondor con slots dinámicos

Una solución a la situación anterior es implementar slots dinámicos en el despliegue existente de HTCondor.
En el caso particular de este escenario de pruebas es necesario, editar el archivo `/etc/condor/condor_config.local` y adicionar las siguientes líneas:

```
# Slots Configuration / Configuracion de Slots
# Owner Slot / Slot para el propietario
# Slot resources / Recursos del Slot
SLOT_TYPE_1 = cpu=100%, ram=100%
## Create Slot / Crear Slot
NUM_SLOTS_TYPE_1 = 1
## Never run jobs in this slot / Nunca ejecutar tareas en este slot
SLOT_TYPE_1_START= True
```

Guardar los cambios y reiniciar el servicio de `HTCondor`

```
sudo service condor restart
```

Al ejecutar `condor_status` la salida debería ser algo similar a esto:

```
Name               OpSys      Arch   State     Activity LoadAv Mem   ActvtyTime

htcondor.local     LINUX      X86_64 Unclaimed Benchmar  0.030 1999  0+00:00:04
                     Total Owner Claimed Unclaimed Matched Preempting Backfill

        X86_64/LINUX     1     0       0         1       0          0        0

               Total     1     0       0         1       0          0        0
```

En este caso ya no se tienen varios slots sino solo uno.

Se vuelve a lanzar la tarea descrita en el punto anterior, `condor_submit docker.condor`, y en este caso la tarea si termina su ejecución. 
Se revisa el contenido del archivo `out.9.0` y se obtiene un valor de 24 segundos.
Se lanza la ejecución 4 veces más y se obtienen los siguientes resultados:

| Iteración  | Tiempo |
|------------|--------|
|     1      |   24   |
|     2      |   24   |
|     3      |   23   |
|     4      |   24   |
|     5      |   24   |
|    Avg.    |   24   |

Para sacar el **promedio** se eliminan los valores extremos (más alto (24) y el más bajo (23)).

# Conclusiones

Al observar los resultados se puede afirmar lo siguiente:

* El *overhead* impuesto por Docker y HTCondor en la ejecución efectiva de la aplicación cuando se compara con la versión nativa prácticamente no se afecta.
* Cuando se usa HTCondor con __slots estáticos__ el rendimiento de las tareas basadas en hilos se pueden afectar dramáticamente pues en este escenario cada slot tiene un solo núcleo lo que evita el explotar el paralelismo de los procesadores *multicore*.
* La configuración de __slots dinámicos__ permite crear espacios de ejecución que responden a las necesidades particulares de la definición de la tarea del usuario.
* Se deben hacer pruebas con otro tipo de aplicaciones más intensivas en memoria RAM y en operacions de E/S.


## Autores

Edier Zapata - edalzap@gmail.com

John Sanabria - john.sanabria@correounivalle.edu.co
