import 'processes.dart';
import 'dart:math';
import 'package:yaml/yaml.dart';


class Simulator {
  final bool verbose; 
  final List<Process> processes = <Process>[]; 
  String _report = ""; 

  /// Queueing system simulator.
Simulator(YamlMap yamlData, {this.verbose = false}) {
    for (final name in yamlData.keys) {
      final fields = yamlData[name];
      // replace print statements with process creation
      switch (fields['type']) {
        case 'singleton':
          processes.add(SingletonProcess(name, fields));
          break;
        case 'periodic':
          processes.add(PeriodicProcess(name, fields));
          break;
        case 'stochastic':
          processes.add(StochasticProcess(name, fields));
          break;
        default:
          print("Invalid ProcessType for process '$name'");
      }
    };
  }

  
  void run() {
    final events =
        processes.expand((process) => process.generateEvents()).toList();
// Sort the events primarily by arrival time, and secondarily by process name
    events.sort((a, b) {
      int result = a.arrivalTime.compareTo(b.arrivalTime);
      if (result == 0) {
        result = a.processName.compareTo(b.processName);
      }
      return result;
    });

    int currentTime = 0; 
    double totalWaitTime = 0; 

    verbose ? print("\n# Simulation trace\n") : null;

    
    for (var event in events) {
      currentTime = max(currentTime,
          event.arrivalTime); 
      event
        ..start = currentTime
        ..waitTime = event.start - event.arrivalTime;

      totalWaitTime += event.waitTime; 
      currentTime += event.duration; 
// if verbose is enabled then print detailed information about events execution.
      if (verbose) {
        print(
            't=${event.start}: ${event.processName}, duration ${event.duration} '
            'started (arrived @ ${event.arrivalTime}, waited ${event.waitTime})');
      }
    }

    storeReport(events, totalWaitTime); 
  }

  
  void printReport() {
  // prints the generated report.
    print(_report);
  }

  
  void storeReport(List<Event> events, double totalWaitTime) {
    final processStats =
        <String, List<Event>>{}; 
    for (var event in events) {
      processStats.putIfAbsent(event.processName, () => []).add(event);
    }
    final buffer = StringBuffer()
      ..writeln('-' * 62)
      ..writeln('# Per-process statistics\n');

    processStats.forEach((processName, processEvents) {
      final totalWait =
          processEvents.fold(0, (sum, e) => sum + e.waitTime); 
      final avgWait = totalWait / processEvents.length; 
      // adding to buffer
      buffer
        ..writeln('$processName:')
        ..writeln('  Events generated:  ${processEvents.length}')
        ..writeln('  Total wait time:   $totalWait')
        ..writeln('  Average wait time: $avgWait\n');
    });
    // summary of overall simulation
    buffer
      ..writeln('-' * 62)
      ..writeln('# Summary statistics\n')
      ..writeln('Total num events:  ${events.length}')
      ..writeln('Total wait time:   $totalWaitTime')
      ..writeln('Average wait time: ${totalWaitTime / events.length}');

    _report = buffer.toString();
  }
}
