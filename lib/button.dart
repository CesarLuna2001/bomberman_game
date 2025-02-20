import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final color;     // Color de fondo del botón
  final child;     // Widget hijo que se muestra dentro del botón 
  final function;  // Función que se ejecuta cuando el botón es presionado

  // Constructor que recibe el color, el widget hijo y la función para ejecutar al hacer clic
  MyButton({super.key, this.color, this.child, this.function});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),  // Espaciado alrededor del botón
      child: GestureDetector(
        onTap: function,  // Detecta el toque y ejecuta la función proporcionada
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),  // Bordes redondeados en el botón
          child: Container(
            color: color,  // Asigna el color de fondo del botón
            height: 70,     // Altura del botón
            width: 70,      // Ancho del botón
            child: Center(
              child: child,  // El widget hijo se coloca en el centro del botón
            ),
          ),
        ),
      ),
    );
  }
}

