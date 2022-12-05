#pragma once

int n_tu(int number, int count);
void ftoa(float f, char *r);
float atof(const char *s);
void itoa(unsigned int input, char* output, unsigned int base);
int atoi(const char* input);
char* strncpy(char* dest, const char *src, int num);
int strncmp(const char *s1, const char *s2, int num);
int strlen(const char* s);
bool constains(const char *source, const char target);
void bzero(void* memory, int length);
void memcpy(const void* src, void* dst, int num);
bool is_digit(char c);
bool is_decimal(const char *str);
bool is_float(const char *str);