#include <iostream>
#include <sstream>
#include <iomanip>
#include <fstream>
#include <string>
#include <regex>
#include "CLI11.hpp"

using namespace std;




unsigned int hex2uint(string inp)
{
    unsigned int tmp = 0;
    bool ridi(false);
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
            ridi = true;
            break;
        }
    }
    if (ridi)
        cout << "ridi:\t" << inp << endl;
    return tmp;
}

struct func_info
{
    std::string func_name;
    unsigned int SOFunc;
    unsigned int EOFunc;
};

bool find_func(std::vector<func_info> list, unsigned int pc, func_info &info)
{
    bool found(false);
    long long i;
    for (i = list.size() - 1; i >= 0; i--)
    {
        if (((int)pc >= (int)list[i].SOFunc) && ((int)pc <= (int)list[i].EOFunc))
        {
            info = list[i];
            found = true;
            break;
        }
    }
    return found;
}

int main(int argc, char** argv)
{
    bool verbose(false);
	std::filesystem::path				Path2Code	=	"";	
	std::filesystem::path				Path2Loge	=	"";
	std::filesystem::path				Path2Outp	=	"";

    
	CLI::App app{"Assembly file to instruction memory file converter"};	
	app.add_flag	("-v,--verbose,!--no-verbose",	verbose,	"Enable verbose output");
	app.add_option	("-i,--input,--code-dir",		Path2Code,	"Path to code.txt");
	app.add_option	("-l,--log",					Path2Loge,	"Path to log file");
	app.add_option	("-o,--output,--out-dir",		Path2Outp,	"Output directory");
	CLI11_PARSE(app, argc, argv);

	
    

    string a_line;
	std::filesystem::create_directory(Path2Outp);
    ifstream code_fil;  code_fil.open(Path2Code);
    ifstream trac_log;  trac_log.open(Path2Loge);
    ofstream trac_vis;  trac_vis.open(Path2Outp / ("Trace.txt"));
    ofstream Erro_fil;  Erro_fil.open(Path2Outp / ("Errors.txt"));


    func_info info = { "INT_VECTOR", 0, 0 };
    //int func_cntr(0);
    std::vector<func_info> List;
    smatch m;



    cout << "Analizing text file ..." << endl;
    cout << "Extarcting function info ..." << endl;
    regex Code_pattern("^([0-9a-fA-F]{8}) <([0-9A-Za-z_]+)>:");
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
        if (regex_search(a_line, m, Code_pattern))
        {
            unsigned int tmp = hex2uint(m.str(1));
            bool modif(false);
            if ((tmp % 8) != 0)
            {
                modif = true;
                tmp -= 4;
            }
            info.EOFunc = tmp - (!modif)*8;
            List.push_back(info);
            info.func_name = m.str(2);
            info.SOFunc = tmp;
        }
    }
    info.EOFunc = 0X7FFFFFFC;
    List.push_back(info);
    cout << "\033[2K\r" << std::flush;
    cout << "line #" << cntr << endl;
    cout << "Analizing text file is done!" << endl << endl;
    code_fil.close();

    if (verbose)
    {
        for (unsigned int i = 0; i < List.size(); i++)
        {
            std::ostringstream X1;
            std::ostringstream X2;
            X1 << std::hex << std::setw(8) << std::setfill('0') << List[i].SOFunc;
            X2 << std::hex << std::setw(8) << std::setfill('0') << List[i].EOFunc;
            cout << List[i].func_name << "\t<" << X1.str() << ", " << X2.str() << ">" << endl;
        }
    }


    cout << "Analizing Log file ..." << endl;
    cout << "Tracing Program Counter ..." << endl;
    regex Trac_pattern("^([0-9a-fA-F]{8})@([0-9]*)");
    cntr = 0;
    int lvl(1);
    //int main_lvl(0);
    //bool met_main(false);
    //bool was_walking(false);
    int ecntr(0);
    int correct(0);
    string old_func("INT_VECTOR");
    string new_func("");
    int    old_PC(0XDEADBEEF);
    int    PC;
    bool found(false);
    //bool error(false);
    while (trac_log.is_open() && !trac_log.eof())
    {
        cntr++;
        if (cntr % 100 == 0)
        {
            cout << "\033[2K\r" << std::flush;
            cout << "line #" << cntr;
        }
        getline(trac_log, a_line);
        if (verbose)
            cout << "line #" << cntr << ":\t" << a_line << endl;
        if (regex_search(a_line, m, Trac_pattern))
        {
            PC = hex2uint(m.str(1));
            string time = m.str(2);
            //if (time == "125085")
            //    cout << "here" << endl;
            // check if it jumpt or returned
            found = find_func(List, PC, info);
            new_func = info.func_name;
            //error = !found;
            //if ((!met_main) && (new_func == "main"))
            //{
            //    met_main = true;
            //    main_lvl = lvl;
            //}
            //if (new_func == "main")
            //    lvl = main_lvl;
            
            if (found)
            {
                //  If new function is the same as the old function, 
                //  Then,
                //      Nothing happened.
                if (new_func == old_func)
                {
                    old_PC = PC;
                    correct++;
                    continue;
                }
                //  If the new PC moves to another function
                //  Then
                //      We have a situation.
                else
                {
                    // Maybe calling a function? 
                    if (PC == (int)info.SOFunc)
                    {
                        // if we are walking, it's passing, not calling
                        if (PC == old_PC + 8)
                        {
                            correct++;
                            //was_walking = true;
                            continue;
                        }
                        // If the change in PC is more than 8,
                        // we can say that it might be a calling 
                        else
                        {
                            lvl++;
                            old_func = new_func;
                            trac_vis << "(" << m.str(1) << " @ " << std::setw(8) << m.str(2) << ")" << "\t\t";
                            for (int j = 0; j < lvl; j++)
                                trac_vis << "\t";
                            trac_vis << old_func << endl;
                            if (verbose)
                            {
                                cout << "(" << m.str(1) << " @ " << std::setw(8) << m.str(2) << ")" << "\t\t";
                                for (int j = 0; j < lvl; j++)
                                    cout << "\t";
                                cout << old_func << endl;
                            }
                            old_PC = PC;
                            correct++;
                            //was_walking = false;
                            continue;
                        }
                    }
                    // Passing By, Return, Or INTERRUPT
                    if ((PC > (int)info.SOFunc) && (PC <= (int)info.EOFunc))
                    {
                        //cout << PC << endl;
                        //cout << ((int)info.SOFunc + 8) << endl;
                        // Passing By
                        if (PC == ((int)info.SOFunc + 8))
                        {
                            if (info.func_name == "main")
                                lvl = 3;
                            old_func = info.func_name;
                            trac_vis << "(" << m.str(1) << " @ " << std::setw(8) << m.str(2) << ")" << "\t\t";
                            for (int j = 0; j < lvl; j++)
                                trac_vis << "\t";
                            trac_vis << old_func << endl;
                            if (verbose)
                            {
                                cout << "(" << m.str(1) << " @ " << std::setw(8) << m.str(2) << ")" << "\t\t";
                                for (int j = 0; j < lvl; j++)
                                    cout << "\t";
                                cout << old_func << endl;
                            }
                            old_PC = PC;
                            correct++;
                            //was_walking = false;
                            continue;
                        }
                        // Return OR INTERRUPT
                        else
                        {
                            // INTERRUPT
                            if (info.func_name == "INT_VECTOR")
                            {

                                lvl = 5;
                                old_func = info.func_name;
                                trac_vis << endl << endl;
                                trac_vis << "(" << m.str(1) << " @ " << std::setw(8) << m.str(2) << ")" << "\t\t";
                                for (int j = 0; j < lvl; j++)
                                    trac_vis << "\t";
                                trac_vis << old_func << endl;
                                if (verbose)
                                {
                                    cout << endl << endl;
                                    cout << "(" << m.str(1) << " @ " << std::setw(8) << m.str(2) << ")" << "\t\t";
                                    for (int j = 0; j < lvl; j++)
                                        cout << "\t";
                                    cout << old_func << endl;
                                }
                                old_PC = PC;
                                correct++;
                                //was_walking = false;
                                continue;
                            }
                            // Return
                            else
                            {
                                if (info.func_name == "main")
                                    lvl = 4;
                                lvl--;
                                if (lvl <= 0)
                                    lvl = 0;
                                old_func = info.func_name;
                                trac_vis << "(" << m.str(1) << " @ " << std::setw(8) << m.str(2) << ")" << "\t\t";
                                for (int j = 0; j < lvl; j++)
                                    trac_vis << "\t";
                                trac_vis << old_func << endl;
                                if (verbose)
                                {
                                    cout << "(" << m.str(1) << " @ " << std::setw(8) << m.str(2) << ")" << "\t\t";
                                    for (int j = 0; j < lvl; j++)
                                        cout << "\t";
                                    cout << old_func << endl;
                                }
                                old_PC = PC;
                                correct++;
                                //was_walking = false;
                                continue;
                            }
                        }
                    }
                    // If error
                    cout << "Terminated, CAN NOT DETERMINE the type of jump!" << endl;
                    cout << "\t" << a_line << endl;
                    cout << "\t" << PC << ", \t" << (int)info.SOFunc << endl;
                    ecntr ++;
                    Erro_fil << a_line << endl;
                    break;
                }
            }
            else
            {
                cout << "Terminated, the functions DID NOT FOUND!" << endl; 
                ecntr ++;
                Erro_fil << a_line << endl;
                break;
            }
        }
        if (a_line.empty())
        {
            correct++;
            continue;
        }
        else
        {
            cout << "Terminated, NOT A LINE! (" << a_line << ")" << endl;
            ecntr++;
            Erro_fil << a_line << endl;
            break;
        }
    }
    info.EOFunc = 0XFFFFFFFC;
    List.push_back(info);
    cout << "\033[2K\r" << std::flush;
    cout << "line #" << cntr << endl;
    cout << "error= " << ecntr << endl;
    cout << "correct= " << correct << endl;
    cout << "Tracing is done!" << endl << endl;
    trac_log.close();
    trac_vis.close();
    Erro_fil.close();

    cout << "ALL DONE!" << endl;

    return 0;
}



