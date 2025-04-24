import 'package:battleships/model/gamedetails_model.dart';
import 'package:flutter/material.dart';

class GameGrid extends StatefulWidget {
  final GameDetailsModel? gameDetails;
  final bool isEditable;
  final bool isNewGame;
  final Function(String, bool, bool)? onTap;
  final Function(bool, GameDetailsModel?)? onClick;

  const GameGrid({
    required this.isEditable,
    required this.isNewGame,
    this.gameDetails,
    this.onTap,
    this.onClick,
    super.key,
  });

  @override
  State<GameGrid> createState() => _GameGridState();
}

class _GameGridState extends State<GameGrid> {
  List<String> rowNames = ['A', 'B', 'C', 'D', 'E'];
  List<Color> blockColor = List.filled(36, Colors.lightBlue[100]!); // Default sky blue color
  List<bool> isBlockClicked = List.filled(36, false);
  int counter = 0;
  String shot = "";
  bool isCleared = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final aspectRatio = constraints.maxWidth / constraints.maxHeight;
                final shipsList = widget.gameDetails?.ships;
                final sunkList = widget.gameDetails?.sunk;
                final wrecksList = widget.gameDetails?.wrecks;
                final shotList = widget.gameDetails?.shots;

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    childAspectRatio: aspectRatio,
                  ),
                  itemCount: 36,
                  itemBuilder: (context, index) {
                    int row = index ~/ 6;
                    int col = index % 6;
                    Color selectedColor = Colors.lightBlue[100]!; // Sky blue color as default
                    bool isClicked = false;

                    if (widget.isNewGame) {
                      selectedColor = blockColor[index];
                      isClicked = isBlockClicked[index];
                    }

                    // Display headers and grid cells
                    if (row == 0 && col == 0) {
                      return Container(); // Blank corner cell
                    } else if (row == 0) {
                      // Column headers (1, 2, 3, 4, 5)
                      return Center(
                        child: Text(
                          col.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,  // Set column header color to black
                          ),
                        ),
                      );
                    } else if (col == 0) {
                      // Row headers (A, B, C, D, E)
                      return Center(
                        child: Text(
                          rowNames[row - 1],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,  // Set row header color to black
                          ),
                        ),
                      );
                    } else {
                      final rowNamesValue = '${rowNames[row - 1]}$col';
                      bool isShipAvailable = false;
                      bool isShipSunk = false;
                      bool isShipWrek = false;
                      bool isShotMissed = false;

                      if (!widget.isNewGame) {
                        if (isCleared) {
                          shot = "";
                          isCleared = false;
                        }
                        if (shot.isNotEmpty && rowNamesValue == shot) {
                          selectedColor = const Color.fromARGB(255, 230, 149, 7);
                          isClicked = true;
                        }
                      }

                      if (widget.gameDetails != null) {
                        // Determine cell state
                        String ship = shipsList!.firstWhere(
                          (element) => element == rowNamesValue,
                          orElse: () => "",
                        );

                        if (ship.isNotEmpty) {
                          isShipAvailable = true;
                        }
                        String sunk = sunkList!.firstWhere(
                          (element) => element == rowNamesValue,
                          orElse: () => "",
                        );

                        if (sunk.isNotEmpty) {
                          isShipSunk = true;
                        }
                        String wreck = wrecksList!.firstWhere(
                          (element) => element == rowNamesValue,
                          orElse: () => "",
                        );

                        if (wreck.isNotEmpty) {
                          isShipWrek = true;
                        }
                        String shots = shotList!.firstWhere(
                          (element) => element == rowNamesValue,
                          orElse: () => "",
                        );

                        if (shots.isNotEmpty && !isShipSunk) {
                          isShotMissed = true;
                        }
                      }

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300, width: 1),
                        ),
                        child: Material(
                          color: selectedColor,
                          child: InkWell(
                            onTap: widget.isEditable
                                ? () {
                                    if (widget.isNewGame) {
                                      if (!isClicked) {
                                        if (counter < 5) {
                                          setState(() {
                                            counter++;
                                            blockColor[index] = Colors.deepPurple;
                                            isClicked = true;
                                            isBlockClicked[index] = true;
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('5 ships are selected')),
                                          );
                                        }
                                      } else {
                                        setState(() {
                                          counter--;
                                          blockColor[index] = Colors.lightBlue[100]!;
                                          isClicked = false;
                                          isBlockClicked[index] = false;
                                        });
                                      }
                                      final value = '${rowNames[row - 1]}$col';
                                      widget.onTap?.call(value, isClicked, widget.isNewGame);
                                    } else {
                                      final value = '${rowNames[row - 1]}$col';
                                      setState(() {
                                        if (value == shot) {
                                          isClicked = false;
                                          selectedColor = Colors.lightBlue[100]!;
                                          shot = "";
                                        } else {
                                          selectedColor = const Color.fromARGB(255, 230, 149, 7);
                                          isClicked = true;
                                          shot = value;
                                        }
                                      });
                                      widget.onTap?.call(value, isClicked, widget.isNewGame);
                                    }
                                  }
                                : null,
                            splashColor: Colors.blue.shade100,
                            hoverColor: Colors.blue.shade50,
                            child: Container(
                              alignment: Alignment.center,
                              child: Center(
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (isShipAvailable)
                                        const Icon(Icons.directions_boat, color: Colors.blue, size: 18),
                                      if (isShipSunk)
                                        Text(String.fromCharCode(128165), style: const TextStyle(fontSize: 18)),
                                      if (isShipWrek)
                                        const Icon(Icons.bubble_chart, color: Colors.red),
                                      if (isShotMissed)
                                        Text(String.fromCharCode(128163), style: const TextStyle(fontSize: 18)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              elevation: 0,
            ),
            onPressed: widget.isEditable
                ? () {
                    isCleared = true;
                    widget.onClick?.call(widget.isNewGame, widget.gameDetails);
                  }
                : null,
            child: const Text(
              'Submit',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
