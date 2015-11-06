/*
cdecode.h - c header for a base64 decoding algorithm

This is part of the libb64 project, and has been placed in the public domain.
For details, see http://sourceforge.net/projects/libb64
*/

#ifndef BASE64_CDECODE_H
#define BASE64_CDECODE_H

typedef enum
{
	step_a, step_b, step_c, step_d
} dc_base64_decodestep;

typedef struct
{
	dc_base64_decodestep step;
	char plainchar;
} dc_base64_decodestate;

void dc_base64_init_decodestate(dc_base64_decodestate* state_in);

int dc_base64_decode_value(char value_in);

unsigned long dc_base64_decode_block(const char* code_in, const unsigned long length_in, char* plaintext_out, dc_base64_decodestate* state_in);

#endif /* BASE64_CDECODE_H */
