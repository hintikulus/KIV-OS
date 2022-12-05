#include <stdstring.h>
#include <stdfile.h>
#include <stdmutex.h>
#include <stdbuffer.h>
#include <stdmemory.h>

#include <drivers/bridges/uart_defs.h>

#define VALUE_ARRAY_SIZE 40

using namespace buffer_constants;

struct Parameters;

void swap(Parameters arr[], int pos1, int pos2);

void Quicksort(Parameters v[], int start, int end);

unsigned int rand(uint32_t file, uint32_t output_start, uint32_t output_end);

double abs(double x) {
    return x < 0 ? -x : x;
}

/**
 * Struktura pro uchovavni parametru a jejich ohodnoceni
 */
struct Parameters {

    double rank, a, b, c, d, e;

    double bt(double y) {
        return d / e * (1.0 / (24.0 * 60.0 * 60.0)) + 1 / e * y;
    }

    /**
     * Vypocet fitness funkce
     * @param t_pred
     * @param y_real
     * @return
     */
    double fitness(double t_pred, double y_real) {
        // y(t + t_pred) = A * b(t) + B * b(t) * (b(t) - y(t)) + C
        double ans = bt(t_pred) * a + b * bt(t_pred) * (bt(t_pred) - t_pred) + c;
        // rank is the result between y(t + t_pred) and y(t)
        rank = abs(ans - y_real);

        return ans;
    }
};

static void fputs(uint32_t file, const char *string) {
    write(file, string, strlen(string));
}

static void fgets(uint32_t file, char *buf, int size) {
    read(file, buf, size);
}

/**
 * Cteni radky vstupu
 * @param file
 * @param buffer
 */
void await_input(uint32_t file, char *buffer) {
    char *buf = new char[1];

    double input;
    fputs(file, ">");

    while (1) {
        fgets(file, buf, 1);
        if (buf[0] == '\r') //buf[0] == '\u000D' | buf[0] == '\x0D' | buf[0] == '\015'|
        {
            fputs(file, "\n");
            int i = circBuffer.GetDifference();
            for (int x = 0; x < i; x++) {
                char out = circBuffer.Pull();
                buffer[x] = out;
                //fputs(uart_file, &out); // zopakuje zadany vstup
            }
            buffer[i] = '\0';
            break;
        }
        circBuffer.Push(buf[0]);
        fputs(file, buf);
    }
}

/**
 * Vypsani celeho cisla
 * @param file
 * @param label
 * @param value
 */
void print_int_value_line(uint32_t file, const char *prefix, int value, const char *suffix) {
    char buffer[50];

    fputs(file, prefix);
    itoa(value, buffer, 10);
    fputs(file, buffer);
    fputs(file, suffix);
}

/**
 * Vyspani cisla s desetinnou teckou
 * @param file
 * @param label
 * @param value
 */
void print_float_value_line(uint32_t file, const char *prefix, float value, const char *suffix) {
    char buffer[50];

    fputs(file, prefix);
    ftoa(value, buffer);
    fputs(file, buffer);
    fputs(file, suffix);
}

/**
 * Cteni celeho cisla ze vstupu
 * @param file
 * @param input_buffer
 * @return
 */
int read_integer(uint32_t file, char *input_buffer) {
    while (1) {
        await_input(file, input_buffer);
        if (!is_decimal(input_buffer)) {
            fputs(file, "Nesprávný vstup. Zadejte celočíselnou hodnotu.\n");
            continue;
        }

        return atoi(input_buffer);
    }
}

/**
 * Cteni cisla s pohyblivou desetinnou teckou ze vstupu
 * @param file
 * @param input_buffer
 * @return
 */
float read_float(uint32_t file, char *input_buffer) {
    while (1) {
        await_input(file, input_buffer);
        if (!is_float(input_buffer)) {
            fputs(file, "Nesprávný vstup. Zadejte číslo prosím.\n");
            continue;
        }

        return atof(input_buffer);
    }
}

/**
 * Vypis parametru modelu
 * @param file
 * @param population
 * @param input_buffer
 */
void print_params(uint32_t file, Parameters population, char *input_buffer) {
    print_float_value_line(file, "A = ", population.a, ", ");
    print_float_value_line(file, "B = ", population.b, ", ");
    print_float_value_line(file, "C = ", population.c, ", ");
    print_float_value_line(file, "D = ", population.d, ", ");
    print_float_value_line(file, "E = ", population.e, "\n");
}

/**
 * Vstupni bod do casti programu s vypoctem
 * @param file
 * @return
 */
int program(uint32_t file) {
    int t_delta; // velikost krokovani (minuty)
    int t_pred; // vzdalenost predikce (minuty)
    int time; // probehly cas (minuty)
    float values[VALUE_ARRAY_SIZE];
    int index = 0;

    uint32_t trng_file = open("DEV:trng", NFile_Open_Mode::Read_Only);

    char *input_buffer = new char[buffer_constants::BUFFER_SIZE];

    /*
     * Definice krokovani a predikce
     */

    // Cteni krokovani
    t_delta = read_integer(file, input_buffer);
    print_int_value_line(file, "OK, krokovani ", t_delta, " minut\n");

    // Cteni velikosti predikce
    t_pred = read_integer(file, input_buffer);
    print_int_value_line(file, "OK, predikce ", t_pred, " minut\n");

    /*
     * Priprava genetickeho algoritmu
     */

    time = 0;

    const int SOLUTION_SIZE = 100;

    Parameters populations[SOLUTION_SIZE];

    // Generace populace
    for (int i = 0; i < SOLUTION_SIZE; i++) {
        populations[i] = Parameters{
                0,
                (double) rand(trng_file, 0, 30),
                (double) rand(trng_file, 0, 30),
                (double) rand(trng_file, 0, 30),
                (double) rand(trng_file, 0, 30),
                (double) rand(trng_file, 0, 30)
        };
    }

    /*
     * Vstup od uzivatele
     */

    while (1) {
        await_input(file, input_buffer);
        int input_size = strlen(input_buffer);

        // Vstup je prazdny retezec
        if (input_size == 0) {
            continue;
        }

        // Je zadan prikaz stop
        if (!strncmp(input_buffer, "stop", input_size)) {
            continue;
        }

        // Je zadan prikaz parameters
        if (!strncmp(input_buffer, "parameters", input_size)) {
            print_params(file, (populations[0]), input_buffer);
            continue;
        }

        // Vstup je hodnota y(t)
        if (is_float(input_buffer)) {
            float value = atof(input_buffer);
            values[index] = value;

            if (time < t_pred) {
                time += t_delta;
                fputs(file, "NaN\n");
            } else {
                fputs(file, "Pocitam...\n");

                for (int i = 0; i < SOLUTION_SIZE; i++) {
                    populations[i].fitness(values[(index - (t_pred / t_delta)) % VALUE_ARRAY_SIZE], values[index]);
                }

                // Razeni populace dle fitness funkce
                Quicksort(populations, 0, SOLUTION_SIZE - 1);


                const int SAMPLE_SIZE = 100;
                Parameters sample[SOLUTION_SIZE];

                for (int x = 0; x < SOLUTION_SIZE; x++) {
                    sample[x] = populations[x];
                }

                for (int i = 0; i < SOLUTION_SIZE; i++) {
                    populations[i] = (Parameters{
                            0,
                            sample[rand(trng_file, 0, SAMPLE_SIZE - 1)].a,
                            sample[rand(trng_file, 0, SAMPLE_SIZE - 1)].b,
                            sample[rand(trng_file, 0, SAMPLE_SIZE - 1)].c,
                            sample[rand(trng_file, 0, SAMPLE_SIZE - 1)].d,
                            sample[rand(trng_file, 0, SAMPLE_SIZE - 1)].e,
                    });
                }

                // Mutace populace
                for (int j = 0; j < SOLUTION_SIZE; ++j) {
                    (populations[j]).a *= (rand(trng_file, 99, 101) / 100.0);
                    (populations[j]).b *= (rand(trng_file, 99, 101) / 100.0);
                    (populations[j]).c *= (rand(trng_file, 99, 101) / 100.0);
                    (populations[j]).d *= (rand(trng_file, 99, 101) / 100.0);
                    (populations[j]).e *= (rand(trng_file, 99, 101) / 100.0);
                }
                
                for (int i = 0; i < SOLUTION_SIZE; i++) {
                    populations[i].fitness(values[(index - (t_pred / t_delta)) % VALUE_ARRAY_SIZE], values[index]);
                }

                // Razeni populace dle fitness funkce
                Quicksort(populations, 0, SOLUTION_SIZE - 1);

                float result_value = populations[0].fitness(values[(index - (t_pred / t_delta)) % VALUE_ARRAY_SIZE],
                                                            values[index]);

                ftoa(result_value, input_buffer);
                print_float_value_line(file, "", result_value, "\n");
            }

            index = (index + 1) % VALUE_ARRAY_SIZE;

            continue;
        }

        // Vstup je nekorektni resp. neni prikaz ani hodnota
        fputs(file, "Nekorektni vstup\n");
    }

    return 0;
}

/**
 * Hlavni vstup do programu / procesu
 * @param argc
 * @param argv
 * @return
 */
int main(int argc, char **argv) {
    uint32_t uart_file = open("DEV:uart/0", NFile_Open_Mode::Read_Write);
    TUART_IOCtl_Params params;
    params.baud_rate = NUART_Baud_Rate::BR_115200;
    params.char_length = NUART_Char_Length::Char_8;
    ioctl(uart_file, NIOCtl_Operation::Set_Params, &params);

    fputs(uart_file,
          "CalcOS v1.0\nAutor: Jan Hinterholzinger (A22N0045P)\n"
          "Zadejte nejprve casovy rozestup a predikcni okenko v minutach\n"
          "Dale podporovany prikazy: stop, parameters\n");

    circBuffer.Claim();

    // Spusteni podprogramu s vypoctem
    program(uart_file);

    return 0;
}

/**
 * Metoda pro ziskani pseudonahodneho cisla v danem rozsahu
 * @param file
 * @param output_start
 * @param output_end
 * @return
 */
unsigned int rand(uint32_t file, uint32_t output_start, uint32_t output_end) {
    uint32_t input_start = 0;
    uint32_t input_end = 4294967295;

    uint32_t num = 0;
    read(file, reinterpret_cast<char *>(&num), sizeof(num));
    double slope = 1.0 * (output_end - output_start) / (input_end - input_start);
    return output_start + slope * (num - input_start);
}

// last element is taken as pivot
int Partition(Parameters v[], int start, int end) {

    int pivot = end;
    int j = start;
    for (int i = start; i < end; i++) {
        if (v[i].rank < v[pivot].rank) {
            swap(v, i, j);
            ++j;
        }
    }
    swap(v, j, pivot);
    return j;

}

void swap(Parameters arr[], int pos1, int pos2) {
    Parameters temp = arr[pos1];
    arr[pos1] = arr[pos2];
    arr[pos2] = temp;
}

/**
 * Implementace QuickSortu pro razeni populaci dle fitness funkce
 * @param v
 * @param start
 * @param end
 */
void Quicksort(Parameters v[], int start, int end) {
    if (start < end) {
        int p = Partition(v, start, end);
        Quicksort(v, start, p - 1);
        Quicksort(v, p + 1, end);
    }
}

