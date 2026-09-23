En el desarrollo del presente Microproyecto, se empleó Inteligencia Artificial (Gemini) como una herramienta interactiva de soporte de ciclo completo (end-to-end co-pilot), integrándola de manera transversal en el diseño, la implementación, el diagnóstico de hardware y la documentación del sistema.

Su uso se articuló a lo largo de las siguientes dimensiones de trabajo:

Arquitectura y Co-diseño Lógico: Asistencia en la concepción y estructuración modular del proyecto en VHDL, incluyendo la formulación de máquinas de estados finitos (FSM) para el procesamiento de temporizaciones dinámicas (discriminación de pulsaciones cortas y largas en botones multifunción) y la abstracción de componentes reutilizables (pkg_utilidades, divisor_frecuencia, decodificador_timer).

Generación y Estructuración de Código VHDL: Desarrollo guiado de los archivos fuente bajo múltiples esquemas de descripción (Comportamental, Flujo de Datos y Estructural), garantizando el cumplimiento de la sintaxis del lenguaje, la correcta instanciación de entidades, el manejo de tipos de datos restringidos (integer range) y la asignación concurrente y secuencial de señales.

Diagnóstico de Hardware y Troubleshooting Físico: Acompañamiento metodológico para la resolución de anomalías en la tarjeta FPGA (Terasic DE0). Esto abarcó la creación de rutinas de prueba para el aislamiento de fallas, la detección de problemas de mapeo de pines en el Pin Planner (.qsf), la verificación de polaridad en lógica invertida (Active-Low) y la diferenciación entre errores de compilación binaria (.sof) y degradación física en los segmentos de los displays.

Refactorización y Optimización de Lógica Combinacional: Análisis y corrección paso a paso de inconsistencias en tablas de veracidad y mapas de codificación binaria (como la corrección de patrones de bits para el dígito 5 en displays de 7 segmentos de ánodo común) y la prevención de conflictos de síntesis (Multiple Constant Drivers).

Entorno de Desarrollo y Gestión de Versiones: Asistencia en la configuración del entorno Quartus Prime, gestión de jerarquías de compilación (Top-Level Entity) y estructuración de archivos de control de versiones (.gitignore) para la exclusión de temporales de síntesis.

Comprensión Conceptual y Documentación: Apoyo en el desglose analítico de los módulos desarrollados para la asimilación teórica de cada bloque funcional, así como en la estructuración técnica de los reportes y entregables del proyecto.