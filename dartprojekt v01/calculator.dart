import 'dart:io';
void main() {
  print('Välkommen till miniräknaren!');
  print('Skriv "exit" när som helst för att avsluta.');

  while (true) {
    calculate();
  }
  
}

void calculate() {

  final num1 = getDoubleInput('Ange det första talet:');

  final operation = getOperatorInput('Välj en operation (+, -, *, /):');

  final num2 = getDoubleInput('Ange det andra talet:');

  
  double result = 0;

  switch (operation) {
    case '+':
      result = num1 + num2;
      break;
    case '-':
      result = num1 - num2;
      break;
    case '*':
      result = num1 * num2;
      break;
    case '/':
      if (num2 != 0) {
        result = num1 / num2;
      } else {
        print('Fel: Division med noll är inte tillåten.');
      }
      break;
    default:
      print('Fel: Ogiltig operation.');
  }

  print('Resultatet av $num1 $operation $num2 är: $result');
}

double getDoubleInput(String prompt) {

	print(prompt);

	final doubleInput = stdin.readLineSync();
    if (doubleInput == null || doubleInput.trim().toLowerCase() == 'exit') {
	  exitCalculator();
	}

	final doubleNumber = double.tryParse(doubleInput.trim());
    if (doubleNumber == null) {
      print('Kunde inte tolka "$doubleInput" som ett tal.');
    }

	return doubleNumber!;
	
}

String getOperatorInput(String prompt) {

	print(prompt);

	final operation = stdin.readLineSync()!;

	if (operation == "" || operation.trim().toLowerCase() == 'exit') {
      exitCalculator();
    }

	return operation;
}

Never exitCalculator() {
  print('Avslutar kalkylatorn. Tack och hej!');
  exit(0);
}