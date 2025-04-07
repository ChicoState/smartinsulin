#include <iostream>
#include <vector>
using namespace std;

// BASAL INSULIN (LONG ACTING INSULIN)
double TotalDailyDose(int age, int weight, int value){
  double total;
  // NON OBESE
  while(weight == 0){
    // PRE PUBERTAL (1-14)
    if(age <= 3 && value < 10){
      total = 0.3;
      break;
    }
    if(age <= 3 && value >= 10 || (age >= 3 && age <= 6) && value < 10){
      total = 0.4;
      break;
    }
    if(((age >= 3 && age <= 6) && value >= 10) || ((age < 15 && age >= 6) && value < 10)){
      total = 0.5;
      break;
    }
    if((age < 15 && age >= 6) && value >= 10){
      total = 0.6;
      break;
    }
    // PURBERTAL (15-INF)
    if(age < 15 && value < 10){
      total = 0.75;
      break;
    }
    if((age < 15 && value >= 10) || (age >= 15 && value < 10)){
      total = 0.8;
      break;
    }
  }
  // OBESE
  while(weight == 1){
    // PRE PUBERTAL (1-14)
    if(age < 7 && value < 10){
      total = 0.5;
      break;
    }
    if((age < 7 && value >= 10) || (age >= 7 && value < 10)){
      total = 0.6;
      break;
    }
    if(age >= 7 && value >= 10){
      total = 0.75;
      break;
    }
    // PURBERTAL (15-INF)
    if(age < 15 && value < 10){
      total = 0.8;
      break;
    }
    if((age < 15 && value >= 10) || (age >= 15 && value < 10)){
      total = 0.9;
      break;
    }
    if(age >= 15 && value >= 10){
      total = 1;
      break;
    }
  }
  return total;
}

double GeneralBolusInsulin(double bodyWeight, double dailyMeals){
  double TotalDD, dailyBolusDose, MealtimeBolusDose;
  TotalDD = bodyWeight * 0.55;
  dailyBolusDose = TotalDD/2;
  return MealtimeBolusDose = dailyBolusDose/dailyMeals;
}

int main(){
  int carbs, meals, bodyWeight;
  int weight, Age, value;
  int doseB, doseL, doseD;
  int num, Type;
  double TotalDD, TotalMTBD, InsulinRatio;
    cout << "Enter Type (1 or 2): " << endl;
    cin >> Type;
    if(Type == 1){
      cout << "Breakfast dose: (units)" << endl;
      cin >> doseB;
      cout << "Lunch dose: (units)" << endl;
      cin >> doseL;
      cout << "Dinner dose: (units)" << endl;
      cin >> doseD;

      TotalDD = doseB + doseL + doseD;
      cout << "Total Daily Dose: " << TotalDD << " units" << endl;
    }
    else if(Type == 2){
      cout << "Age: " << endl;
      cin >> Age;
      cout << "Obese(1) or Non-Obese(0): " << endl;
      cin >> weight;
      cout << "HbA1c: (%)" << endl;
      cin >> value;

      // Algorithm for calculating dose
      // call function to determine units
      TotalDD = TotalDailyDose(Age, weight, value);
      cout << "Total Daily Dose: " << TotalDD  << " (units/kg per Day)" << endl;
    }
    // General Bolus Dose Calculations
    cout << "Enter Body Weight: (kg)" << endl;
    cin >> bodyWeight;
    cout << "Amount of daily meals: " << endl;
    cin >> meals;
    TotalMTBD = GeneralBolusInsulin(bodyWeight, meals);
    cout << "Mealtime bolus dose: " << TotalMTBD << " (units/meals)" << endl;

    // Carbohydrates Based Calculations
    cout << "Bolus dose for this meal " << endl;
    InsulinRatio = 500/TotalDD;
    cout << "Carbohydrates in this meal: (grams)" << endl;
    cin >> carbs;
    cout << "Bolus dose for this meal " << carbs/InsulinRatio  << " (units)" << endl;
}
