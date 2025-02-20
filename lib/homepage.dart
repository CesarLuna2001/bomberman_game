import 'dart:async';
import 'package:flutter/material.dart';
import 'button.dart';  // Importación de la clase para los botones
import 'pixel.dart';   // Importación de la clase para representar cada píxel en la cuadrícula

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState(); 
}

class _HomePageState extends State<HomePage> {
  int numberOfSquares = 130;  // Total de casillas en la cuadrícula 
  int playerPosition = 0;     // Posición inicial del jugador en la cuadrícula (al inicio se encuentra en el índice 0)
  int bombPosition = -1;      // Posición de la bomba, inicialmente no existe ninguna bomba colocada
  List<int> barriers = [  // Lista de índices que representan los obstáculos en la cuadrícula
    11, 13, 15, 17, 18, 31, 33, 35, 37, 38, 51, 53, 55, 57, 58, 
    71, 73, 75, 77, 78, 91, 93, 95, 97, 98, 111, 113, 115, 117, 118
  ];

  List<int> boxes = [  // Lista de índices que representan las cajas en la cuadrícula que pueden ser destruidas
    12, 14, 16, 28, 21, 41, 61, 81, 101, 112, 114, 116, 119, 127, 123, 
    103, 83, 63, 65, 67, 47, 39, 19, 1, 30, 50, 70, 121, 100, 96, 79, 
    99, 107, 7, 3
  ];

  // Función para mover al jugador hacia arriba 
  void moveUp() {
    setState(() {
      if (playerPosition - 10 >= 0 &&  // Verifica que no se salga de la cuadrícula por el borde superior
          !barriers.contains(playerPosition - 10) &&  // Verifica que no haya una barrera en la nueva posición
          !boxes.contains(playerPosition - 10)) {  // Verifica que no haya una caja en la nueva posición
        playerPosition -= 10;  // Reduce la posición del jugador para moverlo hacia arriba
      }
    });
  }

  // Función para mover al jugador hacia la izquierda 
  void moveLeft() {
    setState(() {
      if (!(playerPosition % 10 == 0) &&  // Verifica que el jugador no esté en el borde izquierdo
          !barriers.contains(playerPosition - 1) &&  // Verifica que no haya una barrera a la izquierda
          !boxes.contains(playerPosition - 1)) {  // Verifica que no haya una caja a la izquierda
        playerPosition -= 1;  // Reduce la posición para mover al jugador a la izquierda
      }
    });
  }

  // Función para mover al jugador hacia la derecha 
  void moveRight() {
    setState(() {
      if (!(playerPosition % 10 == 9) &&  // Verifica que el jugador no esté en el borde derecho
          !barriers.contains(playerPosition + 1) &&  // Verifica que no haya una barrera a la derecha
          !boxes.contains(playerPosition + 1)) {  // Verifica que no haya una caja a la derecha
        playerPosition += 1;  // Aumenta la posición para mover al jugador a la derecha
      }
    });
  }

  // Función para mover al jugador hacia abajo 
  void moveDown() {
    setState(() {
      if (playerPosition + 10 < numberOfSquares &&  // Verifica que el jugador no se salga de la cuadrícula por el borde inferior
          !barriers.contains(playerPosition + 10) &&  // Verifica que no haya una barrera abajo
          !boxes.contains(playerPosition + 10)) {  // Verifica que no haya una caja abajo
        playerPosition += 10;  // Aumenta la posición para mover al jugador hacia abajo
      }
    });
  }

  List<int> fire = [-1];  // Lista para almacenar las posiciones afectadas por el fuego de la bomba

  // Función para colocar una bomba en la posición actual del jugador
  void placeBomb() {
    setState(() {
      bombPosition = playerPosition;  // Establece la posición de la bomba en la posición del jugador
      fire.clear();  // Limpia las posiciones de fuego de una posible bomba anterior
      Timer(Duration(seconds: 1), () {  // Temporizador de 1 segundo para simular el tiempo hasta la explosión
        setState(() {
          // Se agregan las posiciones alrededor de la bomba que serán afectadas por la explosión
          fire.add(bombPosition);  // Posición de la bomba
          fire.add(bombPosition - 1);  // Casilla a la izquierda de la bomba
          fire.add(bombPosition + 1);  // Casilla a la derecha de la bomba
          fire.add(bombPosition - 10);  // Casilla arriba de la bomba
          fire.add(bombPosition + 10);  // Casilla abajo de la bomba
        });
        clearFire();  // Llamada para limpiar el fuego después de un segundo
      });
    });
  }

  // Función para limpiar las áreas de fuego después de la explosión
  void clearFire() {
    setState(() {
      Timer(Duration(seconds: 1), () {
        setState(() {
          // Recorre las posiciones afectadas por la explosión y elimina las cajas en esas posiciones
          for (int i = 0; i < fire.length; i++) {
            if (boxes.contains(fire[i])) {
              boxes.remove(fire[i]);  // Elimina la caja de la lista de cajas
            }
          }
          fire.clear();  // Limpia las posiciones de fuego
          bombPosition = -1;  // Resetea la posición de la bomba después de la explosión
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],  // Establece el color de fondo para la pantalla principal
      body: Column(
        children: [
          Expanded(
            flex: 2,  // Toma el 2/3 de la pantalla para mostrar la cuadrícula
            child: Container(
                child: GridView.builder(  // Constructor para construir la cuadrícula de píxeles
                    physics: NeverScrollableScrollPhysics(),  // Desactiva el desplazamiento en la cuadrícula
                    itemCount: numberOfSquares,  // Número total de píxeles a mostrar en la cuadrícula
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 10),  // Define que habrá 10 columnas por fila
                    itemBuilder: (BuildContext context, int index) {
                      // Cada casilla de la cuadrícula será un "píxel" personalizado
                      if (fire.contains(index)) {  // Si el índice está en la lista de fuego, muestra un píxel rojo
                        return MyPixel(
                          innerColor: Colors.red,
                          outerColor: Colors.red[800],
                        );
                      } else if (bombPosition == index) {  // Si el índice es la posición de la bomba, muestra una bomba
                        return MyPixel(
                          innerColor: Colors.green,
                          outerColor: Colors.green[800],
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset('lib/images/bombita.png')) 
                        );
                      } else if (playerPosition == index) {  // Si el índice es la posición del jugador, muestra al jugador
                        return MyPixel(
                          innerColor: Colors.green,
                          outerColor: Colors.green[800],
                          child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset('lib/images/Bomberman.png'))
                        );
                      } else if (barriers.contains(index)) {  // Si es una barrera, se muestra un píxel negro
                        return MyPixel(
                          innerColor: Colors.black,
                          outerColor: Colors.black,
                        );
                      } else if (boxes.contains(index)) {  // Si es una caja, se muestra un píxel marrón
                        return MyPixel(
                          innerColor: Colors.brown,
                          outerColor: Colors.brown[800],
                        );
                      } else {  // Para el resto de los casos, muestra un píxel verde
                        return MyPixel(
                          innerColor: Colors.green,
                          outerColor: Colors.green[800],
                        );
                      }
                    })),  // Fin de la cuadrícula
          ),
          Expanded(
              child: Container(
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(),  // Botón vacío para el espaciado
                  MyButton(
                      function: moveUp,  // Botón para mover hacia arriba
                      color: Colors.grey,
                      child: Icon(
                        Icons.arrow_drop_up,
                        size: 70,
                      )),
                  MyButton(),  // Botón vacío para el espaciado
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(
                      function: moveLeft,  // Botón para mover hacia la izquierda
                      color: Colors.grey,
                      child: Icon(
                        Icons.arrow_left,
                        size: 70,
                      )),
                  MyButton(
                      function: placeBomb,  // Botón para colocar una bomba
                      color: Colors.grey[900],
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset('lib/images/bombita.png'))),
                  MyButton(
                      function: moveRight,  // Botón para mover hacia la derecha
                      color: Colors.grey,
                      child: Icon(
                        Icons.arrow_right,
                        size: 70,
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(),  // Botón vacío para el espaciado
                  MyButton(
                      function: moveDown,  // Botón para mover hacia abajo
                      color: Colors.grey,
                      child: Icon(
                        Icons.arrow_drop_down,
                        size: 70,
                      )),
                  MyButton(),  // Botón vacío para el espaciado
                ],
              ),
            ],
          ))),
        ],
      ),
    );
  }
}

