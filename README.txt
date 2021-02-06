LEÉAME - PRÁCTICA 1 COMPILADORES - CALCULADORA
AUTOR: Enrique Molina Giménez
Fecha: 05/01/2021

INSTRUCCIONES PARA LA COMPILACIÓN Y EJECUCIÓN (BASH)
	./make 		--> Compila la calculadora 
	./make clean 	--> Elimina todos los ficheros resultado de la compilación - deja código fuente e "input.txt"
	./make run	--> Ejecuta la calculadora tomando la entrada del fichero "input.txt"
	./prac1.o	--> Ejecuta la calculadora desde la entrada "stdin"
	
DECISIONES DE DISEÑO ESCOGIDAS
	A continuación se listan diversas decisiones de diseño escogidas para el éxito de implementación de esta calculadora:
		- Al ser bison un analizador sintáctico BOTTOM-UP, que tiene atributos sintetizados, las gramáticas han sido construidas "por la izquierda", 
		esto permite que el árbol de análisis sintáctico maneje adecuadamente los atributos y sean accesibles desde donde sean requeridos. 
		- Con fin de evitar conflictos de bison, y dado que no se puede hacer uso de los helpers de bison %right, &left y %nonassoc, es necesario
		hacer una definición de la gramática no ambigua que defina qué acciones tendrán mayor (o menor) precedencia. 
		- El registro "structure" contiene los campos necesarios para bison necesita para implementar esta calculadora. 

OPCIONES AÑADIDAS
	Además de todos los requisitos exigidos en el enunciado de esta práctica, se añaden funciones trigonométricas a esta calculadora, que tendrán el 
	siguiente formato:
		sin(arithmetic_exp)	--> Calcula el seno del ángulo que encierra entre paréntesis
		cos(arithmetic_exp)	--> Calcula el coseno 	"		"		"
		tan(arithmetic_exp)	--> Calcula la tangente	"		"		"
		
EJECUCIÓN DEL FICHERO DE PRUEBA "input.txt"
	- Se añaden instrucciones trigonométricas de prueba
	- La penúltima instrucción del ejemplo de archivo de entrada se comenta (puesto que el programa sino "peta", dado que intenta sumar un booleano 
	a un número)

