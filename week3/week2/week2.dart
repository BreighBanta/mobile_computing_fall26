void main () {
 // print('program started'); having trouble running at first, had SDK file issue
  
  var student = [
    Student (
      name:'Daniel',
      id: 100, 
      grades: [1, 2, 2]),

    Student (
      name:'Breigh',
      id: 200, 
      grades: [3, 4, 3]),
  ];

  for (var s in student) {
  double GPA = average(s.grades);

  print('${s.name}: $GPA');
  }
}
//student class
class Student {
  String name;
  int id;
  List<int> grades;

//constructor
  Student({
   required this.id,
   required this.name,
   required this.grades,
  });
}

//grade calaculator
double average(List<int> values) {

  if (values.isEmpty) return 0.0;

  double total = 0;
  for (int number in values) {
    total = total + number;
  }
  return total / values.length;
}

// had to brush up on some basic concepts,
// used some google websites, used gemini for
//errors encountered like sdk issue and some 
//formatting/syntax errors

