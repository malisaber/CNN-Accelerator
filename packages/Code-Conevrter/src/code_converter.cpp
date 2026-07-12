#include <iostream>
#include <fstream>
#include <string>
#include <regex>
#include "CLI11.hpp"

using namespace std;


string int2bin(unsigned int inp, unsigned int size)
{
    string str = "";
    unsigned int i = 0;
    while (inp != 0)
    {
        if ((inp % 2) == 0)
            str = "0" + str;
        else
            str = "1" + str;
        inp /= 2;
        i++;
    }
    for (unsigned int j = i; j < size; j++)
    {
        str = "0" + str;
    }
    return str;
}

unsigned int hex2uint(string inp)
{
    unsigned int tmp = 0;
    for (int i = 0; i < inp.size(); i++)
    {
        tmp = 16 * tmp;
        switch (inp[i])
        {
        case '0':
            break;
        case '1':
            tmp += 1;
            break;
        case '2':
            tmp += 2;
            break;
        case '3':
            tmp += 3;
            break;
        case '4':
            tmp += 4;
            break;
        case '5':
            tmp += 5;
            break;
        case '6':
            tmp += 6;
            break;
        case '7':
            tmp += 7;
            break;
        case '8':
            tmp += 8;
            break;
        case '9':
            tmp += 9;
            break;
        case 'a':
        case 'A':
            tmp += 10;
            break;
        case 'b':
        case 'B':
            tmp += 11;
            break;
        case 'c':
        case 'C':
            tmp += 12;
            break;
        case 'd':
        case'D':
            tmp += 13;
            break;
        case 'e':
        case 'E':
            tmp += 14;
            break;
        case 'f':
        case 'F':
            tmp += 15;
            break;
        default:
            cout << "ridi" << endl;
            break;
        }
    }
    return tmp;
}

string hex_legth_fix(string inp, int size)
{
    for (int i = inp.size()+1; i <= size; i++)
    {
        inp = "0" + inp;
    }
    return inp;
}

string hex_2_bin(string inp)
{
    string tmp = "";
    for (int i = 0; i < inp.size(); i++)
    {
        switch (inp[i])
        {
        case('0'):
            tmp = tmp + "0000";
            break;
        case('1'):
            tmp = tmp + "0001";
            break;
        case('2'):
            tmp = tmp + "0010";
            break;
        case('3'):
            tmp = tmp + "0011";
            break;
        case('4'):
            tmp = tmp + "0100";
            break;
        case('5'):
            tmp = tmp + "0101";
            break;
        case('6'):
            tmp = tmp + "0110";
            break;
        case('7'):
            tmp = tmp + "0111";
            break;
        case('8'):
            tmp = tmp + "1000";
            break;
        case('9'):
            tmp = tmp + "1001";
            break;
        case('a'):
        case('A'):
            tmp = tmp + "1010";
            break;
        case('b'):
        case('B'):
            tmp = tmp + "1011";
            break;
        case('c'):
        case('C'):
            tmp = tmp + "1100";
            break;
        case('d'):
        case('D'):
            tmp = tmp + "1101";
            break;
        case('e'):
        case('E'):
            tmp = tmp + "1110";
            break;
        case('f'):
        case('F'):
            tmp = tmp + "1111";
            break;
        default:
            cout << inp[i] << endl;
            tmp = tmp + "XXXX";
            break;
        }
    }
    return tmp;
}


int main(int argc, char** argv)
{
	std::filesystem::path				Path2Code	=	"";	
	std::filesystem::path				Path2Outp	=	"";

    CLI::App app{"Assembly file to instruction memory file converter"};	
	app.add_option	("-i,-c,--input,--code-dir",	Path2Code,	"Path to Code.txt");
	app.add_option	("-o,--Output-dir",				Path2Outp,	"Output Directory");
	CLI11_PARSE(app, argc, argv);

	
    string a_line;
	std::filesystem::create_directory(Path2Outp);
    ifstream code_fil;  code_fil.open(Path2Code);
    ofstream non_Data;  non_Data.open(Path2Outp / ("non_Data.txt"));
    ofstream assembly;  assembly.open(Path2Outp / ("assembly.txt"));
    ofstream non_assm;  non_assm.open(Path2Outp / ("non_assembly.txt"));
    ofstream smi_assm;  smi_assm.open(Path2Outp / ("semi_assembly.txt"));
    ofstream mem_Addr;  mem_Addr.open(Path2Outp / ("Main_Mem_Addr.txt"));
    ofstream mem_Data;  mem_Data.open(Path2Outp / ("Main_Mem_Data.txt"));


    regex pattern("^[\t ]*([0-9a-fA-F]{1,8})[:]{1}[\t ]*([0-9a-fA-F]{8})[\t ]*([a-zA-Z.][a-zA-Z0-9,<>#()_\\+ \t !@~ | \\\\  &\\^\\$ '\".\\- %=\\*\\{\\} :;?\\[\\]]*)");
    regex pattern2("^[\t ]*([0-9a-fA-F]{1,8})[:]{1}[\t ]*([0-9a-fA-F]{4})[\t ]*([a-zA-Z.][a-zA-Z0-9,<>#()_\\+ \t !@~ | \\\\  &\\^\\$ '\".\\- %=\\*\\{\\} :;?\\[\\]]*)");

    smatch m;

    cout << "Analizing text file ..." << endl;
    int cntr(0);
    while (code_fil.is_open() && !code_fil.eof())
    {
        cntr++;
        if (cntr % 100 == 0)
        {
            cout << "\033[2K\r" << std::flush;
            cout << "line #" << cntr;
        }
        getline(code_fil, a_line);
        if (regex_search(a_line, m, pattern) && m.size() == 4)
        {
            if ((hex2uint(m.str(1)) % 4) == 0)
            {
                assembly << "0X" << hex_legth_fix(m.str(1), 8) << ":\t\t" << m.str(3) << endl;
                mem_Addr << hex_2_bin(hex_legth_fix(m.str(1), 8)) << endl;
                mem_Data << hex_2_bin(hex_legth_fix(m.str(2), 8)) << endl;
            }
            else
            {
                smi_assm << a_line << endl;
            }
        }
        else if (regex_search(a_line, m, pattern2) && m.size() == 4)
        {
            smi_assm << a_line << endl;
        }
        else
        {
            non_assm << a_line << endl;
        }
    }
    cout << "\033[2K\r" << std::flush;
    cout << "Analizing text file is done!" << endl << endl;

   
    code_fil.close();
    smi_assm.close();
    non_assm.close();
    assembly.close();
    mem_Addr.close();
    mem_Data.close();

    cout << "ALL DONE!" << endl;

    return 0;
}



