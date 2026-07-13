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
    for (unsigned int i = 0; i < inp.size(); i++)
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
    for (unsigned int i = 0; i < inp.size(); i++)
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

string little_endian_correction(string inp)
{
    string val = "";
    for (int i = inp.size()-1; i > 0 ; i = i - 2)
    {
        val = val + inp[i-1] + inp[i];
    }
    return val;
}

int main(int argc, char** argv)
{
	std::filesystem::path				Path2Text	=	"";	
	std::filesystem::path				Path2Outp	=	"";

    CLI::App app{"Text file to instruction memory file converter"};	
	app.add_option	("-i,--input,--Text-dir",	Path2Text,	"Path to Text.txt");
	app.add_option	("-o,--output-dir",			Path2Outp,	"Output Directory");
	CLI11_PARSE(app, argc, argv);

    string a_line;
	std::filesystem::create_directory(Path2Outp);
    ifstream text_fil;  text_fil.open(Path2Text);
    ofstream non_Data;  non_Data.open(Path2Outp / ("non_Data.txt"));
    ofstream smi_assm;  smi_assm.open(Path2Outp / ("semi_assembly.txt"));
    ofstream mem_Addr;  mem_Addr.open(Path2Outp / ("Main_Mem_Addr.txt"));
    ofstream mem_Data;  mem_Data.open(Path2Outp / ("Main_Mem_Data.txt"));


    regex pattern4word("^[\t ]*([0-9a-fA-F]*)[\t ]*([0-9a-fA-F]{8})[\t ]*([0-9a-fA-F]{8})[\t ]*([0-9a-fA-F]{8})[\t ]*([0-9a-fA-F]{8})[\t ]*");
    regex pattern3word("^[\t ]*([0-9a-fA-F]*)[\t ]*([0-9a-fA-F]{8})[\t ]*([0-9a-fA-F]{8})[\t ]*([0-9a-fA-F]{8})[\t ]*");
    regex pattern2word("^[\t ]*([0-9a-fA-F]*)[\t ]*([0-9a-fA-F]{8})[\t ]*([0-9a-fA-F]{8})[\t ]*");
    regex pattern1word("^[\t ]*([0-9a-fA-F]*)[\t ]*([0-9a-fA-F]{8})[\t ]*");
    
    smatch m;

    cout << "Analizing text file ..." << endl;
    int cntr(0);
    while (text_fil.is_open() && !text_fil.eof())
    {
        cntr++;
        if (cntr % 100 == 0)
        {
            cout << "\033[2K\r" << std::flush;
            cout << "line #" << cntr;
        }
        getline(text_fil, a_line);
        if (regex_search(a_line, m, pattern4word) && m.size() == 6)
        {
            int addr = hex2uint(m.str(1));
            mem_Addr << int2bin(addr + 0, 32) << endl;
            mem_Addr << int2bin(addr + 4, 32) << endl;
            mem_Addr << int2bin(addr + 8, 32) << endl;
            mem_Addr << int2bin(addr + 12, 32) << endl;
            mem_Data << hex_2_bin(hex_legth_fix(little_endian_correction(m.str(2)), 8)) << endl;
            mem_Data << hex_2_bin(hex_legth_fix(little_endian_correction(m.str(3)), 8)) << endl;
            mem_Data << hex_2_bin(hex_legth_fix(little_endian_correction(m.str(4)), 8)) << endl;
            mem_Data << hex_2_bin(hex_legth_fix(little_endian_correction(m.str(5)), 8)) << endl;
        }
        else if (regex_search(a_line, m, pattern3word) && m.size() == 5)
        {
            int addr = hex2uint(m.str(1));
            mem_Addr << int2bin(addr + 0, 32) << endl;
            mem_Addr << int2bin(addr + 4, 32) << endl;
            mem_Addr << int2bin(addr + 8, 32) << endl;
            mem_Data << hex_2_bin(hex_legth_fix(little_endian_correction(m.str(2)), 8)) << endl;
            mem_Data << hex_2_bin(hex_legth_fix(little_endian_correction(m.str(3)), 8)) << endl;
            mem_Data << hex_2_bin(hex_legth_fix(little_endian_correction(m.str(4)), 8)) << endl;
        }
        else if (regex_search(a_line, m, pattern2word) && m.size() == 4)
        {
            int addr = hex2uint(m.str(1));
            mem_Addr << int2bin(addr + 0, 32) << endl;
            mem_Addr << int2bin(addr + 4, 32) << endl;
            mem_Data << hex_2_bin(hex_legth_fix(little_endian_correction(m.str(2)), 8)) << endl;
            mem_Data << hex_2_bin(hex_legth_fix(little_endian_correction(m.str(3)), 8)) << endl;
        }
        else if (regex_search(a_line, m, pattern1word) && m.size() == 3)
        {
            mem_Addr << hex_2_bin(hex_legth_fix(m.str(1), 8)) << endl;
            mem_Data << hex_2_bin(hex_legth_fix(little_endian_correction(m.str(2)), 8)) << endl;
        }
    }
    cout << "\033[2K\r" << std::flush;
    cout << "Analizing text file is done!" << endl << endl;

    
    text_fil.close();
    smi_assm.close();
    mem_Addr.close();
    mem_Data.close();

    cout << "ALL DONE!" << endl;

    return 0;
}



