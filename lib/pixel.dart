import 'package:flutter/material.dart';

class MyPixel extends StatelessWidget {
  final innerColor;  // Color interno del píxel (el color de la parte interna del cuadro)
  final outerColor;  // Color externo del píxel (el color de la parte exterior del cuadro)
  final child;       // Un widget hijo 

  // Constructor que recibe los valores para los colores y el widget hijo
  MyPixel({this.innerColor, this.outerColor, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),  // Se agrega un espaciado alrededor del píxel
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),  // Redondea las esquinas del píxel exterior
        child: Container(
          padding: EdgeInsets.all(5),  // Padding adicional dentro del píxel exterior
          color: outerColor,  // Color de fondo del borde exterior del píxel
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),  // Redondea las esquinas del píxel interior
            child: Container(
              color: innerColor,  // Color de fondo del área interna del píxel
              child: Center(
                child: child,  // Widget hijo que se coloca en el centro del píxel (como imágenes o íconos)
              ),
            ),
          ),
        ),
      ),
    );
  }
}

