#include<iostream>
#include<stdlib.h>
using namespace std;
float a = 10;
int func()
{
     int a = 5;
     int c = a + 3 * 5 / 10;
}
class class1
{
    private: int b;
    public:
        int class_function(int d)
            {
                cout<<"In function "<<d<<endl;
            }
};
int main()
{
    class1 obj1;
    obj1.class_function(10);
		int a1[5]={1,2,3,4,5};
		int b1[]={1,2,3,4,5};
		int a = 9;
		int b = 10;

		int add = 3 + 5 + 5 + 8;
		int sub = 3 - 5;
		int op1 = 5;
		int op2 = 10;
		bool gt = op1 > op2;
		bool lteq = op1 <= op2;
		bool log_and = op1 && op2;
		bool log_or = op1 || op2;
		if(a <= b)
		{
        int day = 4;
        switch (day)
				{
			        case 1: {
			                    int case1 = 4;
			                    break;
			                }
			        case 2:
			        case 3: break;
			        case 4: cout << "CASE 4\n";
        }

		}
}
