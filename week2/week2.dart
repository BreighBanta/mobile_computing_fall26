//Breigh Banta
//Mobile Computing
//Week 2
void main () {
 // print('program started'); having trouble running at first, had SDK file issue
  var student = [
    Student (
      name: 'Daniel',
      id: 100,
      grades: [1, 2, 2],
    ),
     Student (
      name: 'Breigh',
      id: 200,
      grades: [3, 4, 3],
    )
  ];
  
  // GPA calculator function
  double average(List<int> grades) {
    if (grades.isEmpty) return 0.0;
    
    int total = 0;
    for (var grade in grades) {
      total = total + grade;
    }

    return total / grades.length;
  }

  //loop that prints each students name and info
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
  Student ({
    required this.id,
    required this.name,
    required this.grades
  });
}

// had to brush up on previous programmin knowledge using some sources from google
//used gemini to help detect some smaller syntax and logic issues
// tried to commit and push but ran into issues
// lost significant amount of code and had to rebuild before pushing out again