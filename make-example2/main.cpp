#include <iostream>
#include "functions.h"
using namespace std;

int main()
{
	int a,b, choice;
	int result;

	cout<<"Enter two numbers : ";
	cin>>a>>b;
	cout<<"1.Add \n2.Subtract \n3.Divide \n4.Multiply\n";
	cin>>choice;

	switch(choice){
		case 1:
			result = add(a,b);
			break;
		case 2: 
			result = sub(a,b);
			break;
		case 3:
			result = division(a,b);
			break;
		case 4:
			result = mul(a,b);
			break;
	}

	cout<<"======================\n";
	cout<<"Result = "<<result<<endl;
	cout<<"======================\n";

	return 0;
}
