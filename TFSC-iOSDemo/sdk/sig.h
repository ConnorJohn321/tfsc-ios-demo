
#ifndef __SIG_H_
#define __SIG_H_


void *ImportEVP_PKEY(const unsigned char *buf, int buf_size);

bool ExportEVP_PKEY(unsigned char **buf, int *size);

bool sig_(const void *pkey, const unsigned char *message, int size_message,
          unsigned char **signature, int *size_signature);

bool verf_(const void *pkey, const unsigned char *message, int size_message,
           unsigned char *signature, int size_signature);

void *ImportFromHexStr(const char *str);

bool ExportToHexStr(const void *pkey, char **buf, int *size);

bool ExportMnemonic(const void *pkey,char ** buf,int *size);

void *ImportFromMnemonic(const char * mnemonic);

void getBase58addr_c(const void * pkey,char **buf,int *size);

void getPriStr_c(const void * pkey,char **buf,int *size);

void getPubStr_c(const void *pkey,char ** buf,int *size);

void toSig_c (void * pkey,const char * data,int size_m,char ** buf,int *size);


#endif
