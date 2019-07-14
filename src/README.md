# OpenMP, OpenMP en Docker, OpenMP en Docker + HTCondor

Hoy la virtualización ofrecida por los ambientes basados en contenedores atraen la atención de la industria y la academia.
Los contenedores se entienden como entidades de software autocontenidas que garantizan la ejecución de aplicaciones en múltiples plataformas.
Los contenedores corren en ambientes heterogéneos, desde un portátil hasta aquellos ambientes que se encuentran en grandes centros de cómputo.
Características como  ejecución en múltiples plataformas, su movilidad, portabilidad y reproducibilidad; los convierten en una herramienta tecnológica atractiva para los invetigadores que desean brindar a terceros forma de validar y reproducir sus procesos de investigación.

Si bien es cierto que los contenedores brindan muchas ventajas no es menos cierto la incertindumbre que produce el determinar el *overhead* que esta tecnología impone a la ejecución de aplicaciones.

Los hilos de ejecución son una abstracción del sistema operativo que le permite a los procesos aprovechar los núcleos de los procesadores.
De este modo, una aplicación que se desarrolla multiplexando su ejecución sobre múltiples hilos aprovecha los núcleos del procesador y reduce su tiempo de ejecución.

OpenMP es una especificación que define unas directivas de precompilación que insertan instrucciones que posibilitan la inserción de hilos en los programas que la adoptan.
Internamente OpenMP hace uso de la librería PThreads pero su azúcar sintáctico facilita la inserción de código que paraleliza la ejecución de la aplicación a través de los hilos de ejecución.

Las preguntas que derivan el presente trabajo son:

* ¿Docker impone algún tipo de penalidad que cause una mayor demora en la ejecución de aplicaciones desarrolladas con hilos?
* ¿HTCondor impone algún tipo de penalidad en tiempo de tareas basadas en contenedores que ejecutan aplicaciones basadas en hilos?

# Entorno de pruebas

El entorno que se utilizó fue en una máquina virtual con el fin que el lector pueda repetir las pruebas que se harán aquí.

Las herramientas a usar son:

* [Virtualbox](https://virtualbox.org) versión 5.2.30
* [Vagrant](https://vagrantup.com) versión 2.2.5

Para llevar a cabo los pasos descritos en este documento por favor instalar dichas herramientas.

# Desplegar máquina virtual

Una vez la máquina virtual ha sido desplegada 
Para llevar a cabo el despliegue de la máquina virtual debe hacer lo siguiente.

# Descargar el software

Una vez se tiene el software listo se deben descargar los archivos del presente repositorio.

A continuación se describirán cada uno de los archivos.

#



# Slots dinámicos

```
# Slots Configuration / Configuracion de Slots
# Owner Slot / Slot para el propietario
# Slot resources / Recursos del Slot
SLOT_TYPE_1 = cpu=100%, ram=100%
# Create Slot / Crear Slot
NUM_SLOTS_TYPE_1 = 1
# Never run jobs in this slot / Nunca ejecutar tareas en este slot
SLOT_TYPE_1_START= True
```

